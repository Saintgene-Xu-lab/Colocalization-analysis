// to count the number of cell mask in image
path = File.openDialog("Select a Log File");
results_savePath = getDir("Choose a Directory to save count results tabel");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
print("\\Clear");
print("the log window has been cleared!");
print("CountLine: " + nLineCount);
run("ROI Manager...");
setBatchMode(true);
fileName_array = newArray(nLineCount);
counts_array = newArray(nLineCount);

for (nLine=0;nLine<nLineCount;nLine++)
{
   
    line = strLines[nLine];
    open(line);
    current_imageName = getInfo("image.filename");
	print("Now processing: " + current_imageName);
	selectWindow(current_imageName);
	roiManager("reset");
	
	run("Label image to ROIs", "rm=[RoiManager[size=9, visible=true]]");
	
	count = roiManager("count");
	
	////////////////////////////////////////
	// save the results to array
	fileName_array[nLine] = current_imageName;
	counts_array[nLine]=count;
	//////////////////////////////////////
    print(count);
	close("*");
}
////////////////////////////////////////////
// assign array to table, then save this table
table_count = "results_of_counts";
Table.create(table_count);
Table.setColumn("fileName", fileName_array);
Table.setColumn("Count", counts_array);
path_save = results_savePath + "/results_of_counts.csv";
saveAs("results",path_save);
///////////////////////////////////////////////
run("Close");
setBatchMode(false);







