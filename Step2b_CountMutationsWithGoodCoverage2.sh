#!/bin/bash


#PBS -N VEP_mutations_0002
#PBS -l nodes=1:ppn=1,mem=6g,vmem=6g,walltime=72:00:00
#PBS -o /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_stop_lost/stop_lost_output_0002.txt
#PBS -e /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_stop_lost/stop_lost_error_0002.txt

module load R
module load python/2.7.9
VEP_term=stop_lost


## 1st Part
## Three arguments are passed to the first Python file (Step1...py):
##	1) VEP_term
##	2) /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26
##	3) Input Family file
##	4) Frequency Cut Off
##	5) Zygosity
##	6) 0002
python /hpf/largeprojects/ccmbio/samkh/bioinf_rep/SCRIPTS_PYTHON/VCF_geneName_Extract/Revised_MutationLevel_noMNPs_HSC_0.01_HEToct26/Step2c_CountMutationsWithGoodCoverage.py ${VEP_term} /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26 /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt 0.01 HET 0002

Rscript /hpf/largeprojects/ccmbio/samkh/bioinf_rep/SCRIPTS_PYTHON/VCF_geneName_Extract/Revised_MutationLevel_noMNPs_HSC_0.01_HEToct26/Step2d_chisq_input_reader.R /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_${VEP_term}/Step2c_${VEP_term}_chisq_0002.txt

python /hpf/largeprojects/ccmbio/samkh/bioinf_rep/SCRIPTS_PYTHON/VCF_geneName_Extract/Revised_MutationLevel_noMNPs_HSC_0.01_HEToct26/Step2e_VEP_Statsresults_reader.py ${VEP_term} /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26 0002

