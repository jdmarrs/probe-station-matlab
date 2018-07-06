function [na,s,h,P,HP] = RandlM(h1,T,L,Ea,Vx,Tr)
tic
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
P = zeros(xm1,ymax); % P is the matrix that will record the path
HP = zeros(xm1,ymax);
%% For Loop
for t = 1:Tr % Tr is the number electron trials
    xi = 2*round(1 + w*rand); % xi is the randomized initial x position
    yi = 1; % yi is the initial y position
    s = 0; % s is total hop attempts
    i = xi; % i and j are the position variables for x and y respectively
    j = yi;
    h = 0;
%% Grid Section  
    while (j ~= yf) 
        g = rand; % g is the random number
   % Corner
        if (i == 2 && j == 1)
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2R = NOV(T,L(i + 1,j),Ea,Vx);
            [i1,j1] = Ad3C1PR(i,j,g,G1R,G1L,G2R);
        elseif (j == 1 && i == xm2)
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2L = NOV(T,L(i - 1,j),Ea,Vx);
            [i1,j1] = Ad3C2PR(i,j,g,G1R,G1L,G2L);
    % Bottom side
        elseif j == 1
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2R = NOV(T,L(i + 1,j),Ea,Vx);
            G2L = NOV(T,L(i - 1,j),Ea,Vx);
            [i1,j1] = Ad4BPR(i,j,g,G1R,G1L,G2R,G2L);
    % on the sides of the longer rows
        elseif i == 1
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G2R = NOV(T,L(i + 1,j),Ea,Vx);
            G3R = NV(T,L(i,j - 1),Ea,Vx);
            [i1,j1] = Ad3SCNPR(i,j,g,G1R,G2R,G3R);
        elseif i == xm1
             G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
             G2L = NOV(T,L(i - 1,j),Ea,Vx);
             G3L = NV(T,L(i - 1,j - 1),Ea,Vx);
            [i1,j1] = Ad3SCFPR(i,j,g,G1L,G2L,G3L);
    % on the sides of the shorter rows
        elseif i == 2
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2R = NOV(T,L(i + 1,j),Ea,Vx);
            G3R = NV(T,L(i,j - 1),Ea,Vx);
            G3L = NV(T,L(i - 1,j - 1),Ea,Vx);
            [i1,j1] = Ad5SCNPR(i,j,g,G1R,G1L,G2R,G3R,G3L);
        elseif i == xm2 
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2L = NOV(T,L(i - 1,j),Ea,Vx);
            G3R = NV(T,L(i,j - 1),Ea,Vx);
            G3L = NV(T,L(i - 1,j - 1),Ea,Vx);
            [i1,j1] = Ad5SCFPR(i,j,g,G1R,G1L,G2L,G3R,G3L);
    % Elsewhere on the grid
        else
            G1R = PV(T,L(i,j + 1),Ea,Vx);
            G1L = PV(T,L(i - 1,j + 1),Ea,Vx);
            G2R = NOV(T,L(i + 1,j),Ea,Vx);
            G2L = NOV(T,L(i - 1,j),Ea,Vx);
            G3R = NV(T,L(i,j - 1),Ea,Vx);
            G3L = NV(T,L(i - 1,j - 1),Ea,Vx);
            [i1,j1] = Ad6PR(i,j,g,G1R,G1L,G2R,G2L,G3R,G3L);
        end   
    % increasing increment     
        if (i1 ~= i && j1 ~= j)
            h = h + 1;
            HP(i1,j1) = HP(i1,j1) + 1; 
        end
        i = i1;
        j = j1;
        s = s + 1;
        P(i,j) = P(i,j) + 1;
        
    % failsafe break - to stop program from running too long    
        if s == 1500000000000000000000
            s = 1500000000000000000000;
            break
        end
    end
end
toc