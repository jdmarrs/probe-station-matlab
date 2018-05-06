% Temperature interpolation

TempX=[24:50];

[filename path] = uigetfile('.csv');

dat=importdata(strcat(path,filename),',',3);
disp(dat.colheaders{3,:});