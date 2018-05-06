
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);

sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

amp=[1/1]; %this amplification is 1/gain

valarr=zeros(1, 2, 'double');
count=1;

for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;
   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        Time=dat(3:term,1);
        Ch4=dat(3:term,2)*amp; % vdiff

        Vmean=mean(Ch4);
        Vstd=std(Ch4);
        
        valarr(count,:)=[Vmean Vstd];
        namelist{count}=filex;
       
 
        count=count+1;
    end
    
end

%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];
xax=[1:count-1];
plot(xax, valarr(:,1));
hold on

xcelfile=strcat(path,filex(1:sz-4),'_Means.xlsx');
headers={'MeasNum','Ch4Mean','StDev'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');


disp('complete');
