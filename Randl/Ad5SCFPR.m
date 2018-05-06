function [i,j] = Ad5SCFPR(i,j,g,G1R,G1L,G2L,G3R,G3L)
if g <= G1R
   i = i + 1;
   j = j + 2;
elseif  (G1R < g && g <= (G1R + G1L))
    j = j + 2;
    i = i - 1;
elseif  ((G1R + G1L) < g && g <= (G1R + G1L + G3R))
    j = j - 2;
    i = i + 1;
elseif  ((G1R + G1L + G3R) < g && g <= (G1R + G1L + G3R + G3L))
    j = j - 2;
    i = i - 1;
elseif  ((G1R + G1L + G3R + G3L) < g && g <= (G1R + G1L + G3R + G3L + G2L))
    j = j;
    i = i - 2;
else
    j = j;
    i = i;
end