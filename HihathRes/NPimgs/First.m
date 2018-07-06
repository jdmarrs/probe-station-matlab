[filename path]=uigetfile('.tif');
%imshow(imread(strcat(path,filename)))
I=imread(strcat(path,filename));

%{
Icrop=imcrop(I);
%imshow(Icrop);
%%
bkgrd=imopen(Icrop,strel('disk',120));
%figure, imshow(bkgrd);
%%
I2=Icrop-bkgrd;
figure, imshow(I2);
%%
I2=rgb2gray(I2);
I3=imadjust(I2);
figure, imshow(I3);
%%
level=graythresh(I3);
Ibw=im2bw(I3,level);
figure, imshow(Ibw);
%}

