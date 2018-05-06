
[filename path]=uigetfile('.csv');
numfiles=input('number of csv files? ');
sz=size(filename,2); %assumes format filename_01.csv, 1 any number

% Rigol CSVs have two data columns, ch1 ch2
% 
% set up for 2pp DC rigol measurements 

amp=10^-9; %set amplification for V4 in Amps/Volt, Keithley 617 is non-inverting

valarr=zeros(numfiles, 5, 'double');
filex=filename;
measnum=filex(sz-5:sz-4);
row=zeros(1,3);


for i=1:numfiles    
    %data portion
    dat=importdata(strcat(path,filex),',',3);
    row=mean(dat.data);
    V1=row(1); % v3 is inverted so adding is v2-v3
    I4=amp.*row(2); 
    %[cfun, gof]=fit(I4,V23,'poly1');
    measnum=filex(sz-5:sz-4);
    valarr(i, :)=[str2double(measnum) V1 I4 V1/I4 V1/(I4*1E6)];
    
    % multiple file portion    
    if measnum(2)=='9';
        newnum=strcat(num2str(str2num(measnum(1))+1),'0');
    else
        newnum=strcat(measnum(1),num2str(str2num(measnum(2))+1));        
    end       
    filex=strcat(filex(1:sz-6),newnum,'.csv');
    
    
end

xcelfile=strcat(path,filex(1:sz-4),'.xlsx');
headers={'MeasNum','V1', 'I2', 'R (Ohm)','R (MegaOhm)'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');
disp('complete');