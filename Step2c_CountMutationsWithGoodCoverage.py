from __future__ import division
import os, sys, re, string
import datetime, subprocess, gzip, ast


# By: Sam Khalouei
# Created on:
# Last updated: 

# Purpose:
# Input:
# Output: 

# ToDo:

VEP_term = sys.argv [ 1 ]
COMMON_FOLDER = sys.argv [ 2 ]
INPUT_FAMILY_FILE = sys.argv [ 3 ] ## The family input file that lists the family numbers (specified in the original bash script file)
FREQ_CUTOFF = sys.argv [ 4 ]
ZYGOSITY = sys.argv [ 5 ] ## Can be HOM, HET, HOMHET
SUB = sys.argv [ 6 ]

############################## INPUT #################################

pedFile=open("/hpf/largeprojects/ccmbio/jfoong/neilibd/Regeneron/1and2ped.txt","r")
mypedList = pedFile.readlines()

samples2600=open("/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_folders_stat/IBD_2600samples.txt","r")
samples2600list= samples2600.readlines()

samples2600memANDphen=open("/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_folders_stat/IBD_mem_and_phen_2600.txt","r")
samples2600memANDphen_list = samples2600memANDphen.readlines()

## The above line is used with "missense" where there are many variants
AllMutations = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step0c_"+VEP_term+"_MutationsAllMembers_"+SUB,"r")
AllMutationsList = AllMutations.readlines()

###########################  OUTPUT  ##################################

mutations_chisq = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step2c_"+VEP_term+"_chisq_"+SUB+".txt","w")

Patients_list = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step2c_"+VEP_term+"_PatientsList_"+SUB+".txt","w")


##################### Lists and Variables ##############################

## These two dictionaries are  used to add the gene mutations found in the VCF files (i.e. key) and also in how many VCF files it has been seen (i.e. value) FOR BOTH affected AND unaffected
all_mutations=[]


subprocess.call("mkdir -p "+COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/coverageFiles/FinalizedCoverage", shell=True)


NumberMutationsDropped=0

for mutationLine in AllMutationsList:
        sp_mutationLine = mutationLine.split("\t") ## split the line so that first element will be the mutation and the second element a list, with members suffixed by "_Aff" and "_Unaff"
        mutation = sp_mutationLine[0]
        mut_patient_list = ast.literal_eval(sp_mutationLine[1].strip())
        mut_patient_list = [n.strip() for n in mut_patient_list]

        yesMut_Aff=0
        yesMut_Unaff=0
        Patients_list.write( mutation + "\t" + str(mut_patient_list) +  "\n" )


	subprocess.call("rm -f "+COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/coverageFiles/FinalizedCoverage/Step2c_"+VEP_term+"_WORKED_"+SUB+".txt", shell=True)


	for patient in mut_patient_list:
		if "_Aff" in patient:
			yesMut_Aff += 1
		elif "_Unaff" in patient:
			yesMut_Unaff += 1

	Patients_list.write("withMut_Aff: "+str(yesMut_Aff)+"\n")
	Patients_list.write("withMut_Unaff: "+str(yesMut_Unaff)+"\n")

	if (yesMut_Aff <= 9 and yesMut_Unaff <= 9):
		NumberMutationsDropped += 1
	        Patients_list.write("Dropped--> observed in few Aff and Unaff samples. ##### numbers dropped: "+str(NumberMutationsDropped)+"\n")
		continue

	modified = map(lambda it: it.replace("_Aff",""), mut_patient_list)
	modified2= map(lambda it: it.replace("_Unaff",""), modified)

	for sample in samples2600list:
		if sample.strip() in modified2: ## if the sample had the mutation skip it, we're interested in samples that didn't have/show the mutations to check the coverage
			continue
		else: ## check the first letter of the mutation gene and assign the "Sub" accordingly so that the right file will be searched
			Sub=""
			if mutation.startswith("A"): Sub="A"
			elif mutation.startswith("B"): Sub="B"
			elif mutation.startswith("C"): Sub="C"
			elif mutation.startswith("D"): Sub="D"
			elif mutation.startswith("E"): Sub="E"
			elif mutation.startswith("F"): Sub="F"
			elif mutation.startswith("G"): Sub="G"
			elif mutation.startswith("H"): Sub="H"
			elif mutation.startswith("I"): Sub="I"
			elif mutation.startswith("J"): Sub="J"
			elif mutation.startswith("K"): Sub="K"
			elif mutation.startswith("L"): Sub="L"
			elif mutation.startswith("M"): Sub="M"
			elif mutation.startswith("N"): Sub="N"
			elif mutation.startswith("O"): Sub="O"
			elif mutation.startswith("P"): Sub="P"
			elif mutation.startswith("Q"): Sub="Q"
			elif mutation.startswith("R"): Sub="R"
			elif mutation.startswith("S"): Sub="S"
			elif mutation.startswith("T"): Sub="T"
			elif mutation.startswith("U"): Sub="U"
			elif mutation.startswith("V"): Sub="V"
			elif mutation.startswith("W"): Sub="W"
			elif mutation.startswith("X"): Sub="X"
			elif mutation.startswith("Y"): Sub="Y"
			elif mutation.startswith("Z"): Sub="Z"


			subprocess.call("grep "+mutation+"_"+sample.strip()+" "+COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/coverageFiles/FinalizedCoverage/"+VEP_term+"_IBD_2600samples_all_coverages_"+Sub+".txt | awk -F '::' '$2 >= 10' >> "+COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/coverageFiles/FinalizedCoverage/Step2c_"+VEP_term+"_WORKED_"+SUB+".txt", shell=True)


	myGrepFile=open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/coverageFiles/FinalizedCoverage/Step2c_"+VEP_term+"_WORKED_"+SUB+".txt","r")
	myGrepList=myGrepFile.readlines()


	noMut_Aff=0
	noMut_Unaff=0
	for grep in myGrepList:
		for s in samples2600memANDphen_list:
			s_split = s.split("__")
			Sample = s_split[0]
			phen = s_split[1].strip()

			if Sample.strip() in grep:
				#print "matched"
				if phen == '1':
					noMut_Unaff += 1
				elif phen == '2':
					noMut_Aff +=1

	
	Patients_list.write("noMut_Aff:  "+str(noMut_Aff)+"\n")
	Patients_list.write("noMut_Unaff:  "+str(noMut_Unaff)+"\n")
	myGrepFile.close()
		

        print (mutation, ": ", "yesMut_Aff: ", yesMut_Aff, ", noMut_Aff: ", noMut_Aff, ", yesMut_Unaff: ", yesMut_Unaff,  ", noMut_Unaff: ", noMut_Unaff, "\n")
        mutations_chisq.write(mutation+"\t"+str(yesMut_Aff)+"\t"+str(noMut_Aff)+"\t"+str(yesMut_Unaff)+"\t"+str(noMut_Unaff)+"\n")


print ("Number of mutations Dropped due to presence in few samples: ", NumberMutationsDropped)


mutations_chisq.close()
Patients_list.close()
samples2600.close()
