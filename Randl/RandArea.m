lmean = 1.53408;
sigma = .54829;
x = 0:.1:.8;
s = sqrt(2).*sigma;
Probability = erf(x./s);
lmin = lmean - x;
lmax = lmean + x;
for i = 1:5   
    for j = 1:9
        [na,SmeGP(i,j),HmeGP(i,j),~] = RandlGMin(14,298,lmean,lmax(j),lmin(j),sigma,1.47,.017,.1,10000);
        d = d + 1
        [na,SmeBP(i,j),HmeBP(i,j),~] = RandlBMin(14,298,lmean,lmax(j),lmin(j),sigma,1.47,.98,.017,.1,10000);
        d = d + 1
    end
    d = d + 2
end
HNP = mean(Hme(:,1)./Sme(:,1));
HNPG = mean(HmeGP./SmeGP);
HNPB = mean(HmeBP./SmeBP);
CNPG = HNPG./HNP;
CNPB = HNPB./HNP;