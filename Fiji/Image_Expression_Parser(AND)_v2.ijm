// merge DAPI channel to other channel
interest_path = File.openDialog("Select a Log File which is interest");
DAPI_path = File.openDialog("Select a Log File which is like DAPI");
save_dir = getDir("choose a save director");
fn_merge_prefix = "_Colocalization";

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
	
	path_sv = save_dir +".\\Image_parser_Colocalization\\";
	
	if(!File.exists(path_sv))
	{
		File.makeDirectory(path_sv);
	}
	
	open(line_DAPI);
	fn_DAPI = getInfo("image.filename");
	run("Image Expression Parser (Macro)", "expression=(A>0)*B a=[" +
	      fn_interest + "] b=[" + 
	      fn_DAPI + "] c=None d=None");
	 setMinAndMax(0,65535);
	 setOption("ScaleConversions", true);
	 run("16-bit");
	 imageName_Colocalization = getTitle();
	 run("Area Opening", "pixel=100");
	 imageName_areaOpen = getTitle();
	 selectWindow(imageName_areaOpen);
	 print("Now processing: ",fn_DAPI + "\n" + fn_interest);
     nChar = lengthOf(fn_interest);
     sub_saveFn= substring(fn_interest,0,nChar-22);
	 saveFn = sub_saveFn + fn_merge_prefix + ".tif";
	 saveAs("Tiff", path_sv + saveFn);
	 print("saving image:......" + saveFn + " .......Has done!");
	 close("*");	
}
setBatchMode(false);