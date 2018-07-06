%testing append one row to end of existing excel file
function XLSX_append(fullpath,stringinput,testdata) 

datums=importdata(fullpath);

stringcell=cell(1);
stringcell{1}=stringinput; 

numrows=size(datums.textdata.Sheet1,1);
namecell=strcat('A',num2str(numrows+1));
datcell=strcat('B',num2str(numrows+1));

xlswrite(fullpath,stringcell(1),1, namecell); %write stringinput
pause(0.25);
xlswrite(fullpath,testdata,1, datcell); %write row of numerical data
end
