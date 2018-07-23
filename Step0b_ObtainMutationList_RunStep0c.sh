#!/bin/bash

#PBS -N Category
#PBS -l nodes=1:ppn=1,mem=4g,vmem=4g,walltime=10:00:00
#PBS -o COMMON_FOLDER/MutationLevel_VEP_Category/Category_output.txt
#PBS -e COMMON_FOLDER/MutationLevel_VEP_Category/Category_error.txt

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
python CURRENT_DIRECTORY/Step0c_ObtainMutationList.py ${VEP_term} COMMON_FOLDER INPUT_FAMILY_FILE FREQ_CUTOFF ZYGOSITY

