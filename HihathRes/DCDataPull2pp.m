
[filename path]=uigetfile('.csv');
numfiles=input('number of csv files? ');
sz=size(filename,2); %assumes format filename_01.csv, 1 any number

% Assumes input CSV has 5 columns, time, v1,v2,v3,v4. V4 is current.
% set up for 4pp measurements 

amp=-10^-10; %set amplification for V4 in Amps/Volt, Inverting

valarr=zeros(numfiles, 5, 'double');
filex=filename;
measnum=filex(sz-5:sz-4);
row=zeros(1,5);


for i=1:numfiles    
    %data portion
    dat=importdata(strcat(path,filex),',',3);
    row=mean(dat.data(4:size(dat.data,1), :));
    V=row(2); 
    I4=amp.*row(3); 
    %[cfun, gof]=fit(I4,V23,'poly1');
    measnum=filex(sz-5:sz-4);
    valarr(i, :)=[str2double(measnum) V I4 V/I4 V/(I4*1E6)];
    
    % multiple file portion    
    if measnum(2)=='9';
        newnum=strcat(num2str(str2num(measnum(1))+1),'0');
    else
        newnum=strcat(measnum(1),num2str(str2num(measnum(2))+1));        
    end       
    filex=strcat(filex(1:sz-6),newnum,'.csv');
    
    
end

xcelfile=strcat(path,filex(1:sz-4),'.xlsx');
headers={'MeasNum','V', 'I4', 'R (Ohm)','R (MegaOhm)'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');
