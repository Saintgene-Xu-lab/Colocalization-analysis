// auto sorting the different image with varied imaging objective to their own directory
path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
print("\\Clear");
print("CountLine: " + nLineCount);
setBatchMode(true);
for (nLine=0;nLine<nLineCount;nLine++)
{
	
	// open image
	open(strLines[nLine]);
	
	//function field
	//////////////////////////////////////////////////////////
	
	current_imageName = getInfo("image.filename");
	print("Now processing: " + current_imageName);
	// creat a new directory
	path = getInfo("image.directory");
	path_sv_20x = path +".\\20x_image\\";
	path_sv_40x = path +".\\40x_image\\";
	if(!File.exists(path_sv_20x))
	{
		File.makeDirectory(path_sv_20x);
	}
	if(!File.exists(path_sv_40x))
	{
		File.makeDirectory(path_sv_40x);
	}
	
	getPixelSize(unit, pixelWidth, pixelHeight, pixelDepth);
	pixelCompare = "" + pixelWidth;
	if (unit == "micron") {
		if (pixelCompare == "0.6215") {
			print("current image is 20x, and the pixelWidth is " +  pixelWidth);
			// 可能是该句导致图片保存下来的会有选择框
			// selectWindow(current_imageName);
			
			saveAs("Tiff",path_sv_20x + current_imageName);
		}
		else {
			print("current image is 40x, and the pixelWidth is " +  pixelWidth);
			saveAs("Tiff",path_sv_40x + current_imageName);
			// 40x pixelWidth == 0.3107403
			
		}
	}
	close("*");
	
	
		
}
	
setBatchMode(false);