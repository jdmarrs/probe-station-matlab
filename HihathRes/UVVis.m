%{
filelist=dir('*.csv');
numfiles=size(filelist(1));
dat=cell(numfiles,1);

for j=1:numfiles
dat(j)=importdata(filelist.name(j,1));
%}

%%
A450=input('Absorbance at 450? ');
%ASPR=input('Absorbance at SPR? ');
d=input('Mean Diameter in nm? ');

N=(A450*1E14)/(d^2*(-0.295+1.36*exp(-((d-96.8)/78.2)^2)));

%% 