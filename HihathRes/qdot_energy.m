% energy level calc for 1-d quantum well

hbar=1.054E-34; %J*s
j2ev=6.2415E18;
m=9.11E-31; %kg
a=[0.1:0.1:200]*1E-10; %this is like diameter
a=a';
n=[1:6]';

for i=1:length(n)
En{i}=hbar^2*j2ev*pi*n(i)^2./(2*m*a.^2); %griffiths p39
semilogy(a, En{i})
hold on
end
xlabel('a, m');
ylabel('En, eV');

%% 3d box: 
 
n2=[3 6 9 11 12 14 17 18 19 21 22 24 26 27]'; %this is (nx^2+n6^2+nz^2) n=1,2,3,4...
ykt=ones(size(a)).*0.026;
for k=1:length(n2)
    En3{k}=hbar^2*j2ev*pi*n2(k)./(2*m*a.^2); %griffiths p39
    semilogy(a, En3{k});
    hold on
end
semilogy(a, ykt)
xlabel('a, m');
ylabel('En, eV');

%%
En3{1}=hbar^2*j2ev*pi*n2(1)./(2*m*a.^2);
figure
for k=2:length(n2)
    En3{k}=hbar^2*j2ev*pi*n2(k)./(2*m*a.^2); %griffiths p39
    Endiff{k-1}=En3{k}-En3{k-1};
    semilogy(a, En3{k});
    hold on
end
semilogy(a, ykt)
xlabel('a, m');
ylabel('En, eV');

