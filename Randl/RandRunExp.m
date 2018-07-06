tic
d = 1
T = 1:5;
LM = [1.53408,1.62173,2.01895,2.08322,2.45774];
LS = [.54829,.38156,.62199,.47574,.46362];
Sme = zeros(1,5);
Hme = zeros(1,5);
d = d + 1
for i = 1:5
    [na,Sme(i),Hme(i)] = RandlLoop(14,298,LM(i),LS(i),.017,.1,10000);
    i + d
end
HN = Hme./Sme;
figure
plot(T,HN,'*-')
title 'Normalized Average Successful Hops over 10^4 Trials for Experimental Data'
xlabel 'Trial'
ylabel 'Normalized Successful Hops'
str1 = 'C12S';
str2 = 'C14S';
str3 = 'C16S';
str4 = 'C18S';
str5 = 'C20S';
text(T(1),HN(1),str1)
text(T(2),HN(2),str2)
text(T(3),HN(3),str3)
text(T(4),HN(4),str4)
text(T(5),HN(5),str5)
toc