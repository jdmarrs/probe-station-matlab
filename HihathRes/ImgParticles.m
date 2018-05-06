% automated image processing

[filename path]=uigetfile('.tif');
OImg=strcat(path, filename);
imTif = imread(OImg);
imTif2=imcrop(imTif, [1 1 1024 882]);
%%
%scalecrop=imcrop(imTif, [480 883 188 58]);
imGray=rgb2gray(imTif2);
imDesp=medfilt2(imGray, [4 4]); %can use [3 3]

%imshow(scalecrop);
%scalein=input('What is image magnification? input: example 1000000 or 1E6. Scale assumes 5.5mm Working Distance  ');
scale=20.45; %pix/nm for 1,000,000 x magnification
pix2nm=1/scale; %nm/pix
largestparticle=16; %nm radius
minparticle=2; %nm radius
largestareapix=(largestparticle*scale)^2*pi;
minparticlepix=(minparticle*scale)^2*pi;

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
    if stats(j).Area<largestareapix & stats(j).Area>minparticlepix        %excludes to small or too large particles
        %Ways to improve this: areadiams lists that change size at each
        %iteration so that find is not neccessary in subsequent section
        
        arealist(j)=stats(j).Area;
        majlist(j)=stats(j).MajorAxisLength;
        minlist(j)=stats(j).MinorAxisLength;
        mmavglist(j)=0.5*(stats(j).MajorAxisLength+stats(j).MinorAxisLength);
        perimlist(j)=stats(j).Perimeter;
    
        areadiams(j)=2*sqrt(arealist(j)/pi)*pix2nm;
        majmindiams(j)=mmavglist(j)*pix2nm;
        perimdiams(j)=perimlist(j)/pi*pix2nm;   
    end
end



%% histograms on particle sizes
%{
areadiamavg=2*sqrt(mean(arealist(find(arealist)))/pi)*pix2nm;
majmindiamavg=mean(mmavglist(find(mmavglist)))*pix2nm;
perimdiamavg=mean(perimlist(find(perimlist)))/pi*pix2nm;
nump=sz;

ad2=areadiams(find(areadiams));
md2=majmindiams(find(majmindiams));
pd2=perimdiams(find(perimdiams));

[hay hax] =hist(ad2, 20);
[hmy hmx]=hist(md2, 20);
[hpy hpx]=hist(pd2, 20);

cfunha=fit(hax',hay', 'gauss1');
cfunhm=fit(hmx',hmy', 'gauss1');
cfunhp=fit(hpx',hpy', 'gauss1');

sigmaha=sqrt((cfunha.c1^2)/2);
sigmahm=sqrt((cfunhm.c1^2)/2);
sigmahp=sqrt((cfunhp.c1^2)/2);
   
figure, hist(ad2)
hold on
plot(cfunha)
xlabel('Particle Diameter [nm]', 'FontSize', 12);
ylabel('Counts',  'FontSize', 12);
%}
%% writing the data
%{
valarr=[nump areadiamavg majmindiamavg perimdiamavg sigmaha sigmahm sigmahp];
szf=size(filename,2);
xcelfile=strcat(path,filename(1:szf-4),'.xlsx');
headers={'NumParticles', 'AreaDiam','MajMinDiam','PerimDiam', 'SigmaArea', 'SigmaAxis', 'SigmaPerimeter' };
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,valarr,1, 'A2');

%}