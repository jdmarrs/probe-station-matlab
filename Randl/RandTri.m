tic
d = 1
LM = [1.53408,1.62173,2.01895,2.08322,2.45774];
LS = [.54829,.38156,.62199,.47574,.46362];
Sme = zeros(5,5);
Hme = zeros(5,5);
SmeG = zeros(5,5);
HmeG = zeros(5,5);
d = d + 1
for i = 1:5   
    for j = 1:5
        [na,Sme(i,j),Hme(i,j),~] = RandlLoop(14,298,LM(j),LS(j),.017,.1,10000);
        j + d
        [na,SmeG(i,j),HmeG(i,j),~] = RandlGMin(14,298,LM(j),2.3,.75,LS(j),1.47,.017,.1,10000);
        j + d + 1 
        [na,SmeB(i,j),HmeB(i,j),~] = RandlBMin(14,298,LM(j),2.3,.75,LS(j),1.47,.98,.017,.1,10000);
        j + d + 2
    end
    i + 9
end
HN = mean(Hme./Sme);
HNG = mean(HmeG./SmeG);
HNB = mean(HmeB./SmeB);
CNG = HNG./HN;
CNB = HNB./HN;
d = d + 1
[na,P1e,~,HP1e] = RandlZ(14,298,LM(1),LS(1),.017,.1,1);
[na,P10e,L,HP10e] = RandlZ(14,298,LM(1),LS(1),.017,.1,10);
d = d + 1