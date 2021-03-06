% trial code for monte carlo lattice hopping

%{
prob=0.5; %defines probability of successful hops
count=0; %initialize hopping count
for i=1:10
    value=rand;
    if value>prob
        count=count+1;
    end
end

disp(strcat([num2str(count) ' successful hops of ' num2str(i) ' attempts.']));

%}

dcc=1; 

vx=1;
vy=sqrt(3)/2;
gridpoints=cell(30,12);
for i=1:size(gridpoints,1) %width loop
    for j=1:size(gridpoints,2) %length loop
        gridpoints{i,j} = [i+vx j+vy];
    end
end
