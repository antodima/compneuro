% (Q) DAP

a=1; b=0.2; c=-60; d=-21;
u=-70; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.1; tspan=0:tau:50;
T1=10;

for t=tspan
    if abs(t-T1)<1 
        I=20;
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
plot(tspan,us,[0 T1-1 T1-1 T1+1 T1+1 max(tspan)],-90+[0 0 10 10 0 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(Q) DAP (membrane potential)');
print(fig,'images/dap_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(Q) DAP (phase portrait)');
print(fig,'images/dap_phase_portrait.png','-dpng')