tic
d = 1
LM = [15.3408,16.2173,20.1895,20.8322,24.5774];
LS = [5.4829,3.8156,6.2199,4.7574,4.6362];
SmeG = zeros(5,5);
HmeG = zeros(5,5);
SmeGG = zeros(5,5);
HmeGG = zeros(5,5);
d = d + 1
for i = 1:5   
    for j = 1:5

        [na,SmeG(i,j),HmeG(i,j),~] = RandlLoop(10,298,LM(j),LS(j),.017,.1,1000);
        
        1
        
        [na,SmeGG(i,j),HmeGG(i,j),~] = RandlGMPG(10,298,LM(j),25.5,17,LS(j),10.1,1.47,.98,.017,.1,1000);
        
        2

    end
    d = d + 1 
end
HNGG = HmeGG./SmeGG;
HNG = HmeG./SmeG;
CNG = mean(HNGG./HNG);
CNGs = std(HNGG./HNG);
figure
plot(LM,CNG,'-o')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Mean Length'
ylabel 'Normalized Successful Hops'
legend('PTCDI Transport Normalized to Alkane Using Normal Distribution for Length','PTCDI Transport Normalized to Alkane Using Lorentz Distribution for Length')
toc