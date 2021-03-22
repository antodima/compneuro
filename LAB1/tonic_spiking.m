% (A) tonic spiking

a=0.02; b=0.2; c=-65; d=6;
u=-70; w=b*u;
us=[]; ws=[]; dus=[]; dws=[]
tau=0.25; tspan=0:tau:100;
T1=tspan(end)/10;

for t=tspan
    if (t>T1) 
        I=14;
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
title('(A) tonic spiking (membrane potential)');
print(fig,'images/tonic_spiking_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(A) tonic spiking (phase portrait)');
print(fig,'images/tonic_spiking_phase_portrait.png','-dpng')