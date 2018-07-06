function [bw, threshold]=adaptivethreshold_b(ImageM,window_width,threshold,lth_m, bin_m, mask)
%localized binarization with nonuniform background illumination.
%use adaptivethreshold_d for dark background, adaptivethreshold_b for bright background.

% threshold is the manually setted value for final binarization.
% if the bin_m is set to 'graythresh','g' or 0, the function will use graythresh() to automatically generate a value overriding the threshold. Default is using graythresh.
% if the bin_m is set to 'manual', 'm', or 1
% window_width is the window size for local thresholding, which is used as filter size. The window size should larger than the feature size extracted, otherwise it will have the effect like edge detector.

% lth_m, method used to generate local thresholds, lth_m=0 mean(default); lth_m=1 median.
% mask bool index matrix for pixels, masked pixels will be 0 in final bw. mask will not affect the local threshold. 

if (nargin<3)
    error('nargin must >=3');
elseif (nargin==3)
    lth_m=0;
    bin_m='g';
    mask=[];
elseif (lth_m~=0 && lth_m~=1)
    error('lth_m must be 0 or 1.');
end
if isempty(bin_m), bin_m='m'; end
    
ImageM=mat2gray(ImageM);

switch lth_m
% get the localthreshold: mImageM
    case 0
        mImageM=imfilter(ImageM,fspecial('average',window_width),'replicate');
    case 1
        mImageM=medfilt2(ImageM,[window_width window_width]);
end
foreground=mImageM-ImageM;
if ~isempty(mask)
    foreground(~mask)=0;
end
foreground(foreground<0)=0;

switch bin_m
    case {'graythresh','g',0}
        threshold=graythresh(foreground(foreground>0));
        
end

bw=im2bw(foreground,threshold);

bw=imcomplement(bw);

