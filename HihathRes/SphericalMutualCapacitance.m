%Cap of two spheres

q=1.602E-19; % coulombs
e0= 8.8542E-12; %Farads/meter
epsr=2.7;

s=2.6E-9;
a=12.0E-9/2;
D=(2*a+s)/(2*a); %Dcc/diam


Cmut=4*pi*epsr*e0*a*(1+1/(2*D)+1/(4*D^2)+1/(8*D^3)+3/(32*D^5));
Cshell=4*pi*epsr*e0*a*((a+s)/s);
C0=4*pi*e0*epsr*a;
Ctot=C0+6*Cmut;

Ec0=q^2*6.2415E18/(2*C0)
Ectot=q^2*6.2415E18/(2*Ctot)
Ecshell=q^2*6.2415E18/(2*Cshell)
Ecmut=q^2*6.2415E18/(2*Cmut)



