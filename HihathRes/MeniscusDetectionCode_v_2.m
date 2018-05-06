close all
clear
clc

thold = 0.3;
minsize = 100;
timeinterval = 10;

Video = VideoReader('side.7.10.avi');

Angles = zeros(Video.NumberOfFrames,4);
writerObj = VideoWriter('sidetracker.7.10.avi');
writerObj.FrameRate = 7;
open(writerObj);

% figure('units','normalized','outerposition',[0 0 1 1]);

for m = 1:Video.NumberOfFrames;
    Frame = read(Video,m); %Reads the frame as a picture in rgb
    GrayFrame = rgb2gray(Frame); %Turns the 3D image into a grayscale 2D image
    % Ig = rgb2gray(I);
    Ic = imcomplement(imadjust(GrayFrame));
    bw = im2bw(Ic, thold);
    bw2 = bwareaopen(bw, minsize);

    B = bwboundaries(bw2,8,'noholes');

    imshow(Frame);%Ic);
    set(gcf, 'Position', [40, 20, 1300, 650]);
    hold on
    boundary = B{1};
    % plot(boundary(:,2),boundary(:,1),'.r')

    [maximum,maxlocation] = max(boundary(:,2));

    uppermeniscus = zeros(maxlocation(1),2);
    lowermeniscus = zeros(length(boundary) - maxlocation(1) + 1,2);

    for i = 1:maxlocation(1);
        uppermeniscus(i,1) = boundary(i,1);
        uppermeniscus(i,2) = boundary(i,2);
    end
    for j = maxlocation(1):length(boundary);
        lowermeniscus(j - maxlocation(1) + 1,1) = boundary(j,1);
        lowermeniscus(j - maxlocation(1) + 1,2) = boundary(j,2);
    end
    
    slant1 = polyfit(lowermeniscus(1:30,2),lowermeniscus(1:30,1),1);
    slant2 = polyfit(lowermeniscus((length(lowermeniscus)-30):length(lowermeniscus),2),lowermeniscus((length(lowermeniscus)-30):length(lowermeniscus),1),1);
    topfit = polyfit(uppermeniscus(:,2),uppermeniscus(:,1),4);
    botfit = polyfit(lowermeniscus(:,2),lowermeniscus(:,1),4);
    
    topplot = polyval(topfit,uppermeniscus(:,2));
    botplot = polyval(botfit,1:710);%lowermeniscus(:,2));
    
    plot(uppermeniscus(:,2),uppermeniscus(:,1),'.r',uppermeniscus(:,2),topplot,'-g','LineWidth',1);
    plot(lowermeniscus(:,2),lowermeniscus(:,1),'.b',1:710,botplot,'-g','LineWidth',1);
    
    topequ = poly2sym(topfit);
    botequ = poly2sym(botfit);
    slant1equ = poly2sym(slant1);
    slant2equ = poly2sym(slant2);
    
    topslope = diff(topequ);
    botslope = diff(botequ);
    slant1slope = diff(slant1equ);
    slant2slope = diff(slant2equ);
    
    Slope1 = double(subs(topslope, uppermeniscus(1,2)));
    Slope2 = double(subs(topslope, uppermeniscus(length(uppermeniscus),2)));
    Slope3 = double(subs(botslope, lowermeniscus(1,2)));
    Slope4 = double(subs(botslope, lowermeniscus(length(lowermeniscus),2)));
    Slope5 = double(subs(slant1slope, lowermeniscus(1,2)));
    Slope6 = double(subs(slant2slope, lowermeniscus(length(lowermeniscus),2)));
    Slope7 = double(subs(botslope, 704));
    Slope8 = double(subs(botslope, 3));
    
    TLAngle = atand(1./Slope1);
    TRAngle = -atand(1./Slope2);
    LRAngle = -atand(1./Slope3);
    LLAngle = atand(1./Slope4);
    LRSlantAngle = -atand(1./Slope5);
    LLSlantAngle = atand(1./Slope6);
    LREdgeAngle = -atand(1./Slope7);
    LLEdgeAngle = atand(1./Slope8);
    
    if and((LRSlantAngle - LRAngle) < 2, -2 < (LRSlantAngle - LRAngle));
        RealLRAngle = LRAngle;
    else RealLRAngle = LRSlantAngle;
    end
    
    if and((LLSlantAngle - LLAngle) < 2, -2 < (LLSlantAngle - LLAngle));
        RealLLAngle = LLAngle;
    else RealLLAngle = LLSlantAngle;
    end
    
    if RealLRAngle > LREdgeAngle;
        RightWaterMeniscusAngle = LREdgeAngle;
    else RightWaterMeniscusAngle = RealLRAngle;
    end
    
    if RealLLAngle > LLEdgeAngle;
        LeftWaterMeniscusAngle = LLEdgeAngle;
    else LeftWaterMeniscusAngle = RealLLAngle;
    end
    
    LAngleBetween = TLAngle - RealLLAngle;
    RAngleBetween = TRAngle - RealLRAngle;
    
    Angles(m,1) = RightWaterMeniscusAngle;
    Angles(m,2) = LeftWaterMeniscusAngle;
    Angles(m,3) = LAngleBetween;
    Angles(m,4) = RAngleBetween;

    
    n = m.*timeinterval./3600; %Time that has elapsed in hours

    t = sprintf(['Frame Number = ', num2str(m), '          Time Elapsed = ', num2str(n,4), ' hrs']);
    title(t);
    label = sprintf(['Top Left Men. Slope = ', num2str(Slope1,4), '     Bottom Left Men. Slope = ', num2str(Slope4,4), '     Top Right Men. Slope = ', num2str(Slope2,4), '     Bottom Right Men. Slope = ', num2str(Slope3,4)]);
    label2 = sprintf(['Left Edge Water Men. Angle = ', num2str(Angles(m,2),4),' degrees', '     Left Side Angle Btwn Men. = ', num2str(Angles(m,3),4),' degrees', '     Right Side Angle Btwn Men. = ', num2str(Angles(m,4),4),' degrees', '     Right Edge Water Men. Angle = ', num2str(Angles(m,1),4),' degrees']);
    xlabel({label;label2});
  
    drawnow;
    
    image = getframe(gcf);
    writeVideo(writerObj,image);
    
    stats = regionprops(bw2,'Area','Centroid','Extrema','Perimeter');
 
end

close(writerObj);

Frames = 1:length(Angles);
figure; 
plot(Frames,Angles(:,2),'.b',Frames,Angles(:,1),'.r');
title('Angles Of the Meniscus in Contact w/ the Wall');
xlabel('Frame Number');
ylabel('Angle of Meniscus Edge (Degrees)');
legend('Left Hand Side', 'Right Hand Side');

figure;
plot(Frames,Angles(:,3),'.c',Frames,Angles(:,4),'.k');
title('Angles Between the Two Intersecting Meniscuses');
xlabel('Frame Number');
ylabel('Angle of Meniscus Edge (Degrees)');
legend('Left Hand Side', 'Right Hand Side');