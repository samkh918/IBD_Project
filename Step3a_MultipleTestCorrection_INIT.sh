#!/bin/bash

## NOTE: When using "sed" commands, the path names can't have "/" and should be replaced by "\/" as shown ##
## NOTE: When you put {} around the variable, it may complain about the "/" but not when you put single quotes, check this again!
## NOTE: If you have file path in your variable (like the $PWD) below, it's better to change the sed delimiter to "|" so it doesn't confuse it with the "/" in the file path

##------------------------------------ User Defined -------------------------------------------------------------

#sleep 1m

OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"
OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"

Input_family_file="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt"
Input_family_file2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_families\/1and2family_sorted_HSC.txt"


Freq_cutoff=0.01
Zygosity=HET ## Possible options: HOM, HET, HOMHET

#Range=$1
#Current_directory=$1
Current_directory=$PWD

#if [ "$#" -ne 1 ]; then
#	echo "Please provide the current path!"
#	exit
#fi


#for term in missense_variant;
for term in frameshift_variant inframe_deletion inframe_insertion missense_variant protein_altering_variant splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost transcript_ablation transcript_amplification;
#for term in frameshift_variant;

	do 

		## Concatenate the "MultTestCorctInput_*" and "chisq_*" files which will be used in subsequent steps
		cat ${OutputPath}/MutationLevel_VEP_${term}/Step2c_${term}_chisq_* > ${OutputPath}/MutationLevel_VEP_${term}/Step2c_${term}_chisq.txt
		cat ${OutputPath}/MutationLevel_VEP_${term}/Step2e_${term}_MultTestCorctInput_* > ${OutputPath}/MutationLevel_VEP_${term}/Step2e_${term}_MultTestCorctInput.txt


		## Performing multiple sed replacements at the same time
		sed 's/Category/'"${term}"'/g; s/COMMON_FOLDER/'${OutputPath2}'/g; s/INPUT_FAMILY_FILE/'${Input_family_file2}'/g; s|CURRENT_DIRECTORY|'${Current_directory}'|g; s/FREQ_CUTOFF/'${Freq_cutoff}'/g; s/ZYGOSITY/'${Zygosity}'/g; s/SUB/'"$sub"'/g' Step3b_MultipleTestCorrection.sh > Step3b_MultipleTestCorrection2.sh

		chmod u+x Step3b_MultipleTestCorrection2.sh
		qsub Step3b_MultipleTestCorrection2.sh
done
