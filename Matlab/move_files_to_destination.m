% 该脚本的目的是为了根据文件名称分类移动到相应的文件夹
% give a path dir which include all the file


reference_dir = "D:\Project\Segmentation\Counts_colocalize_files\batch_image\all_in_one\40x_image\sorted\40x_image_red";

clFiles = FindFiles_RegExp("\.tif$",reference_dir);
clDirs =["D:\Project\Segmentation\Counts_colocalize_files\batch_image\all_in_one\40x_image\sorted\40x_image_blue";
    "D:\Project\Segmentation\Counts_colocalize_files\batch_image\all_in_one\40x_image\sorted\40x_image_green";
    "D:\Project\Segmentation\Counts_colocalize_files\batch_image\all_in_one\40x_image\sorted\40x_image_red"];

nDirCount = length(clDirs);
clTiffFns = cell(1,nDirCount);
strRegExp = "\.tif$";
for nDir = 1:nDirCount
    clTiffs = FindFiles_RegExp(strRegExp, clDirs(nDir), false)';
    clTiffFns(nDir) = {clTiffs};
end

% remove the extention of file name

str_fileName = string(clFiles)';
fileName_Marker = str_fileName;
for nFn = 1:length(fileName_Marker)
    temp_fileName = fileName_Marker(nFn);
    [filepath,name,ext] = fileparts(temp_fileName);
    fileName_Marker(nFn) = name;

end

% 正则表达式捕捉关键词
markerName_expression = '(?<marker>[-_]\w*(\s?)\w*$)';
parseFunc_marker = @(x)regexp(x,markerName_expression,'names');
nCount = length(fileName_Marker);
marker_capture = strings(nCount,1);
for n = 1:nCount
    temp_fn = fileName_Marker(n);
    name_parse = parseFunc_marker(temp_fn);
    str_capture = name_parse.marker;
    char_count = strlength(str_capture);
    newStr = extractAfter(str_capture,1);
    marker_capture(n,1) = newStr;
    
end
replace_expression = '(lamin)\s?\w*';
parseFunc_replace = @(x)regexprep(x,replace_expression,'laminb1','ignorecase');

new_capture = parseFunc_replace(marker_capture);


for n = 1:nCount
    temp_fn = marker_capture(n);
    name_parse = parseFunc_replace(temp_fn);
end


% parseFunc_replace_again = @(x)regexprep(x,'b1','laminb1','ignorecase');
% marker_capture = parseFunc_replace_again(new_capture);
parseFunc_replace_again = @(x)regexprep(x,'','laminb1','ignorecase');
marker_capture = parseFunc_replace_again(new_capture);
new_capture = replace(new_capture,'COX2','cox2');
new_capture = replace(new_capture,'P53','p53');
new_capture = replace(new_capture,'P21','p21');
new_capture = replace(new_capture,{'H2AX','H2ax'},'h2ax');





str_idx = strcmp(new_capture,'b1');
new_capture(str_idx) = "laminb1";
[C,ia,ic] = unique(new_capture);
clMarker_idx = cell(length(C),1);
for i = 1: length(C)
    clMarker_idx{i,1} = find(new_capture == C(i));
end
 
% marker to idx map
M = containers.Map(C,clMarker_idx);
%  到这里为止，就可以算是一个函数了，返回一个map

for nMarker = 1:length(C)
    temp_marker = C(nMarker);
    marker2Idx = M(temp_marker);
    % 在这里开始遍历文件夹，都是以red channel 作为reference 的idx
    for ndir = 1:length(clDirs)
        temp_dir = clDirs(ndir);
        clTiffs = clTiffFns{ndir};
        clTiffs = string(clTiffs);
        vt_marker_list = clTiffs(marker2Idx);
        mkdir(temp_dir,temp_marker);
        target_dir = fullfile(temp_dir,temp_marker);
    
        % 移动一个文件夹里的所有文件
        for ii = 1:length(vt_marker_list)
        temp_file = vt_marker_list(ii);
        movefile(temp_file,target_dir);
        end
    end
    
    
end


