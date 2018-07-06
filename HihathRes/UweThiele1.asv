%uwe thiele's evaporation model

Phi0=0.41; %dimensionless concentration,  < 1, fixed at 0.32, 0.41 or 0.499
PhiC=0.63/0.63; %C/Cc Conc_critical=0.63 gelling/jamming value
phi=Phi0;

A=0.71E-20; %Joules. Hamaker Constant. Uwe says A<0?Amorphous Silica to water, L Bergstrom/ A.C.I.S. 70, 125 
Beta= 6.4; %unitless, ether = 1. evaporation rate of toluene
Beta_exp=0.05725; %g/hr, experimental, evaporation rate of toluene
eta0= 0.56; %centipoise, 0.65 centistokes, toluene, viscocity of pure solvent
%centipoise, 1E-2 Pascal*second, or 0.01 g/cm/sec
nu= 1.575; %fixed for noninteracting particles
%eta=eta0*(1-phi)^-nu; %Krieger-Dougherty law
gamma= 28.5; %Dyne/cm surface tension of toluene (eastman.com/Literature_Center/M/M167.pdf)
rho= 0.865; %g/cm3, density

SP=-0.5; %polar spreading coefficient
l0=100E-9 ; %debye length, 100nm , guess for non-electrolyte toluene
d0=20E-9; %20 nm? wild guess. molecular interaction length
SsP=SP*exp(d0/l0)/l0;

%Bigpi= 2*SLW*D0^2/h^3+SP*exp(-(h-d0)/lo)/l0; %disjoining pressure of partially wetting fluid
%SLW=-A/(12*pi*d0^2); %apolar spreadin gcoefficient



Omega0=18*pi*Beta*eta0*gamma/(rho*(6*pi*A^2*SsP)^(1/3)); %7E-8 to 7E-6

%% unit conversions
eta0kgms=5.6E-4; %kg/m*s viscocity
% A joules is kg*m^2/s^2

%{
sources
 https://www.dynesonline.com/visc_table.html
L Bergstrom/ A.C.I.S. 70, 125
eastman.com/Literature_Center/M/M167.pdf
%}

%% Experimental approach

conc=1E12; %NPs per ml, estimate
rad=6E-9; %m NP radius
NPvol=(4/3)*pi*rad^3; %volume one NP
SumNPvol=conc*NPvol*1E6;  %in ml

evap_r=0.05725; %g/hr, experimental, toluene
visc=0.0056; %g/(cm*sec)