% 该脚本的目的是为了将多个excel表格的文件名进行汇总，并按照类型进行进行排序

% give a path which include all the csv file
str_path = "D:\Project\Segmentation\Counts_colocalize_files\sum_all_count_into_one";
strFn_RegExp = "\.xlsx$";

clFiles = FindFiles_RegExp(strFn_RegExp,str_path);

nFiles = length(clFiles);
tbFileName_all = table;

for nF = 1:nFiles
  temp_table = readtable(clFiles{nF},"VariableNamingRule","preserve");
  tbFileName_all = [tbFileName_all;temp_table];
end

% remove the extention of file name
fileName_Marker = string(tbFileName_all.fileName_Marker);
for nFn = 1:length(fileName_Marker)
    temp_fileName = fileName_Marker(nFn);
    [filepath,name,ext] = fileparts(temp_fileName);
    fileName_Marker(nFn) = name;

end

% 正则表达式捕捉关键词
markerName_expression = '(?<marker>[-_]\w*(\s?)\w*_merge)';
parseFunc_marker = @(x)regexp(x,markerName_expression,'names');
nCount = length(fileName_Marker);
marker_capture = strings(nCount,1);
for n = 1:nCount
    temp_fn = fileName_Marker(n);
    name_parse = parseFunc_marker(temp_fn);
    str_capture = name_parse.marker;
    char_count = strlength(str_capture);
    newStr = extractBetween(str_capture,2,char_count-6);
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

% create a new table
reOrder_table = table;

for ii = 1:length(C)
    temp_marker = C(ii);
    marker2Idx = M(temp_marker);
    temp_table = tbFileName_all(marker2Idx,[1:6]);
    vtMarker_name = strings(height(temp_table),1);
    vtMarker_name(:,1) = C(ii);
    temp_table.MarkerName = vtMarker_name;
    reOrder_table = [reOrder_table;temp_table];
end
fn_save = fullfile(str_path,'Sum_all_count_into_one_v2.xlsx');
writetable(reOrder_table,fn_save,"AutoFitwidth",true);




    

  