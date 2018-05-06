%Thermal Conductivity vs radiation
%units meters
T=300; %Temp Kelvin
Ksin=30; %W/m*K
l=420E-6; %micron resistor length
wr=2E-6; %nm resistor width
wp=20E-6; %20um landing pad width
lwr=l/wr; %length width ratio
t=400E-9; %thickness of cantilivers
sigma=5.67E-8; %W/(m^2*K^4) Stefan Boltzmann constant
Area=t*wp*4; %area of pad facing opposite side

Prad=sigma*T^4*Area; %black body w abs, emiss 100% efficiency

Rcon=l/(wr*t)/Ksin;
Pcon=T/Rcon;

Prad
Pcon

%{
l=1;
for T1=310:50:700;
    T2=300;
    x=100:1000:10000;
    R=2/5.*x./(400*10^(-9)*30);
    Pc=(T1-T2)./R;
    Pr=(2*10^(-5)*400*10^(-9)+2*20*10^(-6)*15*10^(-6))*5.67*10^(-8).*(T1.^4-T2.^4);
    subplot(3,3,l),semilogy(x,P,'x',x,Pr,'*');
    %plot(T,Pr,'x');
    l=l+1;
%     axis([0 100 0 2*1e-4])
en
%}