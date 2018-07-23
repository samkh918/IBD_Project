#!/bin/bash


#PBS -N VEP_term
#PBS -l nodes=1:ppn=1,mem=6g,vmem=6g,walltime=72:00:00
#PBS -o COMMON_FOLDER/MutationLevel_VEP_Category/Category_output_final.txt
#PBS -e COMMON_FOLDER/MutationLevel_VEP_Category/Category_error_final.txt

module load R
module load python/2.7.9
VEP_term=Category

#while [ ! -f COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/${VEP_term}_MultTestCorctInput.txt ]; do sleep 30m; echo "still waiting! "date; done


## Move all the broken files to one "BrokenFiles" folder
mkdir -p COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_MultTestCorctInput_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_output_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_error_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_PatientsList_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_Pvalues_uncorrected_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_ExcludeFromChiSquareAnalysis_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_MutationsAllMembers_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles
mv COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/*_chisq_* COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/BrokenFiles


Rscript CURRENT_DIRECTORY/Step3fa_chisquare_MultTestCorrection.R COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step2e_${VEP_term}_MultTestCorctInput.txt ${VEP_term} COMMON_FOLDER


## Combining precorrection, FDR, and Bonferroni Excel sheets into one "Combined_Stats.xls" file
echo -e "Mutation\t\tPreCorrection\t\t\t\tFDR\t\t\t\tBonferroni" > COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fb_${VEP_term}_Combined_Stats.xls

paste COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fa_PreCorr.xls COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fa_FDR.xls COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fa_Bonferroni.xls >> COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fb_${VEP_term}_Combined_Stats.xls

awk '$6 < 0.05' COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fb_${VEP_term}_Combined_Stats.xls > COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fb_${VEP_term}_Combined_Stats_signif.xls


## 3rd Part
## Add the raw chisq table numbers, and annotate with veoibd
python CURRENT_DIRECTORY/Step3g_chiq_rawNumbers_addition_veoibdChecker.py COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fb_${VEP_term}_Combined_Stats_signif.xls COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step2c_${VEP_term}_chisq.txt


## Remove the redundant gene names from the final output
echo -e "Mutation\t\t\tRaw_Data\t\tPreCorrection\tFDR\tBonferroni\tVeoibd" > COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fe_${VEP_term}_Combined_Stats_signif_RawNumbs_VeoibdAnns_FINAL_FILE.xls

cut -f 1-5,7,9,11,12 COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fd_${VEP_term}_Combined_Stats_signif_RawNumbs_VeoibdAnns.xls > COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/${VEP_term}_temp_FINAL_FILE.xls
sort -g -k8 COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/${VEP_term}_temp_FINAL_FILE.xls >> COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step3fe_${VEP_term}_Combined_Stats_signif_RawNumbs_VeoibdAnns_FINAL_FILE.xls
rm COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/${VEP_term}_temp_FINAL_FILE.xls
