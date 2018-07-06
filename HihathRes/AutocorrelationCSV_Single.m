[filename path] = uigetfile('.csv');


peaklist=zeros(1,2);
numcsv=1;

k=1;

    

filex=filename;

dat=importdata(strcat(path,filex),',',1);
firstmin=zeros(1,3);
peak=zeros(1,3);
secmin=zeros(1,3);

% this part finds the peak region in the y axis
for i=3:length(dat.data)        
    if ~peak(1) 
        if dat.data(i,3)> dat.data(i-1,3) && dat.data(i,3)> dat.data(i+1,3) && dat.data(i,3)> dat.data(i-2,3) && dat.data(i,3)> dat.data(i+2,3)
            peak(1,:)=dat.data(i,:);
        end
    end            
end
% end peak region part

xdat=dat.data(peak(1,1)-5:peak(1,1)+6,2);
ydat=dat.data(peak(1,1)-5:peak(1,1)+6,3);
hold on
plot(xdat,ydat);
[cfun, gof]=fit(xdat,ydat,'poly2');
poly2peak=cfun.p2/(-2*cfun.p1);        

namelist(numcsv)={filex};
peaklist(numcsv,:)=[poly2peak, gof.rsquare];

numcsv=numcsv+1;
    


disp('complete');