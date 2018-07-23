#!/bin/bash

#sleep 1h

module load samtools


VEP_term=$1
COMMON_FOLDER=$2
IBD_sampleInput=$3
IBD_sampleInput_basename=$(basename $IBD_sampleInput)


align_dir=/hpf/largeprojects/ccmbio/ibd_project/Data/forge_output_Jan2017/alignment

## This is obtained in Step0
#inputFile=$COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/${VEP_term}_Allmutations.txt
inputFile=$COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step0c_${VEP_term}_MutationsAllMembers.txt

rm -f $COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/coverageFiles/${VEP_term}_${IBD_sampleInput_basename}_coverages.txt

mkdir -p $COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/coverageFiles

while IFS='' read -r mutation || [[ -n "$mutation" ]]; do

	## Obain the mutation spot (MutSpot) from the mutation name, to be used in the next "samtools view bamfile MutSpot" step
	IFS="_" read -a myarray <<< "$mutation"
	IFS='-' read -a myarray2 <<< "${myarray[1]}"
	MutSpot=${myarray2[0]}:${myarray2[1]}-${myarray2[1]}
        ## I had tried to type tab in the line below in the past but it didn't work, it turned out that first I have to type "Ctrl+V" first before typing the tab, so that it recognizes the tabs correctly in the input
        #IFS="	" read -a myarray3 <<< "$mutation"
	## It turned out that the above line worked but when it was copied into another file, the tabs would get converted to spaces! Therefore the following approach is used which works
        IFS=$'\t' read -a myarray3 <<< "$mutation"
	

	while IFS='' read -r sample || [[ -n "$sample" ]]; do
		echo -n ${myarray3[0]}_${sample}::   >> $COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/coverageFiles/${VEP_term}_${IBD_sampleInput_basename}_coverages.txt
		samtools view $align_dir/$sample/$sample.sorted.dup.recal.bam $MutSpot | wc -l >> $COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/coverageFiles/${VEP_term}_${IBD_sampleInput_basename}_coverages.txt
	done <$IBD_sampleInput

done <$inputFile
