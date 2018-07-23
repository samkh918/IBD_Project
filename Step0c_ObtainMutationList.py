from __future__ import division
import os, sys, re, string
import datetime, subprocess, gzip



VEP_term = sys.argv [ 1 ]
COMMON_FOLDER = sys.argv [ 2 ]
INPUT_FAMILY_FILE = sys.argv [ 3 ] ## The family input file that lists the family numbers (specified in the original bash script file)
FREQ_CUTOFF = sys.argv [ 4 ]
ZYGOSITY = sys.argv [ 5 ] ## Can be HOM, HET, HOMHET

############################## INPUT #################################

myfamilyInput = open(INPUT_FAMILY_FILE,'r') 
myfamilyList = myfamilyInput.readlines()

pedFile=open("/hpf/largeprojects/ccmbio/jfoong/neilibd/Regeneron/1and2ped.txt","r")
mypedList = pedFile.readlines()

###########################  OUTPUT  ##################################
Allmutations_output = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step0c_"+VEP_term+"_Allmutations.txt","w")

MutationsAllMembers = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step0c_"+VEP_term+"_MutationsAllMembers.txt","w")

##################### Lists and Variables ##############################
all_mutations=[]
mutations_all_members={}

NumberPhenUnknown=0


## Going through each family
for myfamilyLine in myfamilyList:
        familyspline=myfamilyLine.split(":")
        memList=familyspline[1].split(",")

	if familyspline[0]=='0':
		continue

        else:
                family=familyspline[0]
		print (family)

		# Put the line (with gzip ...) from above here and change the "16078" to "family" and also indent all the lines below to be under this section
		#with gzip.open('/hpf/largeprojects/ccmbio/jfoong/neilibd/Regeneron/170317_index_sam_vcfs/family_samples_merge/all_family_009/'+family+'/'+family+'.hg38_multianno.anno.vcf.gz', 'r') as f:
		with gzip.open('/hpf/largeprojects/ccmbio/jfoong/neilibd/Regeneron/170317_index_sam_vcfs/family_samples_merge/all_family_013/'+family+'/'+family+'.hg38_multianno.anno.vcf.gz', 'r') as f:
		    myList = f.readlines()

		## Go through the VCF lines of each family (Note: all members of this family are in this file)
		for myLine in myList:
			if '##' in myLine:
				continue


			elif "#CHROM" in myLine:
                                spline=myLine.split("\t")
                                membersList=spline[9:] ## family members can be 2 or more so this list is dynamic
                                phenotype_list=['unknown']*len(membersList)

                                ## for each member in this family check all the lines in the pedigree file and if there is a match obtain the phenotype
                                j=0
                                for mem in membersList:
                                        for pedline in mypedList:
                                                pedLine_sp=pedline.split("\t")
                                                if mem.strip() == pedLine_sp[1].strip():
                                                        phenotype_list[j]=pedLine_sp[5].strip() ## Add the phenotype to the phenotype_list
                                                        if pedLine_sp[5].strip() == '0':
                                                                NumberPhenUnknown+=1
                                                        break
                                        j+=1

                                print (phenotype_list)


			else: ## Going through the variants list

                                if VEP_term not in myLine: ## if variant does not belong to VEP_term category go to the next variant
                                        continue


				if "CALLERS=GATK_HC,Vardict;" in myLine:
					continue


				spline=myLine.split("\t")
				InfoField=spline[7]
				InfoFieldSpt=InfoField.split(";")


				## Obtain the "max_aaf_all" frequency of this variant and if it's bigger than 0.01, skip the variant
                                max_aaf_all=InfoFieldSpt[-1].strip("max_aaf_all=")
                                if float(max_aaf_all) > float(FREQ_CUTOFF):
                                        continue


                                for section in InfoFieldSpt:
                                        if ("ENSG" in section and VEP_term in section):
                                                CSQ_field=section.split(",")
                                                for field in CSQ_field: ## CSQ field can have multiple transcripts and different genes! We are only interesed in the one with VEP_term
                                                        if VEP_term in field:
                                                                VCFgeneName=field[field.index("ENSG")+16:field.index("ENST")-1]
								VCFgeneAndMutation = VCFgeneName + "_" + spline[0] + "-" + spline[1] + "-" + spline[3] + "-" + spline[4] + "_" + VEP_term
									
                                                                break ## NOTE: once we find the VEP_term in one of the fields we won't search the rest of the fields


				# Add this mutation to AllMutations list if it's not already there
				if (VCFgeneAndMutation not in all_mutations):
					all_mutations.append(VCFgeneAndMutation)



				GenotypeList = spline[9:]
                                i = 0 ## iterate through the Genotype List
                                for Genotype in GenotypeList:
                                        sp_Genotype = Genotype.split(":")

                                        ## Based on the Zygosity specified by the user, count the variants for unaffected and affected
                                        if ((ZYGOSITY == "HOM" and sp_Genotype[0] == "1/1") or \
                                                (ZYGOSITY == "HET" and sp_Genotype[0] == "0/1") or \
                                                (ZYGOSITY == "HOMHET" and (sp_Genotype[0] == "0/1" or sp_Genotype[0] == "1/1"))):


                                                if phenotype_list[i] == '1': ## unaffected member
                                                        if VCFgeneAndMutation in mutations_all_members:
                                                                mutations_all_members[VCFgeneAndMutation].append(membersList[i].strip()+"_Unaff")
                                                        else:
								mutations_all_members[VCFgeneAndMutation] = [membersList[i].strip()+"_Unaff"]


                                                elif phenotype_list[i] == '2': ## affected member

                                                        if VCFgeneAndMutation in mutations_all_members:
                                                                mutations_all_members[VCFgeneAndMutation].append(membersList[i].strip()+"_Aff")
                                                        else:
								mutations_all_members[VCFgeneAndMutation] = [membersList[i].strip()+"_Aff"]

                                        i+=1 ## Go to the next genotype


print ("Number of all mutations: ", len(all_mutations))
for mutation in all_mutations:
	Allmutations_output.write(mutation+"\n")


## Going through the mutations_all_members dictionary and writing it to the "MutationsAllMembers" file
NumberMutationsDropped=0
k=0
for mutation in mutations_all_members:

        k+=1
        MutationsAllMembers.write(mutation + "\t" + str(mutations_all_members[mutation]) +  "\n")

print ("Number of mutations in 'mutations_all_members': ", k)
print ("Number Phen Uknown': ", NumberPhenUnknown)

	

myfamilyInput.close()
Allmutations_output.close()
MutationsAllMembers.close()
pedFile.close()

