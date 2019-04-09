% automated image processing

[filename path]=uigetfile('.tif');
OImg=strcat(path, filename);
imTif = imread(OImg);
%imTif2=imcrop(imTif, [1 1 1024 883]);
%% need to set for TEM images
%scalecrop=imcrop(imTif, [530 883 138 58]);
imGray=im2uint8(imTif);
imDesp=medfilt2(imGray(:,:,1), [4 4]); %can use [3 3]

%imshow(scalecrop);
%scalein=input('What is image magnification? input: example 1000000 or 1E6. Scale assumes 5.5mm Working Distance  ');
scale=5.36; %pix/nm for 50nm scale bar
pix2nm=1/scale; %nm/pix
%scales for different magnifications
%scale 500kx = 1.71; %pix/nm
%scale 250kx = 0.8505; %pix/nm
%

%%
%{
histo=imhist(imDesp);
midval=sum(histo)/2;
key=0;
for i=1:256
    if key<midval
        key=key+histo(i);
        midp=i;
    end
end

[peak, mode]=max(histo);
cfun=fit([1:256]', histo, 'gauss1');
stdev=sqrt(cfun.c1^2/2);
%imbw=im2bw(imDesp, midp/256); %thresholding
%}

imbw=im2bw(imDesp, graythresh(imDesp));
i1=imbw;
se = strel('disk',2);
i2=imopen(i1,se);
i3=imdilate(i2, se);
figure, imshow(i3)

%% regionprops to get particle info
props=['all']; 
stats=regionprops(i3, props);
sz=size(stats, 1);
arealist=zeros(sz,1);
majlist=zeros(sz,1);
minlist=zeros(sz,1);
mmavglist=zeros(sz,1);
perimlist=zeros(sz,1);
areadiams=zeros(sz,1);
majmindiams=zeros(sz,1);
perimdiams=zeros(sz,1);

for j=1:sz
    arealist(j)=stats(j).Area;
    majlist(j)=stats(j).MajorAxisLength;
    minlist(j)=stats(j).MinorAxisLength;
    mmavglist(j)=0.5*(stats(j).MajorAxisLength+stats(j).MinorAxisLength);
    perimlist(j)=stats(j).Perimeter;
    
    areadiams(j)=2*sqrt(arealist(j)/pi)*pix2nm;
    majmindiams(j)=mmavglist(j)*pix2nm;
    perimdiams(j)=perimlist(j)/pi*pix2nm;   
end
%% histograms on particle sizes
areadiamavg=2*sqrt(mean(arealist)/pi)*pix2nm;
majmindiamavg=mean(mmavglist)*pix2nm;
perimdiamavg=mean(perimlist)/pi*pix2nm;
nump=sz;

[hay hax] =hist(areadiams);
[hmy hmx]=hist(majmindiams);
[hpy hpx]=hist(perimdiams);

cfunha=fit(hax',hay', 'gauss1');
cfunhm=fit(hmx',hmy', 'gauss1');
cfunhp=fit(hpx',hpy', 'gauss1');

sigmaha=sqrt((cfunha.c1^2)/2);
sigmahm=sqrt((cfunhm.c1^2)/2);
sigmahp=sqrt((cfunhp.c1^2)/2);
   
figure, hist(areadiams)
hold on
plot(cfunha)
xlabel('Particle Diameter [nm]', 'FontSize', 12);
ylabel('Counts',  'FontSize', 12);
%% writing the data
valarr=[nump areadiamavg majmindiamavg perimdiamavg sigmaha sigmahm sigmahp];
szf=size(filename,2);
xcelfile=strcat(path,filename(1:szf-4),'.xlsx');
headers={'NumParticles', 'AreaDiam','MajMinDiam','PerimDiam', 'SigmaArea', 'SigmaAxis', 'SigmaPerimeter' };
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');