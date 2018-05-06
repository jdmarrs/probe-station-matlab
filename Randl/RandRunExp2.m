tic
d = 1
LM = [1.53408,1.62173,2.01895,2.08322,2.45774];
LS = [.54829,.38156,.62199,.47574,.46362];
MolLen = [1.5309, 1.7818, 2.0291, 2.2834,2.5457];
Sme = zeros(5,5);
Hme = zeros(5,5);
SmeB = zeros(5,5);
HmeB = zeros(5,5);
d = d + 1
for i = 1:5   
    for j = 1:5
        [na,Sme(i,j),Hme(i,j),~] = RandlLoop(14,298,LM(j),LS(j),.017,.1,10000);
        j + d
        [na,SmeB(i,j),HmeB(i,j),~] = RandlBMin(14,298,LM(j),2.3,.75,LS(j),1.47,.98,.017,.1,10000);
        j + d + 1 
    end
    i + 9
end
HNSD = std(Hme./Sme);
HNBSD = std(HmeB./SmeB);
HN = mean(Hme./Sme);
HNB = mean(HmeB./SmeB);
CNB = HNB./HN;
figure
errorbar(MolLen,HN,HNSD,'*-')
hold
errorbar(MolLen,HNB,HNBSD,'*-')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Molecular Length'
ylabel 'Normalized Successful Hops'
str1 = 'C12S';
str2 = 'C14S';
str3 = 'C16S';
str4 = 'C18S';
str5 = 'C20S';
text(MolLen(1),HN(1),str1)
text(MolLen(2),HN(2),str2)
text(MolLen(3),HN(3),str3)
text(MolLen(4),HN(4),str4)
text(MolLen(5),HN(5),str5)
legend('Normalized Transport Without PTCDI','Normalized PTCDI')
figure
errorbar(LM,HN,HNSD,'*-')
hold
errorbar(LM,HNB,HNBSD,'*-')
title 'Normalized Average Successful Hops over 10^4 Trials Averaging over Five Grids for Experimental Data'
xlabel 'Average Seperation'
ylabel 'Normalized Successful Hops'
text(LM(1),HN(1),str1)
text(LM(2),HN(2),str2)
text(LM(3),HN(3),str3)
text(LM(4),HN(4),str4)
text(LM(5),HN(5),str5)
legend('Normalized Transport Without PTCDI','Normalized PTCDI')
toc