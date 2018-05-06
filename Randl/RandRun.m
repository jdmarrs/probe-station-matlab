tic
[na,s10,h10,P10,L,HP10] = Randl(14,298,1.5,.2,.017,.1,10);
d = 1
[~,s,h,P,HP] = RandlM(14,298,L,.017,.1,10000);
d = 1 + d
figure
bar3(L)
title 'Distribution of Lengths in Grid for 1.5 A with std of .2 A'
zlabel 'Length'
xlabel 'y           -                   + '
ylabel ' x '
figure
bar3(HP10)
title 'Successful Hops Path for 10 Electrons with Varying Length'
zlabel 'Frequency'
xlabel 'y           -                   + '
ylabel ' x '
figure
bar3(HP)
title 'Successful Hops Path for 10^4 Electrons with Varying Length'
zlabel 'Frequency'
xlabel 'y           -                   + '
ylabel ' x '
LM = 1.1:.2:1.9;
LS = .1:.1:.5;
SmeM = zeros(1,5);
HmeM = zeros(1,5);
SmeS = zeros(1,5);
HmeS = zeros(1,5);
d = d + 1
for i = 1:5
    clear L1 L2
    L1 = Lgrid(14,LM(i),.2);
    L2 = Lgrid(14,1.5,LS(i));
    [na,SmeM(i),HmeM(i)] = RandlMLoop(14,298,L1,.017,.1,10000);
    [~,SmeS(i),HmeS(i)] = RandlMLoop(14,298,L2,.017,.1,10000);
    i + 3
end
HNM = HmeM./SmeM;
HNS = HmeS./SmeS;
figure
plot(LM,HNM)
title 'Normalized Average Successful Hops over 10^4 Trials as Mean Length Changes'
xlabel 'Average Length (A)'
ylabel 'Normalized Successful Hops'
figure
plot(LS,HNS)
title 'Normalized Average Successful Hops over 10^4 Trials as Standard Deviation of Length Changes'
xlabel 'Standard Deviation (A)'
ylabel 'Normalized Successful Hops'
toc