[filename path] = uigetfile('.csv');

allFiles = dir(path);
namelist=cell(length(allFiles),1);
peaklist=zeros(1,2);
numcsv=1;

FFTwidth=1024/3.425; %nm for 1024x width, 1Mx image
colors=['b' 'g' 'r' 'c' 'm' 'y' 'k' 'b' 'g' 'r' 'c' 'm' 'y' 'k' 'b' 'g' 'r' 'c' 'm' 'y' 'k' 'b' 'g' 'r' 'c' 'm' 'y' 'k' 'b' 'g' 'r' 'c' 'm' 'y' 'k' 'b' 'g' 'r' 'c' 'm' 'y' 'k']';

for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.csv'))
        filex=allFiles(k).name;
        
        dat=importdata(strcat(path,filex),',',1);
        
        rnmc=zeros(length(dat.data),1);
        for i=1:length(dat.data)
           rnmc(i)=FFTwidth/dat.data(i,2); %nm/cycle            
        end
       
        
        
        semilogx(rnmc, dat.data(:,3), colors(k))
        hold on
        
    end
    
end

%{

sz=size(filename,2);
xcelfile=strcat(path,filename(1:sz-4),' Autocorrelation.xlsx');
headers={'Img Name', 'Peak from Poly2', 'Poly2 G.O.F. R^2'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
pause(0.25);
xlswrite(xcelfile, peaklist, 1, 'B2');
%}
disp('complete');