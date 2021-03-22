% (K) resonator

a=0.1; b=0.26; c=-60; d=-1;
u=-62; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:400;
T1=tspan(end)/10;
T2=T1+20;
T3 = 0.7*tspan(end);
T4 = T3+40;

for t=tspan
    if ((t>T1) & (t < T1+4)) | ((t>T2) & (t < T2+4)) | ((t>T3) & (t < T3+4)) | ((t>T4) & (t < T4+4)) 
        I=0.65;
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
plot(tspan,us,[0 T1 T1 (T1+8) (T1+8) T2 T2 (T2+8) (T2+8) T3 T3 (T3+8) (T3+8) T4 T4 (T4+8) (T4+8) max(tspan)],-90+[0 0 10 10 0 0 10 10 0 0 10 10 0 0 10 10 0 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(K) resonator (membrane potential)');
print(fig,'images/resonator_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(K) resonator (phase portrait)');
print(fig,'images/resonator_phase_portrait.png','-dpng')