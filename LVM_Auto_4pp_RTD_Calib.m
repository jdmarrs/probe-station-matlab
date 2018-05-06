%this is rtd calib 4pp 16.08.17
%preceding zero subtraction version 2016.07.14
%rolling average zero norm
clear all
tic
[filename path]=uigetfile('.lvm');
allFiles = dir(path);
namelist=cell(length(allFiles),1);
sz=size(filename,2); %assumes format filename_01.lvm, 1 any number

%initialize values
amp=[-1E-3]; %this is keithley 617
valarr=zeros(1, 4, 'double');
gooddata=valarr;
count=1;
count2=1;
setzero=0;
Vnorm=0;
HVpp=0;
setcount=0;
zerocount=7;
Vnormroll=0;
HVzeros=NaN(0,1);
Rheater=950; %ohms, resistance of heater for this junction.


%work on one file at a time
for k = 1 : length(allFiles)    
    if(strfind(allFiles(k).name, '.lvm'))
        filex=allFiles(k).name;   
        %data portion
        datums=importdata(strcat(path,filex),'\t',2);
        dat=datums.data;
        term=size(dat,1);
        Time=dat(3:term,1);
        Ch1=dat(3:term,2);
        Ch2=dat(3:term,3);
        Ch3=dat(3:term,4);
        Ch4=dat(3:term,5)*amp;
        Vdiff=Ch2-Ch3;
        
        [linfit gof]=fit(Vdiff, Ch4,'poly1');
        Rdut=1/(linfit.p1);
        
        
        
        %Rmean=mean(Ch4);
        %Vstd=std(Ch4);
        HVzeros=[HVzeros; 0];
        MODis=str2double(filex(1,size(filex,2)-9:size(filex,2)-8));
        if mod(MODis,2)==0 %if filename MODis Even, it is zero HVpp run
            %setzero=Vmean;
            %zerocount=zerocount+1;
            %HVzeros(k,1)=1;
            %if zerocount==8 zerolist(1:7)=setzero; end
            %zerolist=[zerolist setzero];
            %rollingavg=mean(zerolist(zerocount-7:zerocount));            
            HVpp=0;
        elseif MODis==1 HVpp=9; elseif MODis==3 HVpp=11; elseif MODis==5 HVpp=13; elseif MODis==7 HVpp=15; elseif MODis==9 HVpp=17; elseif MODis==11 HVpp=19; end
        %Vnorm=Vmean-setzero;        
        %Vnormroll=Vmean-rollingavg;
        DT=1.803*HVpp^2/(8*Rheater);
        valarr(count,:)=[HVpp DT Rdut gof.rsquare];
        
        if gof.rsquare>0.82
           
           gooddata(count2,:)= [HVpp DT Rdut gof.rsquare];
           count2=count2+1;
            
        end
        
        
        namelist{count}=filex;        
        count=count+1;
    end
    
end


%% plotting section
%colors=['r', 'b','y','m','c','r','g','b','k','y','m','c','r','g','b','k'];

xax=[1:count-1];
subplot(2,2,1)
plot(xax, valarr(:,3));
title(filename(1:length(filename)-20));
xlabel('Time [minutes?]'); ylabel('R_D_U_T');

subplot(2,2,2)
errorbar(valarr(:,1), valarr(:,3), valarr(:,4), 'bs');
title('No Zero Normalization');
xlabel('HVpp'); ylabel('R');
cf2=fit(valarr(:,1), valarr(:,3), 'poly1');
seeb2=num2str(-cf2.p1);
legend(strcat('-slope=',seeb2));

subplot(2,2,3)
plot([1:length(gooddata)], gooddata(:,3));
title(filename(1:length(filename)-20));
xlabel('Time [minutes?]'); ylabel('R_D_U_T');

subplot(2,2,4)
errorbar(gooddata(:,1), gooddata(:,3), gooddata(:,4), 'bs');
title('No Zero Normalization');
xlabel('HVpp'); ylabel('R');
cf2=fit(gooddata(:,1), gooddata(:,3), 'poly1');
seeb2=num2str(-cf2.p1);
legend(strcat('-slope=',seeb2));

%{
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
%}
saveas(gca,strcat(path, filex(1:length(filex)-4),'_wrong.png'), 'png');

%% temperature




%%
xcelfile=strcat(path,filex(1:sz-4),'_Means_ZeroNorms_wrong.xlsx');
headers={'MeasNum','HVpp', 'DT', 'R (Ohms)','GoF'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,gooddata,1, 'B2');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');

toc
disp('complete');


