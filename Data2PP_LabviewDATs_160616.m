% CHECK COLUMN REFERENCES IN DAT FILE
clear all
[filename path]=uigetfile('.dat');
tic
allFiles = dir(path);
namelist=cell(length(allFiles),1);

sz=size(filename,2); %assumes format filename_01.dat, 1 any number

amp=-1e-10;
%{
; %set amplification for V2 per sample from excel
%}
valarr=zeros(1, 5, 'double');
count=1;

unfiltered = figure('Name','Unfiltered');

%{
%----------------------------------
% Added by Jon on 5/5/2018
moving_average = figure('Name','Moving Average Filtered');
envelope_mean = figure('Name','Envelope Mean Filtered');
savitzky_golay = figure('Name','Savitzky-Golay Filtered');
%----------------------------------
%}


for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.dat'))
        filex=allFiles(k).name;
        sz=size(filex,2);
   
        %data portion
        datums=importdata(strcat(path,filex),',',3);
        dat=datums.data(5:1995,:); %890:1100
        %newdat=dat.data(890:1100,:); %requires that OScope is in Normal Trigger
        V1=dat(1:size(dat,1),3); % This column number depends on BNC Configuration!!!!
        %V2=dat(1:size(dat,1),1); % v1
        %V3=dat(1:size(dat,1),1); % v1
        I4=amp.*dat(1:size(dat,1),2); %This column number depends on BNC Configuraiton!!!!!
        [cfun, gof]=fit(V1,I4,'poly1');
        measnum=filex(sz-5:sz-4);
        valarr(count, :)=[str2double(measnum) 1/cfun.p1 1/(1e6*cfun.p1) gof.rsquare gof.rmse];
        
        
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
        figure(unfiltered);
        scatter(V1,I4, 6, 'b');
        hold on
        
        %{
        %----------------------------------
        % Added by Jon on 5/5/2018
        %Moving-Average Filter
        %(See "Moving-Average Filter" example in help menu for "filter" function)
        windowSize = 100; % 100 seems to be enough datapoints to filter out the power supply noise and create a smooth IV curve
        b_coeff = (1/windowSize)*ones(1,windowSize);
        a_coeff = 1;
        I4_AVG = filter(b_coeff,a_coeff,I4);
        figure(moving_average);
        scatter(V1(100:end),I4_AVG(100:end), 6, 'b'); %Don't plot the first 100 data points, since they aren't properly filtered
        hold on
        
        % Envelope-Mean Filter
        [I4_envHigh, I4_envLow] = envelope(I4,66,'peak');
        I4_envMean = (I4_envHigh+I4_envLow)/2;
        figure(envelope_mean);
        scatter(V1, I4_envMean, 6, 'b');
        hold on;
        
        %Savitzky-Golay Smoothing Filter
        fs = 2000;  % Number of Samples
        I4_SGolayFiltered = sgolayfilt(I4,1,33);
        figure(savitzky_golay);
        scatter(V1(33:end-33), I4_SGolayFiltered(33:end-33), 6, 'b');
        hold on;
        %----------------------------------
        %}
        
        namelist{count}=filex; 
        count=count+1;
        
    end
    
    
end


figure(unfiltered);
xlabel('Voltage (V)'); ylabel('Current (A)');

saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'.png'), 'png');

%{
%----------------------------------
% Added by Jon on 5/5/2018
figure(moving_average);
xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Moving_Average_Filtered','.png'), 'png');

figure(envelope_mean);
xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Envelope_Mean_Filtered','.png'), 'png');

figure(savitzky_golay);
xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Savitzky-Golay_Filtered','.png'), 'png');
%----------------------------------
%}

xcelfile=strcat(path,filex(1:sz-4),'_1E-x_160616.xlsx');
headers={'FileName', 'MeasNum','R (Ohm)','R(MegaOhm)','R^2','RMSE'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
disp('complete');
toc