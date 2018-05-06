tic
d = 1
LM = [15.3408,16.2173,20.1895,20.8322,24.5774];
LS = [5.4829,3.8156,6.2199,4.7574,4.6362];
% LX = [15, 16.5, 18.6, 21.3, 22.65];
% LG = [3.7, 2.9, 4.3, 3.85,3.63];
% SmeG = zeros(1,5);
% HmeG = zeros(1,5);
% SmeGG = zeros(1,5);
% HmeGG = zeros(1,5);
d = d + 1
for j = 3:5
 
     [na,SmeGG(1,j),HmeGG(1,j),~] = RandlGMPG(4,298,LM(j),25.5,17,LS(j),10.1,1.47,.98,.017,.1,100);
 
     1
     SmeGG(1,j)
     HmeGG(1,j)
     [na,SmeG(1,j),HmeG(1,j),~] = RandlLoop(4,298,LM(j),LS(j),.017,.1,1);
     2
     SmeG(1,j)
     HmeG(1,j)
end
    d = d + 1 

HNGG = HmeGG./SmeGG;
HNG = HmeG./SmeG;
CNG = mean(HNGG./HNG);
CNGs = std(HNGG./HNG);
figure
semilogy(LM,CNG,'-o')
set (gca, 'yscale','log')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Mean Length'
ylabel 'Normalized Successful Hops'
legend('PTCDI Transport Normalized to Alkane Using Normal Distribution for Length','PTCDI Transport Normalized to Alkane Using Lorentz Distribution for Length')
toc