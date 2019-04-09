% 2018-07-05: Thermoelectric voltage data processing and Seebeck coefficient calculation for DC heater voltage. For processing LabVIEW LVM file thermoelectric data obtained with Thermoelectric Chip (TEC).

% LVM_Average2_AutoRunDataSet_experimentalDC_2018_07_05.m
% Last Revision: 2018-07-05
% Revised By: Jon Marrs

% Revision History Notes:
%2018-07-05: Reformatted figure
%2017-08-04: DC RTD Calibration (SCHPN = 3.59763)
%2016-08-31: Spatially correct DT power scaling with airflow 1.803 is 6.03
%2016-07-14: Preceding zero subtraction version, rolling average zero norm

% Description:
%The purpose of this MATLAB script is to calculate the Seebeck coefficient 
%from the Thermoelectric Voltage and Heater Current in the LVM files 
%generated by the LabVIEW thermoelectric program for DC heater voltages 
%(e.g., ThermoV_ControlSweep_NoMean_ExperimentalCode_DC_LV2017.vi)

clear all
tic %Start stopwatch timer
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%% Initialize Values

% Thermoelectric Voltage Differential Amplifier 1/Gain (Channel 1)
Ch1amp = (1/1020); %this amplification coefficient is 1/gain
%Ch1amp is typically (1/1020), for a gain of ~1000, must match gain configuration in differential amplifier
%make Ch1amp positive if heater is above the electrodes (HA)
%make Ch1amp negative if heater is below the electrodes (HB)

% Heater Current Transimpedance Amplifier 1/Gain (Channel 2)
Ch2amp = (1/-1E2); %this amplification coefficient is 1/gain, this assumes the Amps output of heater is into a transimpedance amplifier outputting volts into Ch2
%Ch2amp is typically either (1/-1E2) or (1/-1E3), for a gain of -1E2 or -1E3, must match gain configuration in transimpedance amplifier
%Ch2amp should always be negative, since the transimpedance amplifier is an inverting amplifier

% DC RTD Calibration [Kelvin/Watt] (last calibrated 2017-08-04)
SCHPN = 3.59763; % (previous calibration: SCHPN = 1.997729)

valarr=zeros(1, 9, 'double');
count=1;
setzero=0;
Vnorm=0;
HVpp=0;
setcount=0;
zerocount=7;
Vnormroll=0;
HVzeros=NaN(0,1);
%Rheater=2100; %ohms, resistance of heater for this junction. obsoleted.

%% Data Processing
%work on one file at a time
for k = 1 : length(allFiles)    
    if(strfind(allFiles(k).name, '.lvm')) %import LVM data file
        filex=allFiles(k).name;   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        %Read the Time, Thermoelectric Voltage, and Heater Current from the LabVIEW LVM data file
        %Skip the first ~150 datapoints to account for delay of applied heater voltage transition
        Time=dat(150:term,1); % Time
        ThermoV=dat(150:term,2)*Ch1amp; % Thermoelectric Voltage (vdiff)
        HCurrent=dat(150:term,3)*Ch2amp; % Heater Current (can be saturated if 1e-3 amplif is used)
        Vmean=mean(ThermoV);
        Vstd=std(ThermoV);
        Hcurrentmean=mean(HCurrent);
        Hcurrentstd=std(HCurrent);
        
        HVzeros=[HVzeros; 0];
        MODis=str2double(filex(1,size(filex,2)-9:size(filex,2)-8));
        if mod(MODis,2)==0 %if filename MODis Even, it is zero HVpp run
            setzero=Vmean;
            zerocount=zerocount+1;
            HVzeros(k,1)=1;
            if zerocount==8
                zerolist(1:7)=setzero;
            end
            zerolist=[zerolist setzero];
            rollingavg=mean(zerolist(zerocount-7:zerocount));            
            HVpp=0;
        elseif MODis==1 HVpp=9; elseif MODis==3 HVpp=11; elseif MODis==5 HVpp=13; elseif MODis==7 HVpp=15; elseif MODis==9 HVpp=17; elseif MODis==11 HVpp=19; end
        Vnorm=Vmean-setzero;        
        Vnormroll=Vmean-rollingavg; %code might require first filename be even to initialize rollingavg
        %power=37.89*HVpp^2/(8*Rheater); %this is for AC
        power=SCHPN*(HVpp/2)*Hcurrentmean; %this is for DC
        Rheatmeasured=(HVpp/2)/Hcurrentmean;
        valarr(count,:)=[HVpp power Vmean Vstd Vnorm Vstd Vnormroll Vstd Rheatmeasured];
        namelist{count}=filex;        
        count=count+1;
    end
    
end

%% Plotting Section
%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];

% Figure Window Title
figure('NumberTitle', 'off', 'Name', strcat(filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC'), 'pos', [350 50 950 700])

% Thermoelectric Voltage vs. Time
subplot(2,2,1)
xax=[1:count-1];
plot(xax, valarr(:,3));
set(gca,'FontSize',11.5); %axis font size
title({'','Thermoelectric Voltage vs. Time'}, ...
    'horizontalAlignment','right','units','normalized','position',[1 1]); %right-justify subplot title
xlabel('Time [~Minutes]'); ylabel('\DeltaV [V]');

% No Zero Normalization
subplot(2,2,2)
errorbar(valarr(:,2), valarr(:,3), valarr(:,4), 'bs');
set(gca,'FontSize',11.5); %axis font size
title({'','No Zero Normalization'}, ...
    'horizontalAlignment','right','units','normalized','position',[1 1]); %right-justify subplot title
xlabel('\DeltaT [K]'); ylabel('\DeltaV [V]');
cf2=fit(valarr(:,2), valarr(:,3), 'poly1'); %Seebeck coefficient calculation
seeb2=num2str(-cf2.p1,'%10.2e'); %Seebeck coefficient string
legend({['S = ',seeb2]},'FontSize',12);

% Preceding Zero Subtraction
subplot(2,2,3)
errorbar(valarr(:,2), valarr(:,5), valarr(:,4), 'bs');
set(gca,'FontSize',11.5); %axis font size
title('Preceding Zero Subtraction', ...
    'horizontalAlignment','right','units','normalized','position',[1 1]); %right-justify subplot title
xlabel({'\DeltaT [K]',''}); ylabel('\DeltaV [V]');
cf3=fit(valarr(:,2), valarr(:,5), 'poly1'); %Seebeck coefficient calculation
seeb3=num2str(-cf3.p1,'%10.2e'); %Seebeck coefficient string
legend({['S = ',seeb3]},'FontSize',12);

% Rolling Average Zero Subtraction
subplot(2,2,4)
errorbar(valarr(:,2), valarr(:,7), valarr(:,4), 'bs');
set(gca,'FontSize',11.5); %axis font size
title('Rolling Average Zero Subtraction', ...
    'horizontalAlignment','right','units','normalized','position',[1 1]); %right-justify subplot title
xlabel({'\DeltaT [K]',''}); ylabel('\DeltaV [V]');
cf4=fit(valarr(:,2), valarr(:,7), 'poly1'); %Seebeck coefficient calculation
seeb4=num2str(-cf4.p1,'%10.2e'); %Seebeck coefficient string
legend({['S = ',seeb4]},'FontSize',12);

% Figure Heading
annotation('textbox', [0 0.90 1 0.1], ...
    'String', {'Thermoelectric Voltage and Seebeck Coefficient',''}, ...
    'FontWeight', 'bold', 'FontSize', 14, ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center');

% Figure Footing
annotation('textbox', [0 0 1 0.04], ...
    'String', {['With Airflow, ', ...
    'DC Heater Voltage, ', ...
    'Thermoelectric Voltage Diff. Amp. Gain = ', num2str(round((1/Ch1amp),1,'significant'),'%10.1e'), ' V/V, ', ...
    'Heater Current TIA Gain = ', num2str(round((1/Ch2amp),1,'significant'),'%10.1e'), ' V/A']}, ...
    'FontWeight', 'normal', 'FontSize', 12, ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center');

%save figure as MATLAB figure and PNG image
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC.png'), 'png');

%% Save Excel File
xcelfile=strcat(path,filex(1:sz-4),'_',datestr(now,'yyyy-mm-dd'),'_DC.xlsx');
headers={'MeasNum', 'HVpp', 'DT', 'ThermoVMean', 'StDev', 'PrecedZeroSub', 'StDev', '7pt RollingAvg', 'StDev', 'Rheatmeasured'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');

%% Seebeck Coefficients Compilation
%If file exists, append to the list of Seebeck coefficients
compilepath = strcat(path, '..\', 'Seebeck coefficients compilation.xlsx');

XLSX_append(compilepath,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC.png'), [-cf2.p1 -cf3.p1 -cf4.p1]);

toc %Stop stopwatch timer
disp('complete');


