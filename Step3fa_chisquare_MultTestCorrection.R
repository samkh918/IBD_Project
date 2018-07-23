library(ggplot2)
library(plyr)
library(reshape2)
library(scales)

args = commandArgs(trailingOnly=TRUE)

VEP_term <- args[2]
COMMON_FOLDER <- args[3]


# Read in the data
x <- scan(args[1], what="", sep="\n")


# Separate elements by one or more whitepace
y <- strsplit(x, "[[:space:]]+")

# Extract the first vector element and set it as the list element name
names(y) <- sapply(y, `[[`, 1)

y <- lapply(y, `[`, -1)



PreCorrlist <- function(x) { 
        nams=names(x) 
        for (i in seq_along(x) ) {
		write(paste(nams[i],"\t",x[[i]]), paste(COMMON_FOLDER,"/MutationLevel_VEP_",VEP_term,"/Step3fa_PreCorr.xls", sep=""), append=TRUE)	
	}
}


Bonferronilist <- function(x) { 
        nams=names(x) 
        for (i in seq_along(x) ) {
		write(paste(nams[i],"\t",x[[i]]), paste(COMMON_FOLDER,"/MutationLevel_VEP_",VEP_term,"/Step3fa_Bonferroni.xls", sep=""), append=TRUE)	
	}
}

FDRlist <- function(x) { 
        nams=names(x) 
        for (i in seq_along(x) ) {
		write(paste(nams[i],"\t",x[[i]]), paste(COMMON_FOLDER,"/MutationLevel_VEP_",VEP_term,"/Step3fa_FDR.xls", sep=""), append=TRUE)	
	}
}


j<-PreCorrlist(y)

m<-p.adjust(y,"bonferroni")
m2<-Bonferronilist(m)

k<-p.adjust(y,"fdr")
k2<-FDRlist(k)



