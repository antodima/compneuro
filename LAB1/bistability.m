% (P) bistability

a=0.1;  b=0.26; c=-60; d=0;
u=-61; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:300;
T1=tspan(end)/8;
T2 = 216;

for t=tspan
    if ((t>T1) & (t < T1+5)) | ((t>T2) & (t < T2+5)) 
        I=1.24;
    else
        I=0.24;
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
plot(tspan,us,[0 T1 T1 (T1+5) (T1+5) T2 T2 (T2+5) (T2+5) max(tspan)],-90+[0 0 10 10 0 0 10 10 0 0]);
xlabel('time')
ylabel('u(t)')
grid on;
title('(P) bistability (membrane potential)');
print(fig,'images/bistability_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(P) bistability (phase portrait)');
print(fig,'images/bistability_phase_portrait.png','-dpng')