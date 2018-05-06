% CHECK COLUMN REFERENCES IN DAT FILE
[filename path]=uigetfile('.dat');
allFiles = dir(path);
namelist=cell(length(allFiles),1);

sz=size(filename,2); %assumes format filename_01.dat, 1 any number

amp=[1.00E-4]; %set the amplification
%{
; %set amplification for V2 per sample from excel
%}
valarr=zeros(1, 6, 'double');
count=1;
%Linear portion assumes 2000 data points, with sweep start at 0V. 
%column orders V_app, I4(Volts), V1, V2, V3.
for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.dat'))
        filex=allFiles(k).name;
   
        %data portion
        datums=importdata(strcat(path,filex),',',3);
        dat=datums.data;
        %newdat=dat.data(890:1100,:); %requires that OScope is in Normal Trigger
        V1=dat(600:1400,1); % v1
        %V2=dat(1:1996,3); % v2
        %V3=dat(1:1996,4); % v3
        I4=amp.*dat(600:1400,2); 
        %Vdiff=V2-V3;
        %Rmean=mean(Vdiff./I4);
        
        %{ 
        navg=20; %even number
        Vdta=zeros(navg+1,1);
        I4ta=zeros(navg+1,1);
        for j=1:length(Vdiff)-(navg+1)
            Vdta(j)=mean(Vdiff(j:j+navg));            
            %I4ta(j)=mean(I4(j:j+navg));                        
        end
        
        I4ta=I4(11:length(I4)-11);
        %}
        
        [cfun, gof]=fit(I4, V1, 'poly1');
        
        Yintc=cfun.p2;
        Xintc=-cfun.p2/cfun.p1;
        
        measnum=filex(sz-5:sz-4);
        valarr(count, :)=[str2double(measnum) (cfun.p1) gof.rsquare gof.rmse Yintc Xintc];

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

        %colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];
        scatter(V1, I4, 6, 'r');
        hold on

        count=count+1;
    end
    
    
end

xcelfile=strcat(path,filex(1:sz-4),'_Full_R.xlsx');
headers={'MeasNum','R slope(Ohm)','R^2','RMSE', 'Yint Tcur','Xint Tvol' };
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');

disp('complete');
