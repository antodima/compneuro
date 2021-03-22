% (R) accomodation

a=0.02; b=1; c=-55; d=4;
u=-65; w=-16;
us=[]; ws=[]; dus=[]; dws=[], Is=[]
tau=0.5; tspan=0:tau:400;

for t=tspan
    if (t < 200)
        I=t/25;
    elseif t < 300
        I=0;
    elseif t < 312.5
        I=(t-300)/12.5*4;
    end
    
    [u, w, du, dw] = izhikevich (a, b, c, d, u, w, I, tau, 2);
    
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
    Is(end+1)=I;
    
    %fprintf('t=%.4f, u=%.4f, w=%.4f \n', t, u, w);
end

fig = figure;
plot(tspan,us,tspan,Is*1.5-90);
xlabel('time')
ylabel('u(t)')
grid on;
title('(R) accomodation (membrane potential)');
print(fig,'images/accomodation_membrane_potential.png','-dpng')

fig = figure;
hold on;
quiver(us,ws,dus,dws,'r', 'linewidth', 2);
plot(us,ws,'b');
xlabel('u')
ylabel('w')
axis equal
title('(R) accomodation (phase portrait)');
print(fig,'images/accomodation_phase_portrait.png','-dpng')