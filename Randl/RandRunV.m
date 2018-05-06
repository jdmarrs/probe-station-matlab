tic
d = 1
LM = [15.3408,16.2173,20.1895,20.8322,24.5774];
LS = [5.4829,3.8156,6.2199,4.7574,4.6362];
LX = [15, 16.5, 18.6, 21.3, 22.65];
LG = [3.7, 2.9, 4.3, 3.85,3.63];
SmeL = zeros(3,5);
HmeL = zeros(3,5);
SmeG = zeros(3,5);
HmeG = zeros(3,5);
SmeGG = zeros(3,5);
HmeGG = zeros(3,5);
SmeGL = zeros(3,5);
HmeGL = zeros(3,5);
d = d + 1
for i = 1:3   
    for j = 1:5
toc
tic
        [na,SmeG(i,j),HmeG(i,j),~] = RandlLoop(14,298,LM(j),LS(j),.017,11.6,1);
toc
tic
        1
        
        [na,SmeGG(i,j),HmeGG(i,j),~] = RandlGMPG(14,298,LM(j),2.55,1.7,LS(j),1.01,1.47,.98,.017,10,10000);
        
        2 

        [na,SmeL(i,j),HmeL(i,j),~] = RandlLoopltz(14,298,LX(j),LG(j),.017,10,10000);

        3
       
        [na,SmeGL(i,j),HmeGL(i,j),~] = RandlGMPL(14,298,LX(j),2.55,1.7,LG(j),1.01,1.47,.98,.017,10,1000);
               
        4
    end
    d = d + 1 
end
HNGG = HmeGG./SmeGG;
HNG = HmeG./SmeG;
CNG = mean(HNGG./HNG);
CNGs = std(HNGG./HNG);
HNGL = HmeGL./SmeGL;
HNL = HmeL./SmeL;
CNL = mean(HNGL./HNL);
CNLs = std(HNGL./HNL);
figure
semilogy(LM,CNG,'-o',LX,CNL,'-o')
errorbar(LM,CNG,CNGs,'-o')
hold
errorbar(LX,CNL,CNLs,'-o')
set (gca, 'yscale','log')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Mean Length'
ylabel 'Normalized Successful Hops'
legend('PTCDI Transport Normalized to Alkane Using Normal Distribution for Length','PTCDI Transport Normalized to Alkane Using Lorentz Distribution for Length')
toc