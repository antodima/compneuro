% (S) inhibition induced spiking

a=-0.02; b=-1; c=-60; d=8;
u=-63.8; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.5; tspan=0:tau:350;

for t=tspan
    if (t < 50) | (t>250)
        I=80;
    else
        I=75;
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
plot(tspan,us,[0 50 50 250 250 max(tspan)],-80+[0 0 -10 -10 0 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(S) inhibition induced spiking (membrane potential)');
print(fig,'images/inhibition_induced_spiking_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(S) inhibition induced spiking (phase portrait)');
print(fig,'images/inhibition_induced_spiking_phase_portrait.png','-dpng')