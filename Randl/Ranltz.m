function rl = Ranltz(x0,gam)
r = rand;
rl = gam*tan(pi*(r - .5)) + x0;