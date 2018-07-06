function G1 = PVB(T,l,Ea,Vx,b)
q = 1.60217657.*10^-19;%Coulombs
h= 6.62606957.*10^-31;%m^2kg/s
G0 = 5.5*10^3;%2*q^2./h;
kb = 8.6173324*10^-5; %eV/K
G1 = G0*exp(-b*l + Vx - Ea/(kb*T));
