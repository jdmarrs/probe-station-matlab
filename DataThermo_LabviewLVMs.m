
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);

sz=size(filename,2); %assumes format filename_01.dat, 1 any number

amp=1;
%{
; %set amplification for V2 per sample from excel
%}
valarr=zeros(20, 5);
count=1;

for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;
   
        %data portion
        importLVM(strcat(path,filex));
        dat=data;
        %newdat=dat.data(890:1100,:); %requires that OScope is in Normal Trigger
        R3w=dat(1:size(dat,1),3); % v1
        R1w=dat(1:size(dat,1),4); 
        %[cfun, gof]=fit(I4,V1,'poly1');
        measnum=filex(sz-5:sz-4);
        %valarr(count, :)=[str2double(measnum) cfun.p1 cfun.p1/1E6
        %gof.rsquare gof.rmse];
        %{
        % multiple file portion    
        if measnum(2)=='9';
            newnum=strcat(num2str(str2num(measnum(1))+1),'0');
        else
            newnum=strcat(measnum(1),num2str(str2num(measnum(2))+1));        
        end       
        filex=strcat(filex(1:sz-6),newnum,'.csv');
        %}

        %namelist(str2double(measnum))={filex};

        %colors=['y','m','c','r','g','b','k','y','m','c','r','g','b','k'];
       %scatter(V1,I4, 6, 'r');
        %hold on
        avgr3w=mean(R3w);
        avgr1w=mean(R1w);
        std3w=std(R3w);
        std1w=std(R1w);
        
        valarr(count,:)=[count avgr1w std1w avgr3w std3w];

        count=count+1;
    end
    
    
end

xcelfile=strcat(path,filex(1:sz-4),'_Rvals.xlsx');
headers={'MeasNum','R1omega)','StdDevR1', 'R3omega', 'StdDevR3'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');

disp('complete');
