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
gain=1;
amp=[1E-5]; %This is K617
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
        Ch1=dat(3:term,2);
        Ch2=dat(3:term,3)*amp;
        [linfit gof]=fit(Ch1, Ch2,'poly1');
        Rdut=1/(linfit.p1);
        Rsquare=gof.rsquare;
              
        %Time=dat(1:term,1);       
        %Vmedian2=median(dat2);
        %Vstd2=std(dat2);
        %noise filtering
        if overallmeanmedian==0
            %overallmeanmedian=Vmedian2*amp;
        end
        %omma=overallmeanmedian/amp;
        %dat3=dat2(dat2>Vmedian2-3*Vstd2 & dat2<Vmedian2+3*Vstd2);        
        %amplificaiton is applied here
        Vmean=mean(dat2)*amp;
        %Vmedian=median(dat3)*amp;
        %Vstd=std(dat3)*amp;        
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
        
        %Vnorm=Vmean-setzero;        
        %Vnormroll=Vmean-rollingavg;
        DT=SCHPN*HVpp^2/(8*Rheater);
        
        switch VGis
            case 0, Vg=0;
                vgm.c0=[vgm.c0(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 1, Vg=1*Vgincr;
                vgm.c1=[vgm.c1(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 2, Vg=2*Vgincr;
                vgm.c2=[vgm.c2(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 3, Vg=3*Vgincr;
                vgm.c3=[vgm.c3(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 4, Vg=4*Vgincr;
                vgm.c4=[vgm.c4(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 5, Vg=5*Vgincr;
                vgm.c5=[vgm.c5(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 6, Vg=0;
                vgm.c6=[vgm.c6(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 7, Vg=-1*Vgincr;
                vgm.c7=[vgm.c7(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 8, Vg=-2*Vgincr;
                vgm.c8=[vgm.c8(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 9, Vg=-3*Vgincr;
                vgm.c9=[vgm.c9(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 10, Vg=-4*Vgincr;
                vgm.c10=[vgm.c10(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
            case 11, Vg=-5*Vgincr;
                vgm.c11=[vgm.c11(); HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
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
        
        
        valarr(count,:)=[HVpp DT Rdut Rdut Rsquare Rdut Rdut Rdut Vg];
        overallmeanmedian=mean(valarr(1:count,8));
        namelist{count}=filex;        
        count=count+1;
        
    end
    
end

%% 
v0m=mean(vgm.c0(:,3));
v1m=mean(vgm.c1(:,3));
v2m=mean(vgm.c2(:,3));
v3m=mean(vgm.c3(:,3));
v4m=mean(vgm.c4(:,3));
v5m=mean(vgm.c5(:,3));
v6m=mean(vgm.c6(:,3));
v7m=mean(vgm.c7(:,3));
v8m=mean(vgm.c8(:,3));
v9m=mean(vgm.c9(:,3));
v10m=mean(vgm.c10(:,3));
v11m=mean(vgm.c11(:,3));

v0s=std(vgm.c0(:,3));
v1s=std(vgm.c1(:,3));
v2s=std(vgm.c2(:,3));
v3s=std(vgm.c3(:,3));
v4s=std(vgm.c4(:,3));
v5s=std(vgm.c5(:,3));
v6s=std(vgm.c6(:,3));
v7s=std(vgm.c7(:,3));
v8s=std(vgm.c8(:,3));
v9s=std(vgm.c9(:,3));
v10s=std(vgm.c10(:,3));
v11s=std(vgm.c11(:,3));

Rmeangate=[v0m v1m v2m v3m v4m v5m v6m v7m v8m v9m v10m v11m];
Rgatedxax=[0 1 2 3 4 5 0 -1 -2 -3 -4 -5]*Vgincr;
Rgatederr=[v0s v1s v2s v3s v4s v5s v6s v7s v8s v9s v10s v11s];

%% plotting section
%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];
xax=[1:count-1];
figure

subplot(2,2,1)
plot(xax, valarr(:,3));
title(strcat('w Air, R_h_e_a_t=', num2str(Rheater), ' \Omega'));
xlabel('Time [minutes?]'); ylabel('R [\Omega]');

subplot(2,2,2)
plot(valarr(:,2), valarr(:,3),'bs');
title(filex);
xlabel('\Delta T [K]'); ylabel('R [\Omega]');
cf22=fit(valarr(:,2), valarr(:,3), 'poly1');
seeb2=num2str(-cf22.p1);
legend(strcat('S=',seeb2));

subplot(2,2,3)
plot(xax, valarr(:,5));
title(strcat('Prec 0 Sub, amp=', num2str(amp)));
xlabel('Time [minutes?]'); ylabel('Rsquare');
cf33=fit(valarr(:,2), valarr(:,4), 'poly1');
seeb3=num2str(-cf33.p1);
legend(strcat('S=',seeb3));

subplot(2,2,4)
errorbar(Rgatedxax,Rmeangate, Rgatederr,'*g', 'Linewidth', 2);
title(filename); xlabel('V_G_A_T_E [V]'); ylabel('R [\Omega]');


saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'.png'), 'png');
saveas(gca,strcat(path, filex(1:length(filex)-4),'_',date,'.fig'), 'fig');
%%




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


