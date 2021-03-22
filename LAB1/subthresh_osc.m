% (J) subthresh. osc.

a=0.05; b=0.26; c=-60; d=0;
u=-62; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:200;
T1=tspan(end)/10;

for t=tspan
    if (t>T1) & (t < T1+5)
        I=2;
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
plot(tspan,us,[0 T1 T1 (T1+5) (T1+5) max(tspan)],-90+[0 0 10 10 0 0],tspan(220:end),-10+20*(us(220:end)-mean(us)));
xlabel('time')
ylabel('u(t)')
grid on;
title('(J) subthresh. osc. (membrane potential)');
print(fig,'images/subthresh_osc_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(J) subthresh. osc. (phase portrait)');
print(fig,'images/subthresh_osc_phase_portrait.png','-dpng')