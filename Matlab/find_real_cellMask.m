
% batch processing
strFn_Gmask_log = "D:\Project\Segmentation\Counts_colocalize_files\rawImage_40x_5th\C2-647_C3-marker_C4-488\Split_Channels_AND_Rename_file\Red_channel\Merge2DAPI\Segmented_mask\Segmented_mask.log";
strFn_DAPImask_log = "D:\Project\Segmentation\Counts_colocalize_files\rawImage_40x_5th\C2-647_C3-marker_C4-488\Split_Channels_AND_Rename_file\Blue_channel\Segmented_mask\Segmented_mask.log";
strFn_G_BO_log = "D:\Project\Segmentation\Counts_colocalize_files\rawImage_40x_5th\C2-647_C3-marker_C4-488\Split_Channels_AND_Rename_file\Red_channel\single_channel\GF3_Threshold-Yen_AreaOpen200\GF3_Threshold-Yen_AreaOpen200.log";

FileSv_path = "D:\Project\Segmentation\Counts_colocalize_files\rawImage_40x_5th\C2-647_C3-marker_C4-488\Split_Channels_AND_Rename_file";

if ~exist('rc_image', 'dir')
    mkdir(FileSv_path,'rc_image');
end


    

lines_Gmask = readlines(strFn_Gmask_log,"EmptyLineRule","skip");
lines_DAPImask = readlines(strFn_DAPImask_log,"EmptyLineRule","skip");
lines_G_BO = readlines(strFn_G_BO_log,"EmptyLineRule","skip");

count_Num = length(lines_Gmask);







nNC_thresh = 60;
nGC_thresh = 100;



for nFile = 1:count_Num
    % get image file name of three
imgFn_Gmask = lines_Gmask(nFile,1);
imgFn_DAPImask = lines_DAPImask(nFile,1);
imgFn_G_BO = lines_G_BO(nFile,1);
   
    
% read image
G_mask = imread(imgFn_Gmask);
DAPI_mask = imread(imgFn_DAPImask);
G_BO = imread(imgFn_G_BO);

iMax = max(G_mask,[],'all');
G_mask_rc = zeros(size(G_mask),'like',G_mask);
iL_rc = 0;
for iL=1:iMax
    idx=find(G_mask==iL);
    nNC = length(find(DAPI_mask(idx)>0));
    nGC = length(find(G_BO(idx)>0));
    if(nNC>nNC_thresh&&nGC>nGC_thresh)
        iL_rc = iL_rc+1;
        G_mask_rc(idx) = iL_rc;
    end
end
[~,name,~] = fileparts(imgFn_Gmask);
fileName = strcat(name,"_rc.tif");

fn_save = fullfile(FileSv_path,"rc_image",fileName);
imwrite(G_mask_rc,fn_save);
end



