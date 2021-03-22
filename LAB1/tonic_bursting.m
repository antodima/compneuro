% (C) tonic bursting

a=0.02; b=0.2; c=-50; d=2;
u=-70; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:220;
T1=22;

for t=tspan
    if (t>T1) 
        I=15;
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
plot(tspan,us,[0 T1 T1 max(tspan)],-90+[0 0 10 10]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(C) tonic bursting (membrane potential)');
print(fig,'images/tonic_bursting_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(C) tonic bursting (phase portrait)');
print(fig,'images/tonic_bursting_phase_portrait.png','-dpng')