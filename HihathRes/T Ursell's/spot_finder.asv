%Tristan Ursell
%Spot Finding Algorithm
%November 2012
%
% [region] = spot_finder(Im0,min_area,sz,rel_std,minsz);
% [region] = spot_finder(Im0,min_area,sz,rel_std,minsz,'plot');
%
%This program uses natural image features to perform segmentation of bright
%regions in a noisy background (e.g. diffraction limited spots in
%microscopy images).  
%
%Im0 is the input image matrix.
%
%The control parameters are:
%
%min_area = the minimum area of an image region in which to look for any
%kind fo spot.  In other words, the maximum possible number of spots in the
%image will be A/min_area where 'A' is the image area in pixels, but any
%region may have an area larger than this value.  This is the most
%sensitive parameter.
%
%rel_std = sets the relative remapping of pixel intensities in the filter
%block of size sz.  If the rel_std = 0, then the filter is simply a block
%averaging filter of size sz.  If rel_std >> 1 then the filter essentially
%returns the original image.  Setting rel_std=1 (recommended) tries to keep
%all pixel values in the filter block within one STD of the intensity
%values in that block.
%
%sz = the square block size of the relative noise filter, which should be
%approximately as large as the smallest feature one hopes to detect.  This
%number must be odd.
%
%minsz = minimum area of the largest contiguous region from region
%thresholding used to find the centroid.  Must be greater than 1.  Once 
%the image has been subdivied into sub-region, inside of which the script
%presumes there is a spot to track, this is value helps determine the local
%threshold based on what a minimum acceptable spot size might be.
%
%maxsz = maximum area of the largest contiguous region from region
%thresholding used to find the centroid.  Must be greater than or equal to
%min_area but less than the region size.  Setting maxsz = ~ 10*minsz should
%be fine.
%
%The program outputs a structure array 'region' with fields:
%region(i).reg_centX = X center of the region i.
%region(i).reg_centY = Y center of the region i.
%region(i).thresh = region-specific threshold to find point group.
%region(i).Ycoords = Y coordinates of point group in region i.
%region(i).Xcoords = X coordinates of point group in region i.
%region(i).Ints = intensities of point group in region i.
%region(i).Xcent = spot centroid X coordinate.
%region(i).Ycent = spot centroid Y coordinate.
%region(i).on_border = indicates if point group is on image border.
%region(i).size_pass = indicates if any point group metthe  size requirements.
%region(i).close_regs = a list of all other cent-regions whose minimum
%distance to the current region is less than or equal to 'sz'.
%
%Example:
%
% %set up the problem
% Im0=imread('rice.png');
% min_area=15; %will select a few false negatives
% %min_area=10; %will select a few false positives
% sz=3;
% rel_std=1;
% minsz=100; %(approximately the size of a grain of rice)
%
% region=spot_finder(Im0,min_area,sz,rel_std,minsz,'plot');

function region=spot_finder(Im0,min_area,sz,rel_std,minsz,varargin)
%
%***************USER CONTROL******************
%minimum area of sub-region
min_area=12;

%relnoise filter size
sz=5;

%relnoise filter STD
rel_std=1;

%minimum size of largest contiguous region
minsz=3;
%
%***************ALGORITHM CONTROL*************
%resolution of intensities

res=100;

%maximum size of largest contiguous region
maxsz=10*minsz;

%Sets the radius (in pxls) for sub-sub-region dilation
radius=1;
strel1=strel('disk',round(radius),0);
%********************************************

%{
%get image file
[fname,path1,filter1]=uigetfile({'*.tif;*.tiff;*.png;*.jpg;*.bmp','Image files ( tif, png, jpg, bmp )'},'Pick image file.');
if filter1==0
    return
end
file1=fullfile(path1,fname);

%number of images in stack
Im_info=imfinfo(file1);
N=length(Im_info);

%image size (pxls)
sx=Im_info.Width;
sy=Im_info.Height;
%}

[sy,sx]=size(Im0);

%********************************************
%****THE ALGORITHM****
%********************************************
%normalize the image intensity
C0=mat2gray(Im0);

%smooth image with relnoise filter
C=mat2gray(relnoise(C0,sz,rel_std,'square'));

%Run through list ('ilist') of hmin values and calculate how many regions are
%segmented for each value of hmin, put into 'numregs'.
ilist=0:0.01:0.99;
numregs=zeros(1,length(ilist));
h1=waitbar(0,'Calculating hmin parameter...');
for q=1:length(ilist)
    %Cmin=1-imhmin(C,ilist(q));
    Cmin=imhmin(1-C,ilist(q));
    Cwater=watershed(Cmin,8);
    numregs(q)=max(Cwater(:));
    
    if abs(min(diff(numregs(1:q))))>=numregs(q)
        break
    end    
    waitbar(ilist(q),h1,['Calculating hmin parameter ... ' num2str(numregs(q))])
end
close(h1)

%Smooth the 'numregs' vector for peak finding and subsequent hmin choice
filt1 = fspecial('gaussian',[1,5],2);
conv1 = filt1/sum(filt1);

%convolve peak data with small STD gaussian
%numregs_smth=conv(numregs,conv1,'same'); %use smoothed region number function
numregs_smth=numregs;

[m,x0]=min(diff(numregs_smth));

if m==0
    Cmin=1-C;
else
    y0=mean(numregs_smth(x0+1));
    x0=mean(x0+1);
    m=mean(m);
    hmin=(x0-y0/m)/length(ilist);
    
    %Perform hmin transform with 'hmin'
    %Cmin=mat2gray(1-imhmin(C,hmin));
    Cmin=mat2gray(imhmin(1-C,hmin));
end

%clean up image
mask0=bwareaopen(~(Cmin==1),sz^2);

%construct new Cmin
Cmin=Cmin.*mask0+~mask0;

%Watershed the hmin-transformed image by iterating until the minimum region
%size is area_min
for it=0:0.01:1
    Cwater=watershed(imhmin(Cmin,it),8);
    areas=regionprops(Cwater>0,'Area');
    if min([areas.Area])>=min_area
        break
    end
end

%Change dhmin to adjust hmin offset
dhmin=0.01;

hmin_final=it-dhmin;
if hmin_final<0
    hmin_final=0;
end

Cwater=watershed(imhmin(Cmin,hmin_final),8);
nspots=max(Cwater(:));

%{
figure;
subplot(2,2,1)
imagesc(C0)
axis equal
axis tight
colormap(gray)
xlabel('X')
ylabel('Y')
title('Original Image')

subplot(2,2,2)
imagesc(C)
axis equal
axis tight
colormap(gray)
xlabel('X')
ylabel('Y')
title('Pre-Processed Image')

subplot(2,2,3)
imagesc(1-Cmin)
axis equal
axis tight
colormap(gray)
xlabel('X')
ylabel('Y')
title('Hmin Transformed')

subplot(2,2,4)
imagesc(C0.*(1-(Cwater==0))+(Cwater==0))
axis equal
axis tight
colormap(gray)
xlabel('X')
ylabel('Y')
title(['Segmented image : ' num2str(nspots) ' spots'])
drawnow
%}

mask1=zeros(size(C0));

h3=waitbar(0,'Finding region specific thresholds ... ');
for i=1:nspots
        %find spectrum of intensities in region
        curreg=Cwater==i;  %get current region mask
        ctemp=regionprops(Cwater==i,'BoundingBox','Centroid');
        inds=[ctemp.BoundingBox];
        y_inds=ceil(inds(2)):floor(inds(2)+inds(4));
        x_inds=ceil(inds(1)):floor(inds(1)+inds(3));
        %Itemp=curreg(y_inds,x_inds).*C0(y_inds,x_inds); %original image
        Itemp=curreg(y_inds,x_inds).*C(y_inds,x_inds); %relnoise image
        Int_list=C0(Cwater==i); %list of intensity values in region
        
        %record watershed region centers
        region(i).reg_centX=ctemp.Centroid(1);
        region(i).reg_centY=ctemp.Centroid(2);
        
        %generate list of evenly spaced intensity values
        dI=linspace(min(Int_list),max(Int_list),res);       
        
        for k=res:-1:1
            %for current threshold, find the area of the largest
            %contiguous block in this sub-region
            Ltemp=bwlabel(Itemp>=dI(k));
            stemp=regionprops(Ltemp,'Area');
            areas=[stemp.Area];
            
            if and(max(areas)>=minsz,max(areas)<=maxsz)
                region(i).thresh=dI(k);
                
                %label(s) of maximum size regions
                maxind=find(areas==max(areas));
                         
                %pick the region with the most integrated intensity
                int_mag=0;
                for m=1:length(maxind)
                    %current integrated weight of sub-sub-region
                    curr_mag=sum(sum(Itemp.*(Ltemp==maxind(m))));
                    if int_mag<=curr_mag
                        use_ind=maxind(m);
                    end
                end
                
                %get coordinates and intensities of current region
                new_mask=imfill(imdilate(Ltemp==use_ind,strel1),'holes');
                [region(i).Ycoords,region(i).Xcoords]=find(new_mask==1);
                
                %shift coordinages
                region(i).Ycoords=region(i).Ycoords+y_inds(1)-1;
                region(i).Xcoords=region(i).Xcoords+x_inds(1)-1;
                
                %get intensities
                region(i).Ints=Itemp(new_mask==1);
                
                %calculate centroids
                region(i).Xcent=sum(region(i).Ints.*region(i).Xcoords)/sum(region(i).Ints);
                region(i).Ycent=sum(region(i).Ints.*region(i).Ycoords)/sum(region(i).Ints);
                
                %color output image mask
                for j=1:length(region(i).Xcoords)
                    mask1(region(i).Ycoords(j),region(i).Xcoords(j))=1;
                end
                
                %determine if region is on border
                edge1=[region(i).Xcoords]==1;
                edge2=[region(i).Xcoords]==sx;
                edge3=[region(i).Ycoords]==1;
                edge4=[region(i).Ycoords]==sy;
                
                if sum(edge1+edge2+edge3+edge4)>0
                    region(i).on_border=1;
                else
                    region(i).on_border=0;    
                end
                
                region(i).size_pass=1;
                
                %exit loop if size conditions are met
                break
            end
        end
    waitbar(i/nspots,h3,['Finding region specific thresholds ... ' num2str(i) '/' num2str(nspots)])
end
close(h3)

%perform closeness analysis
mask2=double(Cwater).*mask1;
strel2=strel('disk',sz,0);
for i=1:nspots
    mask3=imdilate(mask2==i,strel2).*mask2;
    region(i).close_regs=setdiff(unique(mask3(:)),[0,i]);
end

%PLOT
if ~isempty(varargin)
    if strcmp(varargin{1},'plot')
        bck_im=C0.*~mask1;
        T(:,:,1)=bck_im+mask1.*C;
        T(:,:,2)=bck_im;
        T(:,:,3)=bck_im;
        
        f1=figure;
        hold on
        imagesc(T)
        [lx,ly]=voronoi([region.Xcent],[region.Ycent]);
        plot(lx,ly,'b-')
        plot([region.Xcent],[region.Ycent],'wx')
        for i=1:nspots
            text(region(i).reg_centX,region(i).reg_centY,num2str(i),'color',[0 1 1])
        end
        axis equal
        axis tight
        colormap(gray)
        xlabel('X')
        ylabel('Y')
        title(['Regions: ' num2str(nspots) ', hmin = ' num2str(hmin) ', Spot Min Area = ' num2str(minsz)]);
        xlim([1/2,size(C0,1)+1/2])
        ylim([1/2,size(C0,2)+1/2])
        
        if exist('spot_data','var')
            plot(spot_data.Xcent,spot_data.Ycent,'go')
        end
    end
end
    
    
    
