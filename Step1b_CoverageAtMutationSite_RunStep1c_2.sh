#!/bin/bash

#PBS -N stop_lost_IBD_SAMPLE_FILE
#PBS -l nodes=1:ppn=1,mem=4g,vmem=4g,walltime=100:00:00
#PBS -o /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_stop_lost/stop_lost_output.txt
#PBS -e /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26/MutationLevel_VEP_stop_lost/stop_lost_error.txt

module load R
VEP_term=stop_lost

split_folder="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_folders_stat/split/"

source /hpf/largeprojects/ccmbio/samkh/bioinf_rep/SCRIPTS_PYTHON/VCF_geneName_Extract/Revised_MutationLevel_noMNPs_HSC_0.01_HEToct26/Step1c_CoverageAtMutationSite_samtools.sh ${VEP_term} /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26 ${split_folder}IBD_SAMPLE_FILE


