  %setup for RIGOL
clear all
[filename path]=uigetfile('.csv');
%numfiles=input('number of csv files? ');
sz=size(filename,2); %assumes format filename_01.csv, 1 any number

path2=num2str(path);
allFiles = dir(path2);
namelist=cell(length(allFiles),1);

% Assumes input CSV has 2 columns, v1,v4. V4 is current.
% set up for 2pp measurements 

amp=1E-7; %set amplification for V4 in Amps/Volt, Inverting

valarr=zeros(1, 4, 'double');
filex=filename;
measnum=filex(sz-5:sz-4);

count=1;
%Linear portion assumes 2000 data points, with sweep start at 0V. 
%column orders V_app, I4(Volts), V1, V2, V3.
for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.csv'))
        filex=allFiles(k).name;

 
        %data portion
        datums=importdata(strcat(path,filex),',',3);
        dat=datums.data;
        %newdat=dat.data(890:1100,:); %requires that OScope is in Normal Trigger
        V1=dat(100:1000,1); % v1
        %V2=dat(100:1000,2); % v2
        %V3=dat(100:1000,3); % v3
        I4=amp.*dat(100:1000,2); 
        %V23=V2-V3;
        [cfun, gof]=fit(I4,V1,'poly1');
        measnum=filex;
        valarr(k, :)=[cfun.p1 (cfun.p1)/1E6 gof.rsquare gof.rmse];
        namelist{k}=measnum;
        % multiple file portion    
        %if measnum(2)=='9';
        %    newnum=strcat(num2str(str2num(measnum(1))+1),'0');
        %else
        %    newnum=strcat(measnum(1),num2str(str2num(measnum(2))+1));        
        %end       
        
        %filex=strcat(filex(1:sz-6),newnum,'.csv');
        
        count=count+1;
    end
end
    
    

xcelfile=strcat(path,filex(1:sz-4),'output.xlsx');
headers={'MeasNum','R (Ohm)','R (MegaOhm)', 'R^2','RMSE'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile, namelist,1,'A2');
xlswrite(xcelfile,valarr,1, 'B2');
disp('complete');