% (N) rebound burst

a=0.03; b=0.25; c=-52; d=0;
u=-64; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.2; tspan=0:tau:200;
T1=20;

for t=tspan
    if (t>T1) & (t < T1+5) 
        I=-15;
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
plot(tspan,us,[0 T1 T1 (T1+5) (T1+5) max(tspan)],-85+[0 0 -5 -5 0 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(N) rebound burst (membrane potential)');
print(fig,'images/rebound_burst_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(N) rebound burst (phase portrait)');
print(fig,'images/rebound_burst_phase_portrait.png','-dpng')