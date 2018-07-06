LM = [15.3408,16.2173,20.1895,20.8322,24.5774];
LS = [5.4829,3.8156,6.2199,4.7574,4.6362];
for j = 1:5
    tic
    [na,SmeGG(j),HmeGG(j),~] = RandlGMPG(14,298,LM(j),25.5,17,LS(j),10.1,1.47,.98,.017,.1,1);
    toc
    tic
    [na,SmeG(j),HmeG(j),~] = RandlLoop(14,298,LM(j),LS(j),.017,.1,1);
    toc
end
