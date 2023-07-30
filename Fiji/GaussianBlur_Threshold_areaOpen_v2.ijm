path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
print("\\Clear");
print("the log window has been cleared!");
print("CountLine: " + nLineCount);
setBatchMode(true);
// this script is to get the positive area of image by Despeckle, Gaussian blur, Auto threshold and area open. 
for (nLine=0;nLine<nLineCount;nLine++)
{
	
	// open image
	open(strLines[nLine]);
	current_imageName = getInfo("image.filename");
	print("now processing " + current_imageName);
	selectWindow(current_imageName);
	bit_type = bitDepth();
               if (bit_type == 8) {
    	run("16-bit");
                }
	path = getInfo("image.directory");
	path_sv = path +".\\RenyEntropy_AreaOpen150\\";
	if(!File.exists(path_sv))
	{
		File.makeDirectory(path_sv);
	}
	// function field
	// remove non-specifity spot
	run("Despeckle");
	// substract background, this function 
	// run("Subtract Background...", "rolling=50");
	
	// run("Gaussian Blur...", "sigma=2");
	// the auto threshold algorithm is dependent on the image propertiers
	run("Auto Threshold", "method=MaxEntropy white");
	// run("Auto Threshold", "method=RenyEntropy white");
	// run("Auto Threshold", "method=Triangle white");
	// run("Auto Threshold", "method=Ostu white");
	// run("Auto Threshold", "method=Yen white");
    run("Area Opening", "pixel=150");
    imageName_areaOpen = getTitle();
    selectWindow(imageName_areaOpen);
    run("Fill Holes (Binary/Gray)");
    imageName_Threshold = getTitle();
    
    selectWindow(imageName_Threshold);
	nChar = lengthOf(current_imageName);
    sub_str= substring(current_imageName,0,nChar-4);
    new_image_name = sub_str + "_Thresholded" + ".tif";
    saveAs("Tiff", path_sv + new_image_name);
    close("*");
  	
	
}

setBatchMode(false);