#!/bin/bash

#PBS -N transcript_amplification
#PBS -l nodes=1:ppn=1,mem=4g,vmem=4g,walltime=36:00:00
#PBS -o /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_transcript_amplification/transcript_amplification_output.txt
#PBS -e /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_transcript_amplification/transcript_amplification_error.txt

module load R
module load python/2.7.9
VEP_term=transcript_amplification


## 1st Part
## Three arguments are passed to the first Python file (Step1...py):
##	1) VEP_term
##	2) /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26
##	3) Input Family file
##	4) Frequency Cut Off
##	5) Zygosity
python /hpf/largeprojects/ccmbio/samkh/bioinf_rep/SCRIPTS_PYTHON/VCF_geneName_Extract/Revised_MutationLevel_noMNPs_HSC_0.01_HEToct13/Step0c_ObtainMutationList.py ${VEP_term} /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26 /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt 0.01 HET

