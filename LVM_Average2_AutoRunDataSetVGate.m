%preceding zero subtraction version 2016.07.14
%rolling average zero norm
clear all
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%initialize values
amp=[1/1000]; %this amplification is 1/gain
valarr=zeros(1, 9, 'double');
count=1;
setzero=0;
Vnorm=0;
HVpp=0;
Vg=0;
setcount=0;
zerocount=7;
Vnormroll=0;
Rheater=800; %ohms, resistance of heater for this junction.

%work on one file at a time
for k = 1 : length(allFiles)    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        Time=dat(3:term,1);
        Ch4=dat(3:term,2)*amp; % vdiff
        Vmean=mean(Ch4);
        Vstd=std(Ch4);
        VGis=str2double(filex(1,size(filex,2)-9:size(filex,2)-8));
        MODis=str2double(filex(1,size(filex,2)-13:size(filex,2)-12));
        if mod(MODis,2)==0 %if filename MODis Even, it is zero HVpp run
            setzero=Vmean;
            zerocount=zerocount+1;
            if zerocount==8
                zerolist(1:7)=setzero; 
            end
            zerolist=[zerolist setzero];
            rollingavg=mean(zerolist(zerocount-7:zerocount));            
            HVpp=0;
        elseif MODis==1 HVpp=9; 
        elseif MODis==3 HVpp=11; 
        elseif MODis==5 HVpp=13; 
        elseif MODis==7 HVpp=15; 
        elseif MODis==9 HVpp=17; 
        elseif MODis==11 HVpp=19; 
        end
        
        switch VGis
            case 0, Vg=0;
            case 1, Vg=0.1;
            case 2, Vg=0.4;
            case 3, Vg=1.6;
            case 4, Vg=6.4;
            case 5, Vg=0;
            case 6, Vg=-0.1;
            case 7, Vg=-0.4;
            case 8, Vg=-1.6;
            case 9, Vg=-6.4;
            otherwise disp('VGis case is unexpected value'); 
        end
        
        Vnorm=Vmean-setzero;        
        Vnormroll=Vmean-rollingavg;
        DT=1.803*HVpp^2/(8*Rheater);
        valarr(count,:)=[HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
        namelist{count}=filex;        
        count=count+1;
    end
    
end
%% plotting section
%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];
xax=[1:count-1];
figure

subplot(2,2,1)
plot(xax, valarr(:,3));
title('\DeltaV vs. Time, raw data sequence');
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

%% Vgate plotting section
vgm=struct('c0',NaN(1,9),'c1', NaN(1,9), 'c2', NaN(1,9),'c3',NaN(1,9),'c4', NaN(1,9), 'c6',NaN(1,9),'c7', NaN(1,9), 'c8', NaN(1,9), 'c9', NaN(1,9)); %vgmatrix
for i=1:length(valarr)
    VGis2=valarr(i,9);
    
    switch VGis2
        case 0, 
            vgm.c0=[vgm.c0();valarr(i,:)];
        case 0.1,
            vgm.c1=[vgm.c1();valarr(i,:)];
        case 0.4,
            vgm.c2=[vgm.c2();valarr(i,:)];
        case 1.6,
            vgm.c3=[vgm.c3();valarr(i,:)];
        case 6.4,
            vgm.c4=[vgm.c4();valarr(i,:)];
        case -0.1,
            vgm.c6=[vgm.c6();valarr(i,:)];
        case -0.4,
            vgm.c7=[vgm.c7();valarr(i,:)];
        case -1.6,
            vgm.c8=[vgm.c8();valarr(i,:)];
        case -6.4,
            vgm.c9=[vgm.c9();valarr(i,:)];
    end
end

%% 
vgm.c0=vgm.c0(~any(isnan(vgm.c0()),2),:);
vgm.c1=vgm.c1(~any(isnan(vgm.c1()),2),:);
vgm.c2=vgm.c2(~any(isnan(vgm.c2()),2),:);
vgm.c3=vgm.c3(~any(isnan(vgm.c3()),2),:);
vgm.c4=vgm.c4(~any(isnan(vgm.c4()),2),:);
vgm.c6=vgm.c6(~any(isnan(vgm.c6()),2),:);
vgm.c7=vgm.c7(~any(isnan(vgm.c7()),2),:);
vgm.c8=vgm.c8(~any(isnan(vgm.c8()),2),:);
vgm.c9=vgm.c9(~any(isnan(vgm.c9()),2),:);

cc=5; %choose column in valarr to plot: 3 no normalization, 5 preceding zero norm, 7 rolling zero norm

figure
subplot(3,3,1)
errorbar(vgm.c0(:,2), vgm.c0(:,cc), vgm.c0(:,4), 'bs')
title('Vg=0 preceding zero normalization, all'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf11=fit(vgm.c0(:,2), vgm.c0(:,cc), 'poly1');
c11=confint(cf11); c11d=abs(c11(1,1)-c11(2,1))/2;
seeb11=num2str(-cf11.p1); 
legend(strcat('S=',seeb11));

subplot(3,3,2)
errorbar(vgm.c1(:,2), vgm.c1(:,cc), vgm.c1(:,4), 'bs')
title('Vg=0.1'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf12=fit(vgm.c1(:,2), vgm.c1(:,cc), 'poly1');
c12=confint(cf12); c12d=abs(c12(1,1)-c12(2,1))/2;
seeb12=num2str(-cf12.p1);
legend(strcat('S=',seeb12));

subplot(3,3,3)
errorbar(vgm.c2(:,2), vgm.c2(:,cc), vgm.c2(:,4), 'bs')
title('Vg=0.4'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf13=fit(vgm.c2(:,2), vgm.c2(:,cc), 'poly1');
c13=confint(cf13); c13d=abs(c13(1,1)-c13(2,1))/2;
seeb13=num2str(-cf13.p1);
legend(strcat('S=',seeb13));

subplot(3,3,4)
errorbar(vgm.c3(:,2), vgm.c3(:,cc), vgm.c3(:,4), 'bs')
title('Vg=1.6'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf14=fit(vgm.c3(:,2), vgm.c3(:,cc), 'poly1');
c14=confint(cf14); c14d=abs(c14(1,1)-c14(2,1))/2;
seeb14=num2str(-cf14.p1);
legend(strcat('S=',seeb14));

subplot(3,3,5)
errorbar(vgm.c4(:,2), vgm.c4(:,cc), vgm.c4(:,4), 'bs')
title('Vg=6.4'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf15=fit(vgm.c4(:,2), vgm.c4(:,cc), 'poly1');
c15=confint(cf15); c15d=abs(c15(1,1)-c15(2,1))/2;
seeb15=num2str(-cf15.p1);
legend(strcat('S=',seeb15));

subplot(3,3,6)
errorbar(vgm.c6(:,2), vgm.c6(:,cc), vgm.c6(:,4), 'bs')
title('Vg=-0.1'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf16=fit(vgm.c6(:,2), vgm.c6(:,cc), 'poly1');
c16=confint(cf16); c16d=abs(c16(1,1)-c16(2,1))/2;
seeb16=num2str(-cf16.p1);
legend(strcat('S=',seeb16));

subplot(3,3,7)
errorbar(vgm.c7(:,2), vgm.c7(:,cc), vgm.c7(:,4), 'bs')
title('Vg=-0.4'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf17=fit(vgm.c7(:,2), vgm.c7(:,cc), 'poly1');
c17=confint(cf17); c17d=abs(c17(1,1)-c17(2,1))/2;
seeb17=num2str(-cf17.p1);
legend(strcat('S=',seeb17));

subplot(3,3,8)
errorbar(vgm.c8(:,2), vgm.c8(:,cc), vgm.c8(:,4), 'bs')
title('Vg=-1.6'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf18=fit(vgm.c8(:,2), vgm.c8(:,cc), 'poly1');
c18=confint(cf18); c18d=abs(c18(1,1)-c18(2,1))/2;
seeb18=num2str(-cf18.p1);
legend(strcat('S=',seeb18));

subplot(3,3,9)
errorbar(vgm.c9(:,2), vgm.c9(:,cc), vgm.c9(:,4), 'bs')
title('Vg=-6.4'); xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf19=fit(vgm.c9(:,2), vgm.c9(:,cc), 'poly1');
c19=confint(cf19); c19d=abs(c19(1,1)-c19(2,1))/2;
seeb19=num2str(-cf19.p1);
legend(strcat('S=',seeb19));
%%
Sgated=[-cf11.p1 -cf12.p1 -cf13.p1 -cf14.p1 -cf15.p1 -cf16.p1 -cf17.p1 -cf18.p1 -cf19.p1];
Sgatedxax=[0 0.1 0.4 1.6 6.4 -0.1 -0.4 -1.6 -6.4];
Sgatedconf=[c11d c12d c13d c14d c15d c16d c17d c18d c19d];
figure
errorbar(Sgatedxax,Sgated, Sgatedconf, 'bd', 'Linewidth', 2);
title('Gating on Ladder 3R'); xlabel('V_G_A_T_E [V]'); ylabel('S [V/K]');

%% filesave section
xcelfile=strcat(path,filex(1:sz-4),'_Means_Vgate.xlsx');
headers={'MeasNum','HVpp', 'DT', 'Ch4Mean','StDev', 'PrecedZeroSub', 'StDev', '7pt RollingAvg', 'StDev', 'Vgate'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');

disp('complete');


