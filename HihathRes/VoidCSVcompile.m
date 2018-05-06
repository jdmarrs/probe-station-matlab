[filename path] = uigetfile('.csv');

allFiles = dir(path);
namelist=cell(length(allFiles),1);
voidlist=zeros(1,1);
numcsv=1;

for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.csv'))
        filex=allFiles(k).name;
        
        dat=importdata(strcat(path,filex),',',1);

        voidlist(numcsv,1)=dat.data(4);
        
        namelist(numcsv)={filex};
        
        numcsv=numcsv+1;
    end
    
end

sz=size(filename,2);
xcelfile=strcat(path,filename(1:sz-4),' VoidsTotal.xlsx');
headers={'Img Name', '%AreaVoids'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
pause(0.25);
xlswrite(xcelfile, voidlist, 1, 'B2');

disp('complete');