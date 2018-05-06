tic
d = 1
LM = [15.3408,16.2173,20.1895,20.8322,24.5774];
LS = [5.4829,3.8156,6.2199,4.7574,4.6362];
LX = [1.5, 1.65, 1.86, 2.13, 2.265];
LG = [.37, .29, .43, .385,.363];
SmeL = zeros(5,5);
HmeL = zeros(5,5);
SmeG = zeros(5,5);
HmeG = zeros(5,5);
SmeGG = zeros(5,5);
HmeGG = zeros(5,5);
SmeGL = zeros(5,5);
HmeGL = zeros(5,5);
d = d + 1
for i = 1:5   
    for j = 1:5

        [na,SmeG(i,j),HmeG(i,j),~] = RandlLoopP(14,LM(j),LS(j),1.47,10000);
        
        1
        
        [na,SmeGG(i,j),HmeGG(i,j),~] = RandlGMPGP(14,LM(j),2.55,1.7,LS(j),1.01,1.47,.98,10000);
        
        2 

        [na,SmeL(i,j),HmeL(i,j),~] = RandlLoopPltz(14,LX(j),LG(j),1.47,10000);

        3
       
        [na,SmeGL(i,j),HmeGL(i,j),~] = RandlGMPLP(14,LX(j),2.55,1.7,LG(j),1.01,1.47,.98,10000);
               
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
plot(LM,CNG,'-o',LX,CNL,'-o')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Mean Length'
ylabel 'Normalized Successful Hops'
legend('PTCDI Transport Normalized to Alkane Using Normal Distribution for Length','PTCDI Transport Normalized to Alkane Using Lorentz Distribution for Length')
toc