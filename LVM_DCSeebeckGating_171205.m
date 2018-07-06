%16.08.31 Spatially correct DT power scaling with airflow 1.803 is 6.03
%preceding zero subtraction version 2016.07.14
%rolling average zero norm
clear all
tic
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%initialize values
amp=[1/1020]; %this amplification is 1/gain
%make amp negative if heater is Below the electrodes

valarr=zeros(1, 11, 'double');
vgm=struct('c0',NaN(0,9),'c1', NaN(0,9), 'c2', NaN(0,9),'c3',NaN(0,9),'c4', NaN(0,9), 'c5', NaN(0,9),'c6',NaN(0,9),'c7', NaN(0,9), 'c8', NaN(0,9), 'c9', NaN(0,9),'c10', NaN(0,9), 'c11', NaN(0,9), 'c12', NaN(0,9),'c13',NaN(0,9),'c14', NaN(0,9), 'c15', NaN(0,9),'c16',NaN(0,9),'c17', NaN(0,9)); %vgmatrix

count=1;
setzero=0;
Vnorm=0;
HVpp=0;
setcount=0;
zerocount=7;
Vnormroll=0;
HVzeros=NaN(0,1);
%Rheater=2100; %ohms, resistance of heater for this junction. obsoleted.

Ch2amp=-1E-2; %this assumes the Amps output of heater is into an amplifier outputting volts into Ch2

SCHPN=3.59763; %DC RTD Calib 17.08.04 previously: SCHPN= 1.997729 units Kelvin per watt


%work on one file at a time
for k = 1 : length(allFiles)    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        Time=dat(150:term,1);
        Ch4=dat(150:term,2)*amp; % vdiff
        HCurrent=dat(150:term,3)*Ch2amp; %can be saturated if 1e-3 amplif is used
        Vmean=mean(Ch4);
        Vstd=std(Ch4);
        Hcurrentmean=mean(HCurrent);
        Hcurrentstd=std(HCurrent);
        
        
        VGis=str2double(filex(1,size(filex,2)-9:size(filex,2)-8));
        
        HVzeros=[HVzeros; 0];
        MODis=str2double(filex(1,size(filex,2)-13:size(filex,2)-12));
        if mod(MODis,2)==0 %if filename MODis Even, it is zero HVpp run
            setzero=Vmean;
            zerocount=zerocount+1;
            HVzeros(k,1)=1;
            if zerocount==8 zerolist(1:7)=setzero; end
            zerolist=[zerolist setzero];
            rollingavg=mean(zerolist(zerocount-7:zerocount));            
            HVpp=0;
        elseif MODis==1 HVpp=9; elseif MODis==3 HVpp=11; elseif MODis==5 HVpp=13; elseif MODis==7 HVpp=15; elseif MODis==9 HVpp=17; elseif MODis==11 HVpp=19; end
        
        Vnorm=Vmean-setzero;        
        Vnormroll=Vmean-rollingavg;
        %power=SCHPN*HVpp^2/(8*Rheater); %this is for AC
        power=SCHPN*(HVpp/2)*Hcurrentmean; %this is for DC %this is not power, its DT
        
        Rheatmeasured=(HVpp/2)/Hcurrentmean;
        %power=SCHPN*(HVpp/2)^2/(Rheatmeasured); %yields NaN if Rheatmeasured=0
        DT=power;
        
        Rdut=Vmean;
        Rsquare=Vstd;
        
        switch VGis
            case 0, Vg=0;
                vgm.c0=[vgm.c0(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 1, Vg=0.05; %1*Vgincr;
                vgm.c1=[vgm.c1(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 2, Vg=0.1; %2*Vgincr;
                vgm.c2=[vgm.c2(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 3, Vg=0.25; %3*Vgincr;
                vgm.c3=[vgm.c3(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 4, Vg=1; %4*Vgincr;
                vgm.c4=[vgm.c4(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 5, Vg=2; %5*Vgincr;
                vgm.c5=[vgm.c5(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 6, Vg=4;
                vgm.c6=[vgm.c6(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 7, Vg=6; %-1*Vgincr;
                vgm.c7=[vgm.c7(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 8, Vg=8; %-2*Vgincr;
                vgm.c8=[vgm.c8(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 9, Vg=0; %-3*Vgincr;
                vgm.c9=[vgm.c9(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 10, Vg=-0.05; %4*Vgincr;
                vgm.c10=[vgm.c10(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 11, Vg=-0.1; %5*Vgincr;
                vgm.c11=[vgm.c11(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            
            case 12, Vg=-0.25;
                vgm.c12=[vgm.c12(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 13, Vg=-1;
                vgm.c13=[vgm.c13(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 14, Vg=-2;
                vgm.c14=[vgm.c14(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 15, Vg=-4;
                vgm.c15=[vgm.c15(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 16, Vg=-6;
                vgm.c16=[vgm.c16(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 17, Vg=-8;
                vgm.c17=[vgm.c17(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            
            otherwise disp('VGis case is unexpected value'); 
        end
        
        if DT==0
            Scrap=0;
        else
            Scrap=Vnorm/DT; %crappy way of calculating Seebeck S_crap
        end

        valarr(count,:)=[HVpp power Vmean Vstd Vnorm Vstd Vnormroll Vstd Rheatmeasured Vg Scrap];
        namelist{count}=filex;        
        count=count+1;
    end
    
end
%%

cf2=fit(valarr(:,2), valarr(:,3), 'poly1');
cf3=fit(valarr(:,2), valarr(:,5), 'poly1');
cf4=fit(valarr(:,2), valarr(:,7), 'poly1');

%% plotting section
%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];

VGval=[0 0.05 0.1 0.25 1 2 4 6 8 0 -0.05 -0.1 -0.25 -1 -2 -4 -6 -8];
Svg=zeros(18,3);
for it=1:length(Svg)
    switch it
        case 1
            cfv0=fit(vgm.c0(:,2), vgm.c0(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];
        case 2
            cfv0=fit(vgm.c1(:,2), vgm.c1(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];
        case 3
            cfv0=fit(vgm.c2(:,2), vgm.c2(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];
        case 4
            cfv0=fit(vgm.c3(:,2), vgm.c3(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 5
            cfv0=fit(vgm.c4(:,2), vgm.c4(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 6
            cfv0=fit(vgm.c5(:,2), vgm.c5(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];        
        case 7
            cfv0=fit(vgm.c6(:,2), vgm.c6(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];        
        case 8
            cfv0=fit(vgm.c7(:,2), vgm.c7(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 9
            cfv0=fit(vgm.c8(:,2), vgm.c8(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];        
        case 10
            cfv0=fit(vgm.c9(:,2), vgm.c9(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 11
            cfv0=fit(vgm.c10(:,2), vgm.c10(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];  
        case 12
            cfv0=fit(vgm.c11(:,2), vgm.c11(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];
            
            
        case 13
            cfv0=fit(vgm.c12(:,2), vgm.c12(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];        
        case 14
            cfv0=fit(vgm.c13(:,2), vgm.c13(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 15
            cfv0=fit(vgm.c14(:,2), vgm.c14(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];        
        case 16
            cfv0=fit(vgm.c15(:,2), vgm.c15(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
        case 17
            cfv0=fit(vgm.c16(:,2), vgm.c16(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];    
        case 18
            cfv0=fit(vgm.c17(:,2), vgm.c17(:,3),'poly1');
            ci0=confint(cfv0);
            Svg(it,:)=[cfv0.p1 ci0(:,1)'];            
            
            
            
    end        
end



%{
xax=[1:count-1];
figure
subplot(2,2,1)
plot(xax, valarr(:,3));
title(strcat('w Airflow, Ch2Amp=', num2str(Ch2amp), 'A/V'));
xlabel('Time [minutes?]'); ylabel('\DeltaV [V]');

subplot(2,2,2)
errorbar(valarr(:,2), valarr(:,3), valarr(:,4), 'bs');
title('No Zero Normalization');
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf2=fit(valarr(:,2), valarr(:,3), 'poly1');
seeb2=num2str(-cf2.p1);
legend(strcat('S=',seeb2));

subplot(2,2,3)
errorbar(valarr(:,2), valarr(:,5), valarr(:,4), 'bs');
title('Preceding Zero Subtraction');
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf3=fit(valarr(:,2), valarr(:,5), 'poly1');
seeb3=num2str(-cf3.p1);
legend(strcat('S=',seeb3));

subplot(2,2,4)
errorbar(valarr(:,2), valarr(:,7), valarr(:,4), 'bs');
title('Rolling Average Zero Subtraction');
xlabel('\DeltaT [K]'); ylabel('\DeltaV [V]');
cf4=fit(valarr(:,2), valarr(:,7), 'poly1');
seeb4=num2str(-cf4.p1);
legend(strcat('S=',seeb4));
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'DC_newSCHPN2.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'DC_newSCHPN2.png'), 'png');

%}
%%
figure, scatter(VGval, Svg(:,1))
hold on
errorbar(VGval, Svg(:,1), Svg(:,2), Svg(:,3), 'LineStyle', 'none');
xlabel('V_G (V)');
ylabel('S (V/K)');
legend(filex(1:36));
ax1=axis;
axis([-10, 10, ax1(3), ax1(4)]);

saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'DC_SVG.fig'), 'fig');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'DC_SVG.png'), 'png');

%%
xcelfile=strcat(path,filex(1:sz-4),'_',date,'DC_newSCHPN2.xlsx');
headers={'MeasNum','HVpp', 'DT', 'Ch4Mean','StDev', 'PrecedZeroSub', 'StDev', '7pt RollingAvg', 'StDev', 'Rheatmeasured', 'Vg', 'Scrap'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');

%%
compilepath='D:\Probe Station Data\17.09.11 Oleyl Repeat round 2\Oleyl Repeat Round2 compile.xlsx';

XLSX_append(compilepath,strcat(path, filex(1:length(filex)-4),'_',date,'DC_newSCHPN2.png'), [-cf2.p1 -cf3.p1 -cf4.p1]);

toc
disp('complete');


