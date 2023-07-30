% 该程序首先遍历一个文件夹里面有多少个子文件夹
% 得到子文件的路径后，对每个文件的文件进行log file的生成，logfile的命名以文件名为名
% 未来还需要添加一个功能，那就是根据需求将所有文件夹的logfile写入到一个文件夹中

str_path = "D:\Project\Segmentation\Counts_colocalize_files\batch_image\all_in_one\20x_image";
str_REexpression = '\.tif$';
% 这里有一个技巧，就是如何遍历出主文件夹里面的所有子文件夹
% 比如你使用dir(parent_path)只会得到第一层的子文件夹
% 但是你使用通配符'**',就可以遍历出主文件夹里面的所有文件和子文件夹，然后再使用isdir去除文件
% all_subfolders = dir(fullfile(str_path,'**'));
d = dir(fullfile(str_path,'**'));
clFullPathFolders = {};
numMatches = 0;
% get all the folders in parent folder,exclude the files
for i = 1:length(d)
    a_name = d(i).name;
    a_dir = d(i).isdir;
    a_folder = d(i).folder;
    if (strcmp(a_name,'.') || strcmp(a_name,'..')|| ~a_dir)
        continue;
    end
    numMatches = numMatches +1;
    clFullPathFolders{numMatches} = fullfile(a_folder,a_name);
end


% do the write log function for every folder

numFolders = length(clFullPathFolders);
for nFolder = 1:numFolders
    temp_folder = clFullPathFolders{nFolder};
    folder_name = strsplit(temp_folder,'\');
    LogFile_name = folder_name{end};
    % 这里的正则表达式要特别注意，例如’.tif'是不行的
    % 因为 . 代表通配符，与任意一个字符匹配，因此如果文件名中含有'tif'这几个字的非TIF格式的文件也会被包含
    % 因此，要使用转义字符'\.'，然后再加上字符串末尾定位符'$'
    WriteLog(temp_folder,LogFile_name,str_REexpression);
    % function should be here to loop the folder
end
