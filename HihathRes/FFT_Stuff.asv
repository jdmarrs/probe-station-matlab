% fft stuff


[filename path]=uigetfile('.tif');
OImg=strcat(path, filename);
imTif = imread(OImg);

imTif2=imcrop(imTif, [1 1 2048 1766]);
imGray=rgb2gray(imTif2);
imdub=im2double(imGray);

fi2=fft2(imdub);
fiz=fftshift(fi2);

imshow(fiz);
