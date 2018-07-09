% 2018-07-08: Two-point probe IV sweep data processing and resistance calculation for current and voltage data from Probe Station. For processing LabVIEW DAT file IV sweep data. WARNING: CHECK COLUMN REFERENCES IN DAT FILE!

% Data2PP_LabviewDATs_2018_07_08.m
% Last Revision: 2018-07-08
% Revised By: Jon Marrs

% Revision History Notes:
%2018-07-08: Reformatted figure. Renamed variables. Added comments.
%2018-05-05: Added filtering/averaging of current data.

% Description:
%The purpose of this MATLAB script is to calculate the resistance 
%from the IV sweep Current and Voltage data in the DAT files 
%generated by the LabVIEW IV sweep tool for the Probe Station 
%(e.g., IV_Sweep_tool_Probe_Station_Resistance_2PP_16_0330.vi)

% WARNING: CHECK COLUMN REFERENCES IN DAT FILE!
% Using the wrong BNC ports will lead to incorrect data processing.
% This program assumes AI 0 (Channel 1) (DAT File Column 2) is the current.
% This program assumes AI 1 (Channel 2) (DAT File Column 3)is the voltage.

clear all
[filename path]=uigetfile('.dat');
tic %Start stopwatch timer
allFiles = dir(path);
namelist=cell(length(allFiles),1);

sz=size(filename,2); %assumes format filename_01.dat, 1 any number

%% Initialize Values

% Transimpedance Amplifier 1/Gain
amp = (1/-1e3); %this amplification coefficient is 1/gain, this assumes the Amps output of the device is into a transimpedance amplifier outputting volts into Ch1
%amp is typically between (1/-1e2) and (1/-1e10), for a gain between -1e2 and -1e10, must match gain configuration in transimpedance amplifier
%amp should always be negative, since the transimpedance amplifier is an inverting amplifier

valarr=zeros(1, 5, 'double');
count=1;

% Create Figures
unfiltered = figure('Name','Unfiltered');
moving_average = figure('Name','Moving Average Filtered');
envelope_mean = figure('Name','Envelope Mean Filtered');
savitzky_golay = figure('Name','Savitzky-Golay Filtered');

%% Data Processing
for k = 1 : length(allFiles)
    
    if(strfind(allFiles(k).name, '.dat'))
        filex=allFiles(k).name;
        sz=size(filex,2);
   
        %data portion
        datums=importdata(strcat(path,filex),',',3);
        dat=datums.data(5:1995,:); %890:1100
        %newdat=dat.data(890:1100,:); %requires that OScope is in Normal Trigger
        Voltage=dat(1:size(dat,1),3); % This column number depends on BNC Configuration!!!!
        %V2=dat(1:size(dat,1),1); % v1
        %V3=dat(1:size(dat,1),1); % v1
        Current=amp.*dat(1:size(dat,1),2); %This column number depends on BNC Configuraiton!!!!!
        
        % Resistance Calculation
        [cfun, gof]=fit(Voltage,Current,'poly1');
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
        scatter(Voltage,Current, 6, 'b');
        hold on
        
        %% Data Filtering/Averaging Section

        % Moving-Average Filter
        %(See "Moving-Average Filter" example in help menu for "filter" function)
        windowSize = 100; % 100 seems to be enough datapoints to filter out the power supply noise and create a smooth IV curve
        b_coeff = (1/windowSize)*ones(1,windowSize);
        a_coeff = 1;
        Current_AVG = filter(b_coeff,a_coeff,Current);
        figure(moving_average);
        scatter(Voltage(100:end),Current_AVG(100:end), 6, 'b'); %Don't plot the first 100 data points, since they aren't properly filtered
        hold on
        
        % Envelope-Mean Filter
        [Current_envHigh, Current_envLow] = envelope(Current,66,'peak');
        Current_envMean = (Current_envHigh+Current_envLow)/2;
        figure(envelope_mean);
        scatter(Voltage, Current_envMean, 6, 'b');
        hold on;
        
        % Savitzky-Golay Smoothing Filter
        fs = 2000;  % Number of Samples
        Current_SGolayFiltered = sgolayfilt(Current,1,33);
        figure(savitzky_golay);
        scatter(Voltage(33:end-33), Current_SGolayFiltered(33:end-33), 6, 'b');
        hold on;
        
        
        namelist{count}=filex; 
        count=count+1;
        
    end
    
    
end


% To Do: Calculate average of all individually calculated resistances, and display in legend on plots.


%% Plotting Section

%Amplification string to indicate transimpedance amplifier gain configuration.
%To be included in plot titles.
amp_str = sprintf('Transimpedance Amplifier Gain: %0.0e V/A', 1/amp);

%Plot Figures

% Unfiltered
figure(unfiltered);
title({amp_str,''}); xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Unfiltered','.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Unfiltered','.png'), 'png');

% Moving Average Filtered
figure(moving_average);
title({amp_str,''}); xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Moving_Average','.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Moving_Average','.png'), 'png');

% Envelope Mean Filtered
figure(envelope_mean);
title({amp_str,''}); xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Envelope_Mean','.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Envelope_Mean','.png'), 'png');

% Savitzky-Golay Filtered
figure(savitzky_golay);
title({amp_str,''}); xlabel('Voltage (V)'); ylabel('Current (A)');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Savitzky-Golay','.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_Savitzky-Golay','.png'), 'png');


%% Save Excel File
xcelfile=strcat(path,filex(1:sz-4),'_',datestr(now,'yyyy-mm-dd'),'.xlsx');
headers={'FileName', 'MeasNum','R (Ohm)','R(MegaOhm)','R^2','RMSE'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');

disp('complete');
toc %Stop stopwatch timer
