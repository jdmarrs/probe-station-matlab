% calculate pathways down through contact region of thresholded array image
% threshold image so that white area corresponds to connected nanoparticles
% dark areas are voids or breaks

[filename path]=uigetfile('.tif');
OImg=strcat(path, filename);
ImTif = imread(OImg);
Img=im2bw(ImTif);
%imshow(Img);

pathcount=0;

for i=1:size(Img,2) %Horizontal raster
    vin=find(Img(:,i));
        if size(vin,1)==size(Img,1)
            pathcount=pathcount+1;
        end
end

pathcount
imgwidth=size(Img,2)
            