%cooling of a heater on the chip calculation

%Newton's law of cooling
%dQ/dt=h*A*delT; 

%Biot Number
%Bi=h*Lc/k; 

%characteristic length
%Lc=(Vol/A_surface)

%thermal conductivity k, silicon dioxide, 
k=1.1; %w/(m*k)

%heater size
w=120E-6; %m
l=40E-6; %m
tmin=60E-9; %m, min thickness
tmax=3E-6; %m, max thickness

volmin=w*l*tmin; %m^3
volmax=w*l*tmax; %m^3

Amin=2*l*w+2*tmin*w+2*tmin*l; %m^2
Amax=2*l*w+2*tmax*w+2*tmax*l; %m^2

Lcmin=volmin/Amin;
Lcmax=volmax/Amax;

hlow=5; %w/(m^2*K)
hhi=40; %w/(m^2*K)

Bilow=hlow*Lcmin/k; %unitless
Bihi=hhi*Lcmax/k; %unitless
%We are Thermally simple, Biot Number <<1.

delT=10; %K
dqdtlow=hlow*Amin*delT;
dqdthi=hhi*Amax*delT;

CpSi=700; %J/(kg*K) Specific heat
rho=2300; %kg/m^3
mmin=rho*volmin; %mass
mmax=rho*volmax;
Cmin=mmin*CpSi; %heat capacity
Cmax=mmax*CpSi;
taumin=Cmin/(hlow*Amin); %seconds Area is conductive transport
taumax=Cmax/(hlow*Amax); %seconds Area is conductive transport.

Aconvect=l*w;
taumax2=Cmax/(hlow*Aconvect) 
%time constant of newtonian cooling assuming a 3-micron thick, 
%hot heater with only convective losses on-surface at a low rate
% time constant is less than one second.