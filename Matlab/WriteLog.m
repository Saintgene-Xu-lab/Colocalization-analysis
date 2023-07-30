function WriteLog(strDir, svName,strExp)
% 该函数应该接受三个参数，一个是输入路径，一个正则表达式，另一个是保存的文件名称
if(nargin ==0)
    strDir = 'D:\Project\Zebra_Fish\Registration\zebrafish0105-36hpf-TP1-GFP-cc\Rnd2_reg';
end

bVidImg = false;
if(nargin == 3)
    
strExp_Img = strExp;
else
   if(bVidImg)
    strExp_Img = '_Reg.nii';
   else
    %strExp_Img ='CYCLE\S*';%_Rd5_\S*_Stitched.czi';%'\w*.(lsm|czi)';
    strExp_Img ='.tif';
   end
   
end


clFiles_dN = FindFiles_RegExp(strExp_Img, strDir, false,3)';
%clFiles_dN = SortFnByCounter(clFiles_dN,strExp_Img);

nFileCount = length(clFiles_dN);
filename = strcat(svName, '.log');
save_name = fullfile(strDir,filename);
%fid = fopen([strDir '\Nii2tif.log'],'wt');
fid = fopen(save_name, 'wt');

for nFile = 1:nFileCount
    strFile_dN = clFiles_dN{nFile};
    strFile_Reg = strFile_dN;%[strFile_dN(1:end-length(strExp_dN)) '_reg.tif'];
    if(bVidImg)
        clFile_Vid = FindFiles_RegExp('_ext.avi', fileparts(strFile_Reg), false,1)';
        if(~isempty(clFile_Vid))
            strFile_Vid = clFile_Vid{1};
            fprintf(fid,'%s\n', strFile_Reg);
            fprintf(fid,'%s\n', strFile_Vid);
        end
    else
        fprintf(fid,'%s\n', strFile_Reg);
%         fprintf(fid,'%s\n', strrep(strFile_Reg,'_Vglut2','_Gad2'));
%        fprintf(fid,'%s\n',[strFile_Reg(1:end-8) '_DAPIPartial_GCaMP_Stitched_G.tif']);
%        fprintf(fid,'%s\n',[strFile_Reg(1:end-8) '_DAPIFull_GCaMP_Stitched_G_Reg.tif']);
        %fprintf(fid,'%s\n', strrep(strFile_Reg,'.tif','_Prob.tif'));
%         [strPath,strFn] = fileparts(strFile_Reg);
%         strFn = ['S6_2_' strFn(6:end) '.tif'];
%         fprintf(fid,'%s\n', [strPath filesep strFn]);
%         clParts=strsplit(strFn,'_');
%         switch clParts{7}
%             case 'G'
%             case 'R'
%             case 'Y'
%         end
%         fprintf(fid,'#sav#:%s\n', [strPath filesep strFn(6:end)]);
    end
end

fclose(fid);