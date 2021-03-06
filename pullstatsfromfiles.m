%analyze some data from a folder full of excel files
%pullstatsfromfiles


[filename path]=uigetfile('.xlsx');
allfiles=dir(path);
tic

rheatmean=NaN(length(allfiles),1);
rheatstd=NaN(length(allfiles),1);

for k=3:length(allfiles)
     if(strfind(allfiles(k).name, '.xlsx'))
         filek=allfiles(k).name;
         dat=importdata(strcat(path,filek));
         
         index=find(dat.data.Sheet1(:,9));
         nonzeros=dat.data.Sheet1(index,9);
         
         rheatmean(k,1)=mean(nonzeros);
         rheatstd(k,1)=std(nonzeros);
         
         
         
     end
     
     
end
%%
figure
errorbar([1:k],rheatmean,rheatstd)
xlabel('filenumber');
ylabel('Mean Heater R Ohms');


%%
compiled=importdata('D:\Probe Station Data\17.08.02 Round 2 chips Ladder\R2 Ladder Seebeck Compiled.xlsx');
S1=compiled.data.Sheet1(:,1);
for j=1:length(S1)
    S1err(j)=range(compiled.data.Sheet1(j,1:3));
end
figure
errorbar(1:length(S1),S1,S1err)
xlabel('index'); ylabel('Seebeck Coefficient V/K');

%%

figure
errorbar(rheatmean(3:length(rheatmean),1),S1,S1err, '.k');
xlabel('Mean R Heater Ohms'); ylabel('Seebeck V/K');




toc
