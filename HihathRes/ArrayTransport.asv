% nanoparticle array transport modelling system

%% constants
Arrwidth=30E-6; %meters
Arrlength=10E-6; %meters
d= 10.1E-9; %NP diameters
r=d/2; %NP radius
s=2.3E-9; %interparticle spacing (tunneling barrier length)
dcc=d+s; %center to center distance of particles
Njunlin=Arrlength/dcc;%Assuming Linearly closepacked in series
Njunhex=Arrlength*(2/sqrt(3))/dcc; %hexagonally close packed
Npar=Arrwidth/dcc; %parallel
%Sizedist=1E-9; %dispersion in NP size

kbev= 8.6173E-5;%boltzmann constant (ev)
kbj=1.3806E-23; %J/K
eps0=8.8542E-12;%vacuum permittivity F/m or C^2*N^-1*m^-2
epsr= 2.5; %relative deilectric permittivity
N=6; %nearest neighbors in 2D monolayer
q=1.602E-19; %Coulombs elect charge
T=300; %Temp Kelvin
G0=7.748E-5; %Siemens quantum of conductance from NIST

R_exper=40E6; %Ohms experimental resistance
G_exper=1/R_exper; %experimental conductance Siemens

%% generic tunneling
Beta=6/9.28; %in inverse angstroms
g=G0*exp(-Beta*s*1E10);


%% calculated terms

Csigma=2*N*pi*eps0*epsr*r*log(1+(2*r)/s); %capacitance eq 3 [Respaud, Tan 2014]
C0=4*pi*eps0*epsr*r; %capacitance of an isolated sphere
Cs=4*pi*eps0*epsr*r*(r+s)/s; %capacitance with s included
%check units on these
ECsigma=q^2/(2*Csigma);
EC0=q^2/(2*C0);
ECs=q^2/(2*Cs);
%per tunnel junction conductance


%4.5.4 ZK&D Network
R_0=1; %Ohms, Contact R
locl=d; %localization length wild guess
kapp=1/locl;

Rij=R_0*exp(2*kapp*s)*exp(ECsigma/(kbj*T));


Riji_sigma=zeros(30,1);
Riji_0=zeros(30,1);
Riji_s=zeros(30,1);
slist=zeros(30,1);
for m=1:30
    i=m*1E-10; %meters (repzt angstroms
    slist(m)=i; %meters
    
    Csigma=2*N*pi*eps0*epsr*r*log(1+(2*r)/i); %capacitance eq 3 [Respaud, Tan 2014]
    C0=4*pi*eps0*epsr*r; %capacitance of an isolated sphere
    Cs=4*pi*eps0*epsr*r*(r+i)/i; %capacitance with s included                            
    
    ECsigma=q^2/(2*Csigma);
    EC0=q^2/(2*C0);
    ECs=q^2/(2*Cs);
    
    Riji_sigma(m)=R_0*exp(2*kapp*i)*exp(ECsigma/(kbj*T));
    Riji_0(m)=R_0*exp(2*kapp*i)*exp(EC0/(kbj*T));
    Riji_s(m)=R_0*exp(2*kapp*i)*exp(ECs/(kbj*T));
end




figure
hold on
r1=plot(slist,Riji_sigma);
r2=plot(slist,Riji_0);
r3=plot(slist,Riji_s);
xlabel('interparticle distance, meters', 'FontSize', 12);
ylabel('Resistance of one junction, R_0=1',  'FontSize', 12);
%title('Junction Resistance',  'FontSize', 14); 
set(r1,'Color', 'b', 'LineWidth', 2);
set(r2,'Color', 'r', 'LineWidth', 2);
set(r3,'Color', 'g', 'LineWidth', 2);
title('Resistances for three charging energy models');
legend('C_s_i_g_m_a N neighbors', 'C_0 isolated', 'C_s interparticle');

%% hopping and temperature dependence
%Arrhenius: x=1; Efros Schkovskii: x=1/2; Zabet-Dhirani x=2/3; bulk hopping x=1/4; 
T0=200; %Kelvin
R_0=1E6; %1 MegaOhm
T=[80:1:400];
ResArr=zeros(320,1);
ResZD=zeros(320,1);
ResES=zeros(320,1);
Res14=zeros(320,1);
for t=80:400
    i=t-79;
    ResArr(i)=R_0*exp((T0/t)^(1));
    ResZD(i)=R_0*exp((T0/t)^(2/3));
    ResES(i)=R_0*exp((T0/t)^(1/2));
    Res14(i)=R_0*exp((T0/t)^(1/4));
end

figure
hold on
h1=semilogy(T,ResArr);
h2=semilogy(T,ResZD);
h3=semilogy(T,ResES);
h4=semilogy(T,Res14);
xlabel('Temperature [K]', 'FontSize', 12);
ylabel('Resistance, R_0=1E6',  'FontSize', 12);
set(h1,'Color', 'b', 'LineWidth', 2);
set(h2,'Color', 'r', 'LineWidth', 2);
set(h3,'Color', 'g', 'LineWidth', 2);
set(h4,'Color', 'y', 'LineWidth', 2);
title('Resistace vs Temperature for four critical exponents');
legend('v=1 Arrhenius','v=2/3 Zabet Dhirani','v=1/2 ESVRH','v=1/4 bulk exp');

%% particle size effects

d2=[14:0.1:22]; %nm
T=300; %K
R_0=1; %Ohms, Contact R
Riji_0diam=zeros(size(d2));
iji_sdiam=zeros(size(d2));

EnergyL1=zeros(size(d2));
EnergyL2=zeros(size(d2));

for j=1:length(d2)
    locl=13E-9; %localization length wild guess, nm
    kapp=1/locl;
    sep=2.2E-9; %nm
    
    r=d2(j)/2;
    C0=4*pi*eps0*epsr*r; %capacitance of an isolated sphere
    Cs=4*pi*eps0*epsr*r*(r+sep)/sep; %capacitance with s included  
    EnergyL1(j)=C0;
    EnergyL2(j)=Cs;
    
    EC0=q^2/(2*C0);
    ECs=q^2/(2*Cs);
    Riji_0diam(j)=R_0*exp(2*kapp*sep)*exp(EC0/(kbj*T));
    Riji_sdiam(j)=R_0*exp(2*kapp*sep)*exp(ECs/(kbj*T));
end

figure
hold on
d4=plot(d2,Riji_0diam);
d5=plot(d2,Riji_sdiam);
xlabel('diameter, nm', 'FontSize', 12);
ylabel('Resistance of one junction, R_0=1',  'FontSize', 12);
%title('Junction Resistance',  'FontSize', 14); 
set(d4,'Color', 'r', 'LineWidth', 2);
set(d5,'Color', 'g', 'LineWidth', 2);
title('Resistances vs particle diameter');
legend('C_0 isolated', 'C_s interparticle');


figure
hold on
d6=plot(d2,EnergyL1);
d7=plot(d2,EnergyL2);
xlabel('diameter, nm', 'FontSize', 12);
ylabel('Charging Energy',  'FontSize', 12);
%title('Junction Resistance',  'FontSize', 14); 
set(d4,'Color', 'r', 'LineWidth', 2);
set(d5,'Color', 'g', 'LineWidth', 2);
%title('Resistances vs particle diameter');
legend('C_0 isolated', 'C_s interparticle');

%% NPNP limited vs Domain limited comparsion
%extremes: low: 1E6 Ohm, Hi 1E9 Ohm
R_0=1;
R_0low=1; %for contacts
R_0hi=1; %for contacts 10_10_04
T=300; %Kelvin
locl_low=d; %localization length
locl_hi=d;

s_low=2.3E-9; %interparticle spacing in meters
s_hi=3.1E-9;

kapp_low=1/locl_low; %Kappa from ZK&D 4.5.4
kapp_hi=1/locl_hi;

Cs_low=4*pi*eps0*epsr*r*(r+s_low)/s_low; %capacitance with s included
Cs_hi=4*pi*eps0*epsr*r*(r+s_hi)/s_hi; %capacitance with s included
ECs_low=q^2/(2*Cs_low);
ECs_hi=q^2/(2*Cs_hi);

Rij_low=R_0low*exp(2*kapp_low*s_low)*exp(ECs_low/(kbj*T)); % these values do not change very much for big changes in locl and s
Rij_hi=R_0hi*exp(2*kapp_hi*s_hi)*exp(ECs_hi/(kbj*T)); % these values do not change very much for big changes in locl and s


g_low=G0*exp(-Beta*s_low*1E10);
g_hi=G0*exp(-Beta*s_hi*1E10);

%% Heath's papers have 

%% Dimensionality from Jaeger multiple cotunneling
%T_cross=Tm*(Tes/Tm)^((D+1)/(D-1)); %D is dimensionality, multilay 2D, films 3d

NumLayers=1;
A1=155.25;
y0=-5.9E-4;
t1=0.3425;
x=[1 2 3 4];
y=A1*exp(-x/t1)+y0;
semilogy(x,y)


%% Factorial paths bit
Len=[660:2:770];
Wid=3*Len;
top=factorial(round((Len+Wid)/18));
bott=factorial(round(Len/18)).*factorial(round(Wid/18));
Mpath=top./bott;
LogM=log10(Mpath);



