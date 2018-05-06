function [i,j] = Ad3C1PR(i,j,g,G1R,G1L,G2R)
if g <= G1R
   i = i + 1;
   j = j + 2;
elseif  (G1R < g && g <= (G1R + G1L))
    j = j + 2;
    i = i - 1;
elseif  ((G1R + G1L) < g && g <= (G1R + G1L + G2R))
    j = j;
    i = i + 2;
else
    j = j;
    i = i;
end