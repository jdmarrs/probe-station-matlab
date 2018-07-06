% Temperature interpolation

TempX=[24:0.1:50];
Tinv=1./(273.15+TempX);

[filename path] = uigetfile('.xlsx');
dat=importdata(strcat(path,filename));

columnsets=[1,7,13,19];

newmeans=zeros(length(TempX),4); 
newstdev=zeros(length(TempX),4);
newgvals=zeros(length(TempX),4);
newgstd=zeros(length(TempX),4);
normgs=zeros(length(TempX),4);
normgstdev=zeros(length(TempX),4);


for k=1:4 %four data sets in one csv, pulling columnsets
   start=columnsets(k);
   oldvals=dat.data.Sheet1(:,start:start+5);
   
   l1=length(oldvals(~isnan(oldvals(:,1))));
   old1=oldvals(1:l1,1:2);   
   l2=length(oldvals(~isnan(oldvals(:,3))));
   old2=oldvals(1:l2,3:4);
   l3=length(oldvals(~isnan(oldvals(:,5))));
   old3=oldvals(1:l3,5:6);
   
   newy1=interp1(old1(:,1), old1(:,2),TempX,'linear','extrap');   
   newy2=interp1(old2(:,1), old2(:,2),TempX,'linear','extrap');  
   newy3=interp1(old3(:,1), old3(:,2),TempX,'linear','extrap');
   
   for i=1:length(TempX)
       newmeans(i,k)=mean([newy1(i), newy2(i), newy3(i)]);
       newstdev(i,k)=std([newy1(i), newy2(i), newy3(i)]);
       newgvals(i,k)=mean([1/newy1(i), 1/newy2(i), 1/newy3(i)]);
       newgstd(i,k)=std([1/newy1(i), 1/newy2(i), 1/newy3(i)]);
       
       normgs(i,k)=mean([newy1(1)/newy1(i), newy2(1)/newy2(i), newy3(1)/newy3(i)]);
       normgstdev(i,k)=std([newy1(1)/newy1(i), newy2(1)/newy2(i), newy3(1)/newy3(i)]);
   end
   
   
end
%%
scatter(Tinv,normgs(:,1));
hold on 
scatter(Tinv,normgs(:,2));
scatter(Tinv,normgs(:,3));
scatter(Tinv,normgs(:,4));
%% 
colors=['r' 'g' 'b' 'k'];

hold on
for m=1:4
errorbar(Tinv,normgs(:,m),normgstdev(:,m)/2, colors(m));
end


%%
xcelfile=strcat(path,filename(1:length(filename)-5),' InterpolatedGvsTinvNormalized.xlsx');
headers={'K-1','1600', '400','100','25','1600stdev', '400stdev','100stdev','25stdev' };
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile, Tinv',1,'A2');
pause(0.25);
xlswrite(xcelfile,normgs,1, 'B2');
pause(0.25);
xlswrite(xcelfile, normgstdev, 1, 'F2');

%{
xcelfile=strcat(path,filename(1:length(filename)-5),' InterpolatedAverages.xlsx');
headers={'TempC','1600', '400','100','25','1600stdev', '400stdev','100stdev','25stdev' };
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile, TempX',1,'A2');
pause(0.25);
xlswrite(xcelfile,newmeans,1, 'B2');
pause(0.25);
xlswrite(xcelfile, newstdev, 1, 'F2');
%}



disp('complete');