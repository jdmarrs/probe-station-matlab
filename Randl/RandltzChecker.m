lg = .37;
lx = 1.5;
for i = 1:1000
    rl(i) = Ranltz(lx,lg);
    if rl(i) > 3
        rl(i) = 3;
    elseif rl(i) < -3
        rl(i) = -3;
    end
end
hist(rl,1000)