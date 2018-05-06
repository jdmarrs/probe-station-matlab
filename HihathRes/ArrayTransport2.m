% array tranpsort 2, C6 Case only
clear all
Dcc=1E-9*[14.12334; 13.70358; 13.46092; 12.96301];
NumP=zeros(4,1);
NumP(1:4)=(0.9*4*30E-6*10E-6)/pi;
NumP=NumP./(Dcc.^2);

eps0=8.8542E-12;%vacuum permittivity F/m or C^2*N^-1*m^-2
epsr= 4.8; %relative deilectric permittivity
q=1.602E-19; %Coulombs elect charge
C0=4*pi*eps0*epsr*Dcc./2;
EC0=q^2./(2*C0);

kT=4.11E-21; % Joules at RT
%j2ev=6.2415E18;
CalcEa=EC0*25.6/kT; %in meV now
MeasEa=[21.07706; 19.89635; 23.12674; 25.14198];

sigmaCalc=zeros(size(CalcEa));
sigmaMeas=zeros(size(CalcEa));
%mfp=13E-9; %mean free path meters. Now Dcc
mass=9.109E-31; %kg
mu=q*Dcc*sqrt(3*kT/mass)/(2*kT); %mobility
R0=0.01;

for i=1:length(CalcEa)
sigmaCalc(i)=R0*NumP(i)*exp(-CalcEa(i))*mu(i);
sigmaMeas(i)=R0*NumP(i)*exp(-MeasEa(i))*mu(i);
end

measuredConductivity=[2.94603E-8; ; 1.56939E-7; 1.74217E-7; 2.09311E-7];

%%
figure
hold on 
h1=plot(Dcc, CalcEa);
h2=scatter(Dcc, MeasEa, 'filled');
xlabel('diameter (m)', 'FontSize', 12);
ylabel('E_A (meV)',  'FontSize', 12);
set(h1,'Color', 'r', 'LineWidth', 2);
set(h2, 'LineWidth', 2);
legend('E_A calculated', 'E_A measured');

%%
figure
hold on
h3=plot(Dcc, sigmaCalc);
h4=scatter(Dcc, sigmaMeas, 'filled');
h5=scatter(Dcc, measuredConductivity, 'filled');
xlabel('diameter (m)', 'FontSize', 12);
ylabel('Conductivity (A.U.)',  'FontSize', 12);
set(h3,'Color', 'r', 'LineWidth', 2);
set(h4,'LineWidth', 2);
set(h5,'LineWidth', 2);
legend('E_A calculated', 'E_A measured', 'Measured conductivity');

