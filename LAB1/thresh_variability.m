% (O) thresh. variability

a=0.03; b=0.25; c=-60; d=4;
u=-64; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:100;

for t=tspan
    if ((t>10) & (t < 15)) | ((t>80) & (t < 85)) 
        I=1;
    elseif (t>70) & (t < 75)
        I=-6;
    else
        I=0;
    end
    
    [u, w, du, dw] = izhikevich (a, b, c, d, u, w, I, tau);
    
    dus(end+1) = du;
    dws(end+1) = dw;
    
    if u > 30
        us(end+1) = 30;
        u = c;
        w = w + d;
    else
        us(end+1) = u;
    end
    ws(end+1) = w;
    
    %fprintf('t=%.4f, u=%.4f, w=%.4f \n', t, u, w);
end

fig = figure;
plot(tspan,us,[0 10 10 15 15 70 70 75 75 80 80 85 85 max(tspan)],-85+[0 0  5  5  0  0  -5 -5 0  0  5  5  0  0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(O) thresh. variability (membrane potential)');
print(fig,'images/thresh_variability_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(O) thresh. variability (phase portrait)');
print(fig,'images/thresh_variability_phase_portrait.png','-dpng')