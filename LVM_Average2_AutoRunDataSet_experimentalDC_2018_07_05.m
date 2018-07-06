%16.08.31 Spatially correct DT power scaling with airflow 1.803 is 6.03
%preceding zero subtraction version 2016.07.14
%rolling average zero norm
clear all
tic %Start stopwatch timer
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%% Initialize Values

% Thermoelectric Voltage Amplifier Gain (Channel 1)
Ch1amp = (1/1020); %this amplification is 1/gain
%Ch1 amplifier gain is typically (1/1020), must match feedback resistor gain configuration in differential amplifier
%make amp positive if heater is above the electrodes (HA)
%make amp negative if heater is below the electrodes (HB)

% Heater Current Amplifier Gain (Channel 2)
Ch2amp = -1E-3; %this assumes the Amps output of heater is into an amplifier outputting volts into Ch2
%Ch2 amplifier gain is typically either -1E-2 or -1E-3, must match feedback resistor gain configuration in transimpedance amplifier

SCHPN=3.59763; %DC RTD Calib 17.08.04  previously: SCHPN= 1.997729

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
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        %Read the Time, Thermoelectric Voltage, and Heater Current from the LabVIEW data file
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

xax=[1:count-1];
figure
subplot(2,2,1)
plot(xax, valarr(:,3));
title({strcat('w Airflow, Ch2Amp=', num2str(Ch2amp), 'A/V'),''});
xlabel('Time [minutes?]'); ylabel('\DeltaV [V]');

subplot(2,2,2)
errorbar(valarr(:,2), valarr(:,3), valarr(:,4), 'bs');
title({'No Zero Normalization',''});
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf2=fit(valarr(:,2), valarr(:,3), 'poly1');
seeb2=num2str(-cf2.p1);
legend(strcat('S=',seeb2));

subplot(2,2,3)
errorbar(valarr(:,2), valarr(:,5), valarr(:,4), 'bs');
title({'Preceding Zero Subtraction',''});
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf3=fit(valarr(:,2), valarr(:,5), 'poly1');
seeb3=num2str(-cf3.p1);
legend(strcat('S=',seeb3));

subplot(2,2,4)
errorbar(valarr(:,2), valarr(:,7), valarr(:,4), 'bs');
title({'Rolling Average Zero Subtraction',''});
xlabel('\DeltaT [K]'); ylabel('\DeltaV [V]');
cf4=fit(valarr(:,2), valarr(:,7), 'poly1');
seeb4=num2str(-cf4.p1);
legend(strcat('S=',seeb4));
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC_newSCHPN2.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC_newSCHPN2.png'), 'png');
%%
xcelfile=strcat(path,filex(1:sz-4),'_',datestr(now,'yyyy-mm-dd'),'_DC_newSCHPN2.xlsx');
headers={'MeasNum', 'HVpp', 'DT', 'ThermoVMean', 'StDev', 'PrecedZeroSub', 'StDev', '7pt RollingAvg', 'StDev', 'Rheatmeasured'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');

%%
%If file exists, append to the list of Seebeck coefficients
compilepath = strcat(path, '..\', 'Seebeck coefficients compilation.xlsx');

XLSX_append(compilepath,strcat(path, filex(1:length(filex)-4),'_',datestr(now,'yyyy-mm-dd'),'_DC_newSCHPN2.png'), [-cf2.p1 -cf3.p1 -cf4.p1]);

toc %Stop stopwatch timer
disp('complete');


