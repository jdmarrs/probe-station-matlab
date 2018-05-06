%mu=e*dcc^2*Ea*exp(-B*l-Ea/k*T)/(3*h*k*T)

dcc=1.3E-8; %m
q=1.602E-19; %Coulombs elect charge
kT=4.11E-21; % Joules at RT
j2ev=6.2415E18;
Ea=0.02; %eV
W=30E-6; %m
L=10E-6; %m
t=dcc;
n=4000E12; %m^-2
%tau_0=2E4; %s^-1
% guyot sionnest mobility
tau_0=[1E-6:1E-6:1E-3]';


for i=1:length(tau_0)
mu(i)=10^4*q*dcc^2/(4*tau_0(i)*kT);
G(i)=(W*t/L)*n*10^-4*mu(i)*exp(-2*Ea/(kT*j2ev));
end

%% MOBILITY VS TAU
loglog(tau_0, G, 'linewidth', 2);
xlabel('\tau_0 (s)');
ylabel('G (S)');
title('G vs \tau_0 for n=4000\mum^-^2');

figure
loglog(tau_0, mu, 'linewidth', 2);
xlabel('\tau_0 (s)');
ylabel('\mu (cm^2/Vs)');
title('\mu vs \tau_0 for D_C_C=13nm');

%%
nn=[4000:10:7000]';
tauhopinv_xp=10;

munn=q*dcc^2*tauhopinv_xp/(4*kT);

for j=1:length(nn)    
    Gnn(j)=(W*t/L)*nn(j)*1E12*munn*exp(-2*Ea/(kT*j2ev));    
end

figure
plot(nn, Gnn, 'linewidth', 2);
xlabel('n particle density \mu^-^2');
ylabel('G [S]');
title('G vs n for \tau_0=5E-3 s');
    
%% multiplying by exp(-Beta*l)
s=1.5E-9; %m, 1.5nm    
Beta=6*1E10/9.28; %in inverse meters
tunn=exp(-Beta*s);

for k=1:length(tau_0)
mu(k)=10^4*q*dcc^2/(4*tau_0(k)*kT);
Gt(k)=(W*t/L)*n*10^-4*mu(k)*exp(-2*Ea/(kT*j2ev))*exp(-Beta*s);
end    

figure
loglog(tau_0, Gt, 'linewidth', 2);
xlabel('\tau_0 (s)');
ylabel('G with tunnelling, s=1.5nm (S)');
title('G vs \tau_0 for n=4000\mum^-^2');    


%% calculating tauhop

C18slope=5.70958E-11;
C6slope=1.22227E-10;
EaC18=0.01706777; %eV
EaC6=0.00886292; %eV
dccC18=14.18401E-9; %m, 100mg C18
dccC6=13.70358E-9; %m, 100mg C6
sc18=2.05e-9; %SEM
sc6=1.71e-9; %SEM
st18=1.85E-9; %TEM
st6=1.45E-9; %TEM

hplanck=4.135667E-15; %ev*s
Balkane=0.8E10; %inverse meters

tauhopinv_c18=C18slope*(L/(W*t))*(4*kT/(q*dccC18^2))*(1/q)*(1/exp(-EaC18/(kT*j2ev)));
tauhopinv_c6=C6slope*(L/(W*t))*(4*kT/(q*dccC6^2))*(1/q)*(1/exp(-EaC6/(kT*j2ev)));

%tau0inv_C18=tauhopinv_c18/(exp(-Beta*sc18)*exp(-EaC18/(kT*j2ev)));
%tau0inv_C6=tauhopinv_c6/(exp(-Beta*st6)*exp(-EaC6/(kT*j2ev)));

Transc18_xp=tauhopinv_c18*(hplanck/(2*EaC18))*(1/(exp(-EaC18/(kT*j2ev))));
Transc6_xp=tauhopinv_c6*(hplanck/(2*EaC6))*(1/(exp(-EaC6/(kT*j2ev))));

numchannelsc18_xp=Transc18_xp/exp(-Balkane*sc18);
numchannelsc6_xp=Transc6_xp/exp(-Balkane*sc6);


%% tau_0 RC from PGS

Balkane=0.8E10; %inverse meters
hplanck=4.135667E-15; %ev*s
Trans=exp(-Balkane*sc18); %one channel
tau0inv_calc=2*EaC18*Trans/hplanck;

%% 
%calculating from G without slope

numatoms=(0.74*(dcc/2)^3)/((174E-12)^3); %3.857E4 num Au atoms in a NP

G_xp=1E-7;
n_est=G_xp/(dcc*q*1E-10); %per m2
mu_est=G_xp/(dcc*q*5000*1E12); %m2/vs

thopinv_est=(G_xp/(6000E12*q))*4*kT/(q*dcc^2);

Trans_est=thopinv_est*(hplanck/(2*EaC6))*(1/(exp(-EaC6/(kT*j2ev))));


%% trying a new n value 
% n = natoms*nnp +nmols*nnp
a=6E-9; % radius m
npsurfarea=4*pi*a^2;
Amolsurf=0.2165E-18; %m^2
nmolpernp=npsurfarea/Amolsurf;  %2.089E3 for r=6nm

ntot=n*numatoms+n*nmolpernp; %assumes one electron per Au atom, and per thiol molecule


%%
H=0.9; %2d Packing Factor



