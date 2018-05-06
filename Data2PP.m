
[filename path]=uigetfile('.csv');
numfiles=input('number of csv files? ');
sz=size(filename,2); %assumes format filename_01.csv, 1 any number

% Assumes input CSV has 5 columns, time, v1,v2,v3,v4. V4 is current.
% set up for 4pp measurements 

amp=1E-7; %set amplification for V4 in Amps/Volt, Inverting

valarr=zeros(numfiles, 5, 'double');
filex=filename;
measnum=filex(sz-5:sz-4);


for i=1:numfiles    
    %data portion
    dat=importdata(strcat(path,filex),',',3);
    V1=dat.data(3:size(dat.data,1),2); % v1
    I4=amp.*dat.data(3:size(dat.data,1),3); 
    [cfun, gof]=fit(I4,V1,'poly1');
    measnum=filex(sz-5:sz-4);
    valarr(i, :)=[str2double(measnum) cfun.p1 (cfun.p1)/1E6 gof.rsquare gof.rmse];
    
    % multiple file portion    
    if measnum(2)=='9';
        newnum=strcat(num2str(str2num(measnum(1))+1),'0');
    else
        newnum=strcat(measnum(1),num2str(str2num(measnum(2))+1));        
    end       
    filex=strcat(filex(1:sz-6),newnum,'.csv');
    
    
end

xcelfile=strcat(path,filex(1:sz-4),'.xlsx');
headers={'MeasNum','R (Ohm)','R (MegaOhm)','R^2','RMSE'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');

disp('complete');