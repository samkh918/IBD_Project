library(ggplot2)
library(plyr)
library(reshape2)
library(scales)

args = commandArgs(trailingOnly=TRUE)



processFile = function(filepath) {
  con = file(filepath, "r")
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    cat ("\n")


    print(line)
    spline <- unlist(strsplit(line, '	'))
    j <- as.numeric(spline[2:5])
    y <- c(j)
    m <- matrix(y, ncol=2)
    res <- chisq.test(m, correct=FALSE)
    print (res)
  }

  close(con)
}


processFile(args[1])
