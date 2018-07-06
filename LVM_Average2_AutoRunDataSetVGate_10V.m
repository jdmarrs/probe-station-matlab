%preceding zero subtraction version 2016.07.14
%rolling average zero norm
%noise filtering 16.07.28
clear all
tic
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%initialize values
gain=1020;
amp=[1/gain]; %this amplification is 1/gain
valarr=zeros(0, 9, 'double');
count=1;
setzero=0;
Vnorm=0;
HVpp=0;
Vg=0;
Vgincr=2; %Vgate increment
%this structure method allows us to stop the data collection at any
%arbitrary point and have different sizes of data in each voltage set
vgm=struct('c0',NaN(0,9),'c1', NaN(0,9), 'c2', NaN(0,9),'c3',NaN(0,9),'c4', NaN(0,9), 'c5', NaN(0,9),'c6',NaN(0,9),'c7', NaN(0,9), 'c8', NaN(0,9), 'c9', NaN(0,9),'c10', NaN(0,9), 'c11', NaN(0,9), 'c12', NaN(0,9),'c13',NaN(0,9),'c14', NaN(0,9), 'c15', NaN(0,9),'c16',NaN(0,9),'c17', NaN(0,9)); %vgmatrix
setcount=0;
zerocount=7;
Vnormroll=0;
Rheater=5680; %ohms, resistance of heater for this junction.
overallmeanmedian=0; %of all datapoints
SCHPN=37.89; %spatially corected heater power number

%work on one file at a time
for k = 1 : length(allFiles)    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;   
        MODis=str2double(filex(1,size(filex,2)-13:size(filex,2)-12));
        
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        dat2=dat(:,2);
        term=size(dat,1);       
        Time=dat(1:term,1);       
        Vmedian2=median(dat2);
        Vstd2=std(dat2);
        %noise filtering
        if overallmeanmedian==0
            overallmeanmedian=Vmedian2*amp;
        end
        %omma=overallmeanmedian/amp;
        dat3=dat2(dat2>Vmedian2-3*Vstd2 & dat2<Vmedian2+3*Vstd2);        
        %amplificaiton is applied here
        Vmean=mean(dat3)*amp;
        Vmedian=median(dat3)*amp;
        Vstd=std(dat3)*amp;        
        VGis=str2double(filex(1,size(filex,2)-9:size(filex,2)-8));
        
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
        
        Vnorm=Vmean-setzero;        
        Vnormroll=Vmean-rollingavg;
        DT=SCHPN*HVpp^2/(8*Rheater);
        
        switch VGis
            case 0, Vg=0;
                vgm.c0=[vgm.c0(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 1, Vg=1*Vgincr;
                vgm.c1=[vgm.c1(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 2, Vg=2*Vgincr;
                vgm.c2=[vgm.c2(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 3, Vg=3*Vgincr;
                vgm.c3=[vgm.c3(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 4, Vg=4*Vgincr;
                vgm.c4=[vgm.c4(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 5, Vg=5*Vgincr;
                vgm.c5=[vgm.c5(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 6, Vg=0;
                vgm.c6=[vgm.c6(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 7, Vg=-1*Vgincr;
                vgm.c7=[vgm.c7(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 8, Vg=-2*Vgincr;
                vgm.c8=[vgm.c8(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 9, Vg=-3*Vgincr;
                vgm.c9=[vgm.c9(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 10, Vg=-4*Vgincr;
                vgm.c10=[vgm.c10(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            case 11, Vg=-5*Vgincr;
                vgm.c11=[vgm.c11(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
            %{
            case 12, Vg=-3*Vgincr;
                vgm.c12=[vgm.c12(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 13, Vg=-4*Vgincr;
                vgm.c13=[vgm.c13(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 14, Vg=-5*Vgincr;
                vgm.c14=[vgm.c14(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 15, Vg=-6*Vgincr;
                vgm.c15=[vgm.c15(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 16, Vg=-7*Vgincr;
                vgm.c16=[vgm.c16(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            case 17, Vg=-8*Vgincr;
                vgm.c17=[vgm.c17(); HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vstd Vg];
            %}
            otherwise disp('VGis case is unexpected value'); 
        end
        
        
        valarr(count,:)=[HVpp DT Vmean Vstd Vnorm Vstd Vnormroll Vmedian Vg];
        overallmeanmedian=mean(valarr(1:count,8));
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
title(strcat('w Air, R_h_e_a_t=', num2str(Rheater), ' \Omega'));
xlabel('Time [minutes?]'); ylabel('\DeltaV [V]');

subplot(2,2,2)
errorbar(valarr(:,2), valarr(:,3), valarr(:,4), 'bs');
title(filex);
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf22=fit(valarr(:,2), valarr(:,3), 'poly1');
seeb2=num2str(-cf22.p1);
legend(strcat('S=',seeb2));

subplot(2,2,3)
errorbar(valarr(:,2), valarr(:,5), valarr(:,4), 'bs');
title(strcat('Prec 0 Sub, gain=', num2str(gain)));
xlabel('\Delta T [K]'); ylabel('\DeltaV [V]');
cf33=fit(valarr(:,2), valarr(:,5), 'poly1');
seeb3=num2str(-cf33.p1);
legend(strcat('S=',seeb3));

subplot(2,2,4)
errorbar(valarr(:,2), valarr(:,7), valarr(:,4), 'bs');
title(strcat('RollAvgZeroSub, SCHPN=', num2str(SCHPN)));
xlabel('\DeltaT [K]'); ylabel('\DeltaV [V]');
cf44=fit(valarr(:,2), valarr(:,7), 'poly1');
seeb4=num2str(-cf44.p1);
legend(strcat('S=',seeb4));

saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'.png'), 'png');
%% this part removes the NaNs because i'm lousy at coding.
%is this part un-neccessary when we define using NaN(0,9)?
%{
vgm.c0=vgm.c0(~any(isnan(vgm.c0()),2),:);
vgm.c1=vgm.c1(~any(isnan(vgm.c1()),2),:);
vgm.c2=vgm.c2(~any(isnan(vgm.c2()),2),:);
vgm.c3=vgm.c3(~any(isnan(vgm.c3()),2),:);
vgm.c4=vgm.c4(~any(isnan(vgm.c4()),2),:);
vgm.c5=vgm.c5(~any(isnan(vgm.c5()),2),:);
vgm.c6=vgm.c6(~any(isnan(vgm.c6()),2),:);
vgm.c7=vgm.c7(~any(isnan(vgm.c7()),2),:);
vgm.c8=vgm.c8(~any(isnan(vgm.c8()),2),:);
vgm.c9=vgm.c9(~any(isnan(vgm.c9()),2),:);
vgm.c10=vgm.c10(~any(isnan(vgm.c10()),2),:);
vgm.c11=vgm.c11(~any(isnan(vgm.c11()),2),:);

vgm.c12=vgm.c12(~any(isnan(vgm.c12()),2),:);
vgm.c13=vgm.c13(~any(isnan(vgm.c13()),2),:);
vgm.c14=vgm.c14(~any(isnan(vgm.c14()),2),:);
vgm.c15=vgm.c15(~any(isnan(vgm.c15()),2),:);
vgm.c16=vgm.c16(~any(isnan(vgm.c16()),2),:);
vgm.c17=vgm.c17(~any(isnan(vgm.c17()),2),:);
%}
%%
cc=7; %choose column in valarr to plot: 3 no normalization, 5 preceding zero norm, 7 rolling zero norm


%these are the slopes of DT vs DV plots, giving us -seebeck coefficient
cf0=fit(vgm.c0(:,2), vgm.c0(:,cc), 'poly1');
cf1=fit(vgm.c1(:,2), vgm.c1(:,cc), 'poly1');
cf2=fit(vgm.c2(:,2), vgm.c2(:,cc), 'poly1');
cf3=fit(vgm.c3(:,2), vgm.c3(:,cc), 'poly1');
cf4=fit(vgm.c4(:,2), vgm.c4(:,cc), 'poly1');
cf5=fit(vgm.c5(:,2), vgm.c5(:,cc), 'poly1');
cf6=fit(vgm.c6(:,2), vgm.c6(:,cc), 'poly1');
cf7=fit(vgm.c7(:,2), vgm.c7(:,cc), 'poly1');
cf8=fit(vgm.c8(:,2), vgm.c8(:,cc), 'poly1');
cf9=fit(vgm.c9(:,2), vgm.c9(:,cc), 'poly1');
cf10=fit(vgm.c10(:,2), vgm.c10(:,cc), 'poly1');
cf11=fit(vgm.c11(:,2), vgm.c11(:,cc), 'poly1');
%{
cf12=fit(vgm.c12(:,2), vgm.c12(:,cc), 'poly1');
cf13=fit(vgm.c13(:,2), vgm.c13(:,cc), 'poly1');
cf14=fit(vgm.c14(:,2), vgm.c14(:,cc), 'poly1');
cf15=fit(vgm.c15(:,2), vgm.c15(:,cc), 'poly1');
cf16=fit(vgm.c16(:,2), vgm.c16(:,cc), 'poly1');
cf17=fit(vgm.c17(:,2), vgm.c17(:,cc), 'poly1');
%}
%95% confidence interfals in the linear fits determines the error bars
c0=confint(cf0); c0d=abs(c0(1,1)-c0(2,1))/2;
c1=confint(cf1); c1d=abs(c1(1,1)-c1(2,1))/2; 
c2=confint(cf2); c2d=abs(c2(1,1)-c2(2,1))/2;
c3=confint(cf3); c3d=abs(c3(1,1)-c3(2,1))/2;
c4=confint(cf4); c4d=abs(c4(1,1)-c4(2,1))/2;
c5=confint(cf5); c5d=abs(c5(1,1)-c5(2,1))/2;
c6=confint(cf6); c6d=abs(c6(1,1)-c6(2,1))/2;
c7=confint(cf7); c7d=abs(c7(1,1)-c7(2,1))/2;
c8=confint(cf8); c8d=abs(c8(1,1)-c8(2,1))/2;
c9=confint(cf9); c9d=abs(c9(1,1)-c9(2,1))/2;
c10=confint(cf10); c10d=abs(c10(1,1)-c10(2,1))/2;
c11=confint(cf11); c11d=abs(c11(1,1)-c11(2,1))/2; 
%{
c12=confint(cf12); c12d=abs(c12(1,1)-c12(2,1))/2;
c13=confint(cf13); c13d=abs(c13(1,1)-c13(2,1))/2;
c14=confint(cf14); c14d=abs(c14(1,1)-c14(2,1))/2;
c15=confint(cf15); c15d=abs(c15(1,1)-c15(2,1))/2;
c16=confint(cf16); c16d=abs(c16(1,1)-c16(2,1))/2;
c17=confint(cf17); c17d=abs(c17(1,1)-c17(2,1))/2;
%}
%%
Sgated=[-cf0.p1 -cf1.p1 -cf2.p1 -cf3.p1 -cf4.p1 -cf5.p1 -cf6.p1 -cf7.p1 -cf8.p1 -cf9.p1 -cf10.p1 -cf11.p1]; % -cf12.p1 -cf13.p1 -cf14.p1 -cf15.p1 -cf16.p1 -cf17.p1];
Sgatedxax=[0 1 2 3 4 5 0 -1 -2 -3 -4 -5]*Vgincr;
Sgatedconf=[c0d c1d c2d c3d c4d c5d c6d c7d c8d c9d c10d c11d]; % c12d c13d c14d c15d c16d c17d];
figure
errorbar(Sgatedxax,Sgated, Sgatedconf,'*g', 'Linewidth', 2);
title(filename); xlabel('V_G_A_T_E [V]'); ylabel('S [V/K]');
legend(filename);

saveas(gca,strcat(path, filex(1:length(filex)-4),'_VG_',date,'.png'), 'png');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_VG_',date,'.fig'), 'fig');
%% filesave section

xcelfile=strcat(path,filex(1:sz-4),'_Means_VgateSkip19.xlsx');
headers={'MeasNum','HVpp', 'DT', 'Ch4Mean','StDev', 'PrecedZeroSub', 'StDev', '7pt RollingAvg', 'Median', 'Vgate'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
toc
disp('complete');


