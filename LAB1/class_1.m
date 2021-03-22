% (G) Class 1 exc.

a=0.02; b=-0.1; c=-55; d=6;
u=-60; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:300;
T1=30;

for t=tspan
    if (t>T1) 
        I=(0.075*(t-T1));
    else
        I=0;
    end
    
    [u, w, du, dw] = izhikevich (a, b, c, d, u, w, I, tau, 1);
    
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
plot(tspan,us,[0 T1 max(tspan) max(tspan)],-90+[0 0 20 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(G) Class 1 exc. (membrane potential)');
print(fig,'images/class_1_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(G) Class 1 exc. (phase portrait)');
print(fig,'images/class_1_phase_portrait.png','-dpng')