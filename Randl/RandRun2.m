tic
h1 = 14;
H = h1*3^(1/2); % H is the hieght of the grid  
W = 3*H; % W is the exact width needed to fulfill 3:1 ratio
w = round(W); % w is the width - using one bond length as the counting measure 
b = w + 1; % b is the number of atoms in one of the short rows
c = b + 1; % c is the number of atoms in one of the long rows
na = b + (b + c)*h1; % na is the number of atoms
xm1 = 2*(w + 1) + 1; % xm1 is the maximum x position at the longer rows
xm2 = 2*(w + 1); % xm2 is the maximum x position at the shorter rows
ym = h1*2 + 1; % ym is the maximum y position
ymax = 2*ym - 1;
J = 1:ym;
LM = 1.1:.2:1.9;
LS = .1:.1:.5;
OM = zeros(5,ym);
OS = zeros(5,ym);
d = 1
for i = 1:5
    [naM,sM,hM,PM,LM,HPM] = RandlZ(14,298,LM(i),.2,.017,.1,10000);
    [naS,sS,hS,PS,LS,HPS] = RandlZ(14,298,1.5,LS(i),.017,.1,10000);
    i + 1
    for j = 1:round(ymax/2)
        Om(:,j) = PM(:,2*j - 1);
        Os(:,j) = PS(:,2*j - 1);
        Omh(:,j) = HPM(:,2*j - 1);
        Osh(:,j) = HPS(:,2*j - 1);
    end
    for j = 1:round(ym/2)
        Onm(:,j) = Om(:,2*j - 1);
        Ons(:,j) = Os(:,2*j - 1);
        Onmh(:,j) = Omh(:,2*j - 1);
        Onsh(:,j) = Osh(:,2*j - 1);
    end
    for j = 1:(round(ym/2) - 1)
        Ofm(:,j) = Om(:,2*j);
        Ofs(:,j) = Os(:,2*j);
        Ofmh(:,j) = Omh(:,2*j);
        Ofsh(:,j) = Osh(:,2*j);
    end
    for k = 1:round(xm2/2)
        Onmc(k,:) = Onm(2*k,:);
        Onsc(k,:) = Ons(2*k,:);
        Onmch(k,:) = Onmh(2*k,:);
        Onsch(k,:) = Onsh(2*k,:);
    end
    for k = 1:round(xm1/2)
        Ofmc(k,:) = Ofm(2*k - 1,:);
        Ofsc(k,:) = Ofs(2*k - 1,:);
        Ofmch(k,:) = Ofmh(2*k - 1,:);
        Ofsch(k,:) = Ofsh(2*k - 1,:);
    end
    OnmM = mean(Onmc);
    OnsM = mean(Onsc);
    OfmM = mean(Ofmc);
    OfsM = mean(Ofsc);
    OnmMh = mean(Onmch);
    OnsMh = mean(Onsch);
    OfmMh = mean(Ofmch);
    OfsMh = mean(Ofsch);
    for j = 1:(round(ym/2) - 1)
        Otm(1,2*j - 1) = OnmM(1,j);
        Ots(1,2*j - 1) = OnsM(1,j);
        Otm(1,2*j) = OfmM(1,j);
        Ots(1,2*j) = OfsM(1,j);
        Otmh(1,2*j - 1) = OnmMh(1,j);
        Otsh(1,2*j - 1) = OnsMh(1,j);
        Otmh(1,2*j) = OfmMh(1,j);
        Otsh(1,2*j) = OfsMh(1,j);
    end
    Otm(1,29) = OnmM(1,15);
    Ots(1,29) = OnsM(1,15);
    Otmh(1,29) = OnmMh(1,15);
    Otsh(1,29) = OnsMh(1,15);
    OM(i,:) = Otmh./Otm;
    OS(i,:) = Otsh./Ots;
    i + 2
end
figure
plot(J,OM(1,:))
hold
for i = 1:4
    plot(J,OM(i + 1,:))
end
xlabel 'Position on y, x = 75'
ylabel 'Frequency of Path'
title 'Successful Hops Path for 10^4 Electrons at x = 75 with Varying Average Length'
legend ('Average Length = 1.1','Average Length = 1.3','Average Length = 1.5','Average Length = 1.7','Average Length = 1.9')
figure
plot(J,OS(1,:))
hold
for i = 1:4
    plot(J,OS(i + 1,:))
end
xlabel 'Position on y, x = 75'
ylabel 'Frequency of Path'
title 'Successful Hops Path for 10^4 Electrons at x = 75 with Varying Standard Deviation of Length'
legend ('Standard Deviation = .1','Standard Deviation = .2','Standard Deviation = .3','Standard Deviation = .4','Standard Deviation = .5')
toc