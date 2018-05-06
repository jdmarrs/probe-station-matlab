%charging energy nanoparticle
clear all
q=1.602E-19; % coulombs
e0= 8.8542E-12; %Farads/meter
epsr=2.7;
epsr2=1.2;
j2ev=6.2415E18; %joules to eV
rad=[4:0.1:30]*1E-9; %m
cap=4*pi*epsr*e0*rad; %farads
%caps=4*pi*epsr*e0*rad*((rad+1.8E-9)/1.8E-9);

for i=1:length(rad)
cap(i)=4*pi*epsr*e0*rad(i);    
Ec(i)=(q^2/2)/cap(i); %colombs^2/farad = joules

caps(i)=4*pi*epsr*e0*rad(i)*((rad(i)+1.8E-9)/1.8E-9);
Ecs(i)=(q^2/2)/caps(i);

cap2(i)=4*pi*epsr2*e0*rad(i); 
Ec2(i)=(q^2/2)/cap2(i);
end

Ecev=Ec*6.2415E18; %electron volts eV
Ecsev=Ecs*6.2415E18; %electron volts eV
Ec2ev=Ec2*6.2415E18; %electron volts eV


h1=plot(rad,Ecev);
hold on
h2=plot(rad, Ecsev);
h3=plot(rad, Ec2ev);
xlabel('particle diameter (m)', 'FontSize', 12);
ylabel('Charging energy (eV)',  'FontSize', 12);
%title('y vs x');
set(h1,'Color', 'b', 'LineWidth', 2);
set(h2,'Color', 'r', 'LineWidth', 2);
set(h3,'Color', 'g', 'LineWidth', 2);
%set(h4,'Color', 'y', 'LineWidth', 2);
legend('C_0 isolated', 'C_s interparticle', 'C_3 epsr');


%%
MeasEa=[21.07706; 19.89635; 23.12674; 25.14198]*0.001*0.5; %eV
s=1.8E-9;
Dcc=1E-9*[14.12334; 13.70358; 13.46092; 12.96301];

for i=1:length(rad)
caps(i)=4*pi*epsr*e0*rad(i)*((rad(i)+s)/s);
Ecs(i)=(q^2/2)/caps(i);
end

%% analytical mutual capacitance
% http://www.iue.tuwien.ac.at/phd/wasshuber/node13.html?
dcc=13.5e-9;
a=6e-9;
epsr=2.7;
Canalyt=pi*epsr*e0*sqrt(dcc^2-4*a^2);
infsumc6=0;
for p=0:9999
    infsumc6=infsumc6+(coth((p+0.5)*acosh(dcc/(2*a)))-1);
end
C2sphc6=Canalyt*infsumc6;

dcc=14.2e-9;
a=6e-9;
epsr=2.0;
Canalyt=pi*epsr*e0*sqrt(dcc^2-4*a^2);
infsumc18=0;
for p=0:9999
    infsumc18=infsumc18+(coth((p+0.5)*acosh(dcc/(2*a)))-1);
end
C2sphc18=Canalyt*infsumc18;



%% Gauss law approach to mutual capacitance
q=1.602E-19; % coulombs
dcc=27e-9;
a=12e-9;
epsr=2.7;
Va=q/(4*pi*e0*epsr*a)-q/(4*pi*e0*epsr*dcc);
Vb=-q/(4*pi*e0*epsr*a)+q/(4*pi*e0*epsr*dcc);
Deltav=Va-Vb;
Cgauss=q/Deltav;

Ecgauss=q^2*j2ev/(2*Cgauss);


%% how many nanoparticles coupled using analytical mutual cap?

Eac18=0.01707; %eV
Eac6=0.0086; %eV

Ccoupc18=q^2/(2*Eac18/j2ev);
Ccoupc6=q^2/(2*Eac6/j2ev);
Nc18=Ccoupc18/C2sphc18
Nc6=Ccoupc6/C2sphc6


