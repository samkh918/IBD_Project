#!/bin/bash


#PBS -N VEP_mutations_SUB
#PBS -l nodes=1:ppn=1,mem=6g,vmem=6g,walltime=72:00:00
#PBS -o COMMON_FOLDER/MutationLevel_VEP_Category/Category_output_SUB.txt
#PBS -e COMMON_FOLDER/MutationLevel_VEP_Category/Category_error_SUB.txt

module load R
module load python/2.7.9
VEP_term=Category


## 1st Part
## Three arguments are passed to the first Python file (Step1...py):
##	1) VEP_term
##	2) COMMON_FOLDER
##	3) Input Family file
##	4) Frequency Cut Off
##	5) Zygosity
##	6) SUB
python CURRENT_DIRECTORY/Step2c_CountMutationsWithGoodCoverage.py ${VEP_term} COMMON_FOLDER INPUT_FAMILY_FILE FREQ_CUTOFF ZYGOSITY SUB

Rscript CURRENT_DIRECTORY/Step2d_chisq_input_reader.R COMMON_FOLDER/MutationLevel_VEP_${VEP_term}/Step2c_${VEP_term}_chisq_SUB.txt

python CURRENT_DIRECTORY/Step2e_VEP_Statsresults_reader.py ${VEP_term} COMMON_FOLDER SUB

