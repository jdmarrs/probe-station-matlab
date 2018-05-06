%% Initial Variables
% h1 is number of hexagon rows there are
H = h1*3^(1/2); % H is the hieght of the grid  
W = 3*H; % W is the exact width needed to fulfill 3:1 ratio
w = round(W); % w is the width - using one bond length as the counting measure 
b = w + 1; % b is the number of atoms in one of the short rows
c = b + 1; % c is the number of atoms in one of the long rows
na = b + (b + c)*h1; % na is the number of atoms
xm1 = 2*(w + 1) + 1; % xm1 is the maximum x position at the longer rows
xm2 = 2*(w + 1); % xm2 is the maximum x position at the shorter rows
ym = h1*2 + 1; % ym is the maximum y position
ymax = 2*ym - 1;
yf = ymax; % yf is the final y position
L = zeros(xm1,ymax,2);
%% Generating random Length and Probabilities
G = exp(-bP*lP);
for i = 1:xm2
    for j = 2:2:ymax
        L(i,j,1) = Ranltz3(lx,lg);
        if(L(i,j,1) <= 0)
            L(i,j,1) = 0;
        end
        if (L(i,j,1) <= l2 && L(i,j,1) >= lmin)
            L(i,j,2) = G;
        else
            L(i,j,2) = exp(-b1*L(i,j,1));
        end
    end
end

for i = 3:2:xm2
    for j = 1:4:ymax
        L(i,j) = Ranltz3(lx,lg);
        if(L(i,j) <= 0)
            L(i,j) = 0;
        end
        if (L(i,j,1) <= l2 && L(i,j,1) >= lmin)
            L(i,j,2) = G;
        else
            L(i,j,2) = exp(-b1*L(i,j,1));
        end
    end
end

for i = 2:2:xm1
    for j = 3:4:ymax
        L(i,j) = Ranltz3(lx,lg);
        if(L(i,j) <= 0)
            L(i,j) = 0;
         end
        if (L(i,j,1) <= l2 && L(i,j,1) >= lmin)
            L(i,j,2) = G;
        else
            L(i,j,2) = exp(-b1*L(i,j,1));
        end
    end
end     