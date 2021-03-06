% automated image processing
%this version had median diameter
%this version has background subtraction

[filename path]=uigetfile('.tif');
filename1=filename;
allFiles = dir(path);
namelist=cell(length(allFiles),1);
valarr=zeros(length(allFiles),6);
imgcount=1;


for k = 1 : length(allFiles)

    if(strfind(allFiles(k).name, '.tif'))

        filename=allFiles(k).name;
        OImg=strcat(path, filename);
        imTif = imread(OImg);
        imTif2=imcrop(imTif, [1 1 2048 1766]);  % for normal Res
        % imTif2=imcrop(imTif, [1 1 1024 882]);  % for normal 1024x images
        
        %scalecrop=imcrop(imTif, [480 883 188 58]);
        imGray=rgb2gray(imTif2);
        imDesp=medfilt2(imGray, [4 4]); %can use [3 3]
        %scalein=1E6;
        %scalein=input('What is image magnification? input: example 1000000 or 1E6. Scale assumes 5.5mm Working Distance  ');
        scale=20.45; %pix/nm for x magnification
        pix2nm=1/scale; %nm/pix
        largestparticle=19; %nm radius
        minparticle=2; %nm radius
        largestareapix=(largestparticle*scale)^2*pi;
        minparticlepix=(minparticle*scale)^2*pi;

        %scales for different magnifications
        %scale 500kx = 1.71; %pix/nm
        %scale 250kx = 0.8505; %pix/nm
        
        backg=imopen(imDesp,strel('disk',round(largestparticle/pix2nm)));
        imod=imDesp-backg;
        
        imbw=im2bw(imod, graythresh(imod));
        se = strel('disk',2);
        i2=imopen(imbw,se);
        i3=imdilate(i2, se);
        %regionprops to get particle info
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
            if stats(j).Area<largestareapix && stats(j).Area>minparticlepix        %excludes to small or too large particles
                %Ways to improve this: areadiams lists that change size at each
                %iteration so that find is not neccessary in subsequent section        
                arealist(j)=stats(j).Area;
                majlist(j)=stats(j).MajorAxisLength;
                minlist(j)=stats(j).MinorAxisLength;
                mmavglist(j)=0.5*(stats(j).MajorAxisLength+stats(j).MinorAxisLength);            
                areadiams(j)=2*sqrt(arealist(j)/pi)*pix2nm;
                majmindiams(j)=mmavglist(j)*pix2nm;  
            end
        end

        %% histograms on particle sizes
        bins=[1:1:40];
        areadiamavg=2*sqrt(mean(arealist(find(arealist)))/pi)*pix2nm;
        majmindiamavg=mean(mmavglist(find(mmavglist)))*pix2nm;
        ad2=areadiams(find(areadiams));
        md2=majmindiams(find(majmindiams));
        nump=size(ad2,1);
        [hay hax] =hist(ad2, bins);
        [hmy hmx]=hist(md2, bins);
        cfunha=fit(hax',hay', 'gauss1');
        cfunhm=fit(hmx',hmy', 'gauss1');
        sigmaha=sqrt((cfunha.c1^2)/2);
        sigmahm=sqrt((cfunhm.c1^2)/2);
        mediandiam=2*sqrt(median(arealist(find(arealist)))/pi)*pix2nm;

        valarr(imgcount,:)=[nump areadiamavg majmindiamavg sigmaha sigmahm mediandiam];
    
        namelist(imgcount)={filename};
        imgcount=imgcount+1;
   end
    
end

%% writing the data
valarr2=valarr(1:imgcount-1,:);
szf=size(filename1,2);
xcelfile=strcat(path,filename1(1:szf-4),' Diameters.xlsx');
headers={'Image Name', 'NumParticles', 'AreaDiam','MajMinDiam', 'SigmaArea', 'SigmaAxis', 'MedianDiam'};
xlswrite(xcelfile, headers,1,'A1');
pause(0.25);
xlswrite(xcelfile,namelist,1, 'A2');
pause(0.25);
xlswrite(xcelfile,valarr2,1, 'B2');
