from __future__ import division
import os, sys, re, string
import datetime, subprocess, gzip



VEP_term = sys.argv [ 1 ]
COMMON_FOLDER = sys.argv [ 2 ]
SUB = sys.argv [ 3 ]

###########################  INPUT  ##################################
myStatInput = open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/"+VEP_term+"_output_"+SUB+".txt",'r') 
myStatList = myStatInput.readlines()

###########################  OUTPUT  ##################################
Excel_output= open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step2e_"+VEP_term+"_Pvalues_uncorrected_"+SUB+".xls","w") 
multitest_output=open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step2e_"+VEP_term+"_MultTestCorctInput_"+SUB+".txt","w")
Exception_output=open(COMMON_FOLDER+"/MutationLevel_VEP_"+VEP_term+"/Step2e_"+VEP_term+"_ExcludeFromChiSquareAnalysis_"+SUB+".txt","w")



## Going through each family
for myLine in myStatList:
        if '[1]' in myLine:
                spline = myLine.split("\\t")
		if (spline[1].strip() == '0' and spline[3].strip() == '0'): # Both values of Aff_mut and Unaff_mut are 0 which result in pvalues=NA, so exclude these cases
			Exception_output.write("No yesGene in affected or unaffected, most likely due to yesGene belonging to 'unknown':\n"+myLine+"\n")
			continue
		elif (spline[2].strip() == '0' and spline[4].strip() == '0'): # Both values of Aff_mut and Unaff_mut are 0 which result in pvalues=NA, so exclude these cases
			Exception_output.write("All affected and unaffected members had this Gene VEP mutation: \n"+myLine+"\n")
			continue
		Excel_output.write(spline[0][4:]+"\t"+spline[1]+"\t"+spline[2]+"\t"+spline[3]+"\t"+spline[4][0:-1]+"\t")
		multitest_output.write(spline[0][5:]+" ")

	elif "X-squared" in myLine:
		spline2 = myLine.split(" ")
		if spline2[-1].strip() == "NA":
			continue
		Excel_output.write(spline2[-1])
		multitest_output.write(spline2[-1])


myStatInput.close()
Excel_output.close()
multitest_output.close()
Exception_output.close()
