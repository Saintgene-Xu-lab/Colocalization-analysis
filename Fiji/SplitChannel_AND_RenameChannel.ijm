// this script split the channel, and rename each channel with prefix
path = File.openDialog("Select a Log File");
strLog = File.openAsString(path);
strLines=split(strLog,"\n");
nLineCount = lengthOf(strLines);
print("CountLine: " + nLineCount);

setBatchMode(true);
// assign the marker name to each channel, and based on the file name pattern 
// to capture the prefix to each channel
C1_prefix = "_DAPI";
C2_prefix = "_smi";
C3_prefix = "_Marker";
C4_prefix = "_NeuN";
// marker color for finding the prefix of red channel
capture_color = "555";
//Channel_array = Array.filter(strlines,"C\d");
for (nLine=0;nLine<nLineCount;nLine++)
{
	
	line=strLines[nLine];
	
	// open(line);
	run("Bio-Formats Windowless Importer", "open=["+ line + "]");
	// function field
	//////////////////////////////////////////
	// this function is design for rename a file
	
	current_imageName = getInfo("image.filename");
	print("Now processing: " + current_imageName);
	path = getInfo("image.directory");
	path_sv = path +".\\Split_Channels_AND_Rename_file\\";
	
	if(!File.exists(path_sv))
	{
		File.makeDirectory(path_sv);
	}
	
	
	
	
	// first get the name of active image
	selectWindow(current_imageName);
	Channel_Num = Property.getNumber("SizeC");
	print("This image have: " + Channel_Num + " Channels");
	Channel_array = newArray("C1-", "C2-", "C3-", "C4-"); 
	
	name_array = split(current_imageName);
	capture_prefix = loop_for_marker_name(name_array,capture_color);
	C3_prefix = "_" + capture_prefix;
	Channel_prefix = newArray(C1_prefix,C2_prefix,C3_prefix,C4_prefix);
	print("the red channel prefix is " + capture_prefix);
	
	
	
	
	run("Split Channels");
	
	for (i=0; i<Channel_Num;i++)
	{
		
		
		splitChannel_str =  Channel_array[i] + current_imageName;
		selectWindow(splitChannel_str);
		
		reName_file(splitChannel_str, Channel_prefix[i]);
	
	
		
	}
	close("*");
	

	
	
	
	
}
setBatchMode(false);




function reName_file(channel_fn,fileName_prefix)
{
	// select active image
	str_length = lengthOf(channel_fn);
	subString_CurrentImg = substring(channel_fn, 3,str_length-4);
	fn_save = subString_CurrentImg  + fileName_prefix + ".tif";
	
	selectWindow(channel_fn);
	saveAs("Tiff",path_sv + fn_save);
	close();
	
	
	
}

function loop_for_marker_name(name_array,capture_key)
	{
		numWord = lengthOf(name_array);
		for (ii=0;ii<numWord;ii++)
		{
			if (matches(name_array[ii],capture_key))
			   {
			   	idx = ii - 1;
			   	capture_name = name_array[idx];
			   	
				return capture_name;
				break;

			   }
			else {
                 continue;
		          }
	    }
	}

