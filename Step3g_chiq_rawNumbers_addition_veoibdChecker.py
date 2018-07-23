import os, sys, re, string


myinput = sys.argv [ 1 ] ## This is the file that contains the sorted, significant Bonferroni p-values and we want to add the raw chisq numbers to it
chisq_input = sys.argv [ 2 ] ## This is where the raw chisq numbers come from

filename = os.path.basename(myinput)
dirname = os.path.dirname(myinput)


noxlsFilename=filename.strip(".xls")
outputFilename =  noxlsFilename.replace("3fc","3fd") + "_RawNumbs_VeoibdAnns.xls"

myoutput = dirname +"/"+ outputFilename

##### INPUT and OUTPUT #####
inputFile = open(myinput, "r")
chisqInput = open(chisq_input, "r")

outputFile = open(myoutput,"w")


veoibd_list = ["ADA", "ADAM17", "AICDA", "CYBA", "TTC37","WAS"]



myList = inputFile.readlines()
chisqList = chisqInput.readlines()

for myLine in myList:
	spLine = myLine.split("\t")

	if "Bonferroni" in myLine:
		continue

	Found = False
	for chisqLine in chisqList:
		chisq_spLine = chisqLine.split("\t")

		## When the matching gene names is found in the "significant" list and the "chisq raw data" file
		if spLine[0].strip() == chisq_spLine[0].strip():
			outputFile.write(chisqLine.strip("\n")+"\t"+myLine.strip("\n"))
			Found = True
			break
	#if Found:
	#	outputFile.write("\n")

	if not Found:
		outputFile.write("notFound!!!\t"+myLine.strip("\n"))

	# Check for the veoibd designation
	#if spLine[0].strip() in veoibd_list:
	if spLine[0].split("_")[0] in veoibd_list:
		outputFile.write("\tVeoibd\n")
	else:
		outputFile.write("\t-\n")
			

inputFile.close()
outputFile.close()
