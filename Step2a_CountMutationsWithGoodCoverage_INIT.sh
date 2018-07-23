#!/bin/bash


OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"
OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"

Input_family_file="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt"
Input_family_file2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_families\/1and2family_sorted_HSC.txt"


Freq_cutoff=0.01
Zygosity=HET ## Possible options: HOM, HET, HOMHET

#Current_directory=$1
Current_directory=$PWD

## The following check was necessary when "Current_directory" was supplied as argument
#if [ "$#" -ne 1 ]; then
#	echo "Please provide the current path as argument!"
#	exit
#fi


mkdir -p $OutputPath

echo -e "Time run: \n"$(date) > $OutputPath/log.txt
echo -e "\nOutputPath: \n"$OutputPath >> $OutputPath/log.txt
echo -e "\nInput_Family_File: \n"${Input_family_file} >> $OutputPath/log.txt
echo -e "\nFrequency cut off: \n"${Freq_cutoff} >> $OutputPath/log.txt
echo -e "\nZygosity counted: \n"${Zygosity} >> $OutputPath/log.txt


#term=missense_variant
for term in frameshift_variant inframe_deletion inframe_insertion missense_variant protein_altering_variant splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost transcript_ablation transcript_amplification;
	do
                mkdir -p $OutputPath/MutationLevel_VEP_${term}
                rm -f $OutputPath/MutationLevel_VEP_${term}/*chisq.txt
                rm -f $OutputPath/MutationLevel_VEP_${term}/*Combined*.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/*FDR*.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/*PreCorr*.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/*Bonferroni*.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/*ExcludeFromChiSquareAnalysis.txt
                rm -f $OutputPath/MutationLevel_VEP_${term}/*FINAL_FILE.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/*PatientsList.txt
                rm -f $OutputPath/MutationLevel_VEP_${term}/*MultTestCorctInput.txt
                rm -f $OutputPath/MutationLevel_VEP_${term}/*Pvalues_uncorrected.xls
                rm -f $OutputPath/MutationLevel_VEP_${term}/Step0c_${term}_MutationsAllMembers_*
                echo $term


		## Break down the Mutations list (which is particularly needed for "missense" and "frameshift" variants) and obtain the "Range" which is the "number of generated files"
		num="$(wc -l $OutputPath/MutationLevel_VEP_${term}/Step0c_${term}_MutationsAllMembers.txt | cut -f1 -d" ")"
	
		if [ $num -eq 0 ]; then continue; fi ## if there are no mutations for this VEP term then skip it

		split -a 4 -d -l 200 $OutputPath/MutationLevel_VEP_${term}/Step0c_${term}_MutationsAllMembers.txt $OutputPath/MutationLevel_VEP_${term}/Step0c_${term}_MutationsAllMembers_
		Range="$(ls $OutputPath/MutationLevel_VEP_${term}/Step0c_${term}_MutationsAllMembers_* | wc -l )"


		for ((c=0000; c<"$Range"; c++ ));
			do 
				sub=$(printf "%04d\n" $c)
				## Performing multiple sed replacements at the same time
				sed 's/Category/'"${term}"'/g; s/COMMON_FOLDER/'${OutputPath2}'/g; s/INPUT_FAMILY_FILE/'${Input_family_file2}'/g; s|CURRENT_DIRECTORY|'${Current_directory}'|g; s/FREQ_CUTOFF/'${Freq_cutoff}'/g; s/ZYGOSITY/'${Zygosity}'/g; s/SUB/'"$sub"'/g' Step2b_CountMutationsWithGoodCoverage.sh > Step2b_CountMutationsWithGoodCoverage2.sh

				chmod u+x Step2b_CountMutationsWithGoodCoverage2.sh
				qsub Step2b_CountMutationsWithGoodCoverage2.sh
		done
done

