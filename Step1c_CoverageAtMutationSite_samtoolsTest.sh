#!/bin/bash


inputFile=/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_frameshift_variant/Step0c_frameshift_variant_MutationsAllMembers.txt
IBD_sampleInput=/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_folders_stat/split/IBD_2600samples_aa

while IFS='' read -r mutation || [[ -n "$mutation" ]]; do

	IFS="_" read -a myarray <<< "$mutation"
	IFS='-' read -a myarray2 <<< "${myarray[1]}"
	MutSpot=${myarray2[0]}:${myarray2[1]}-${myarray2[1]}
	## I had tried to type tab in the line below in the past but it didn't work, it turned out that first I have to type "Ctrl+V" first before typing the tab, so that it recognizes the tabs correctly in the input
        #IFS="	" read -a myarray3 <<< "$mutation"
        IFS=$'\t' read -a myarray3 <<< "$mutation"

        while IFS='' read -r sample || [[ -n "$sample" ]]; do
                echo ${myarray3[0]}_${sample}:: 
        done <$IBD_sampleInput

done <$inputFile
