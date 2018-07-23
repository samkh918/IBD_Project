#!/bin/bash

## NOTE: When using "sed" commands, the path names can't have "/" and should be replaced by "\/" as shown ##
## NOTE: When you put {} around the variable, it may complain about the "/" but not when you put single quotes, check this again!
## NOTE: If you have file path in your variable (like the $PWD) below, it's better to change the sed delimiter to "|" so it doesn't confuse it with the "/" in the file path

##------------------------------------ User Defined -------------------------------------------------------------
#OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_Friday_freq1"
#OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_Friday_freq1"

OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"
OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"

Input_family_file="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt"
Input_family_file2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_families\/1and2family_sorted_HSC.txt"

Freq_cutoff=0.01
Zygosity=HET ## Possible options: HOM, HET, HOMHET



mkdir -p $OutputPath

echo -e "Time run: \n"$(date) > $OutputPath/log.txt
echo -e "\nOutputPath: \n"$OutputPath >> $OutputPath/log.txt
echo -e "\nInput_Family_File: \n"${Input_family_file} >> $OutputPath/log.txt
echo -e "\nFrequency cut off: \n"${Freq_cutoff} >> $OutputPath/log.txt
echo -e "\nZygosity counted: \n"${Zygosity} >> $OutputPath/log.txt

# The folowing are the High and Low impact VEP categories obtained from their website
for term in frameshift_variant inframe_deletion inframe_insertion missense_variant protein_altering_variant splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost transcript_ablation transcript_amplification;
#for term in frameshift_variant;
	do 
		mkdir -p $OutputPath/MutationLevel_VEP_${term}
		rm -f $OutputPath/MutationLevel_VEP_${term}/*.*
		echo $term 

		## Performing multiple sed replacements at the same time
		sed 's/Category/'"$term"'/g; s/COMMON_FOLDER/'${OutputPath2}'/g; s/INPUT_FAMILY_FILE/'${Input_family_file2}'/g; s|CURRENT_DIRECTORY|'$PWD'|g; s/FREQ_CUTOFF/'${Freq_cutoff}'/g; s/ZYGOSITY/'${Zygosity}'/g' Step0b_ObtainMutationList_RunStep0c.sh > Step0b_ObtainMutationList_RunStep0c_2.sh

		chmod u+x Step0b_ObtainMutationList_RunStep0c_2.sh
		qsub Step0b_ObtainMutationList_RunStep0c_2.sh
done

