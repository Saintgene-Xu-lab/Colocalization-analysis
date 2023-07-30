// merge DAPI channel to other channel
// 
interest_path = File.openDialog("Select a Log File which is interest");
DAPI_path = File.openDialog("Select a Log File which is like DAPI");
// interest_path = "D:/Project/Segmentatio/Counts_colocalize_files/20230701_rawImage_20x_3rd/After_split_And_rename/Red_channel/Red_channel.log";
// DAPI_path = "D:/Project/Segmentation/Counts_colocalize_files/20230701_rawImage_20x_3rd/After_split_And_rename/Blue_channel/Blue_channel.log";

fn_merge_prefix = "_merge";

strLog_Interest = File.openAsString(interest_path);
strLog_DAPI = File.openAsString(DAPI_path);

strLines_Interest=split(strLog_Interest,"\n");
strLines_DAPI=split(strLog_DAPI,"\n");

nLineCount_Interest = lengthOf(strLines_Interest);
nLineCount_DAPI = lengthOf(strLines_DAPI);
print("\\Clear");
print("the log window has been cleared!");
print("CountLine Of interest: " + nLineCount_Interest);
print("CountLine Of DAPI: " + nLineCount_DAPI);

setBatchMode(true);

for (nLine_interest=0;nLine_interest<nLineCount_Interest;nLine_interest++)
{
	line_interest=strLines_Interest[nLine_interest];
	line_DAPI=strLines_DAPI[nLine_interest];
	
	open(line_interest);
	fn_interest = getInfo("image.filename");
	path = getInfo("image.directory");
	path_sv = path +".\\Merge2DAPI\\";
	
	if(!File.exists(path_sv))
	{
		File.makeDirectory(path_sv);
	}
	
	open(line_DAPI);
	fn_DAPI = getInfo("image.filename");
	
	run("Merge Channels...", "c1=["+fn_interest+"] c3=[" + fn_DAPI+ "] create");
	
	print("Now processing: ",fn_DAPI,fn_interest);
    nChar = lengthOf(fn_interest);
    sub_saveFn= substring(fn_interest,0,nChar-4);
	saveFn = sub_saveFn + fn_merge_prefix + ".tif";
	saveAs("Tiff", path_sv + saveFn);
	print("saving image:......" + saveFn + " .......Has done!");
	close("*");	
}
setBatchMode(false);