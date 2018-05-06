function L = Lgrid(h1,lm,ls)
%% Initial Variables
% h1 is number of hexagon rows there are
H = h1*3^(1/2); % H is the hieght of the grid  
W = 3*H; % W is the exact width needed to fulfill 3:1 ratio
w = round(W); % w is the width - using one bond length as the counting measure 
xm1 = 2*(w + 1) + 1; % xm1 is the maximum x position at the longer rows
xm2 = 2*(w + 1); % xm2 is the maximum x position at the shorter rows
ym = h1*2 + 1; % ym is the maximum y position
ymax = 2*ym - 1;
L = zeros(xm1,ymax);
for i = 1:xm2
    for j = 2:2:ymax
        while (L(i,j) <= 0)
        L(i,j) = normrnd(lm,ls);
        end
    end
end

for i = 3:2:xm2
    for j = 1:4:ymax
        while (L(i,j) <= 0)
        L(i,j) = normrnd(lm,ls);
        end
    end
end

for i = 2:2:xm1
    for j = 3:4:ymax
        while (L(i,j) <= 0)
        L(i,j) = normrnd(lm,ls);
        end
    end
end     