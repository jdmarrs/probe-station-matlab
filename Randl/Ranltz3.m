function r1 = Ranltz3(x0,gam)
for i = 1:10000
    r = rand;
    rl(i) = gam*tan(pi*(r - .5)) + x0;
end
r1 = mean(rl);