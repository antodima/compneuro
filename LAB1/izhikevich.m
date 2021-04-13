function [u, w, du, dw] = izhikevich (a, b, c, d, u, w, I, tau, variant)
% Izhikevich function computing the next values of membrane potential 
% and relaxation variable.
%
% Arguments:
%   a = time scale of the recovery variable
%   b = sensitivity of the recovery variable 
%       to flutuations of the membrane potential
%   c = after-spike reset value of the membrane potential
%   d = after-spike reset value of the recovery variable
%   u = membrane potential at time t-1
%   w = relaxation variable value at time t-1
%   I = input current at time t
%   tau = time interval
%
% Returns:
%   u = the membrane potential
%   w = the relaxation value
%   du = derivative of the membrane potential w.r.t. time
%   dw = derivative of the relaxation variable w.r.t. time

if nargin < 8
    tau = 0.25
end
if nargin < 9
    variant = 0
end

% Izhikevich equations
if variant==0  % baseline equations of almost all neurons
    du = (0.04*u^2 + 5*u + 140 - w + I);
    dw = a*(b*u - w);
    u = u + tau * (0.04*u^2 + 5*u + 140 - w + I);
    w = w + tau * a*(b*u - w);
elseif variant==1  % variant of equations for neurons: (G) and (L)
    du = (0.04*u^2 + 4.1*u + 108 - w + I);
    dw = a*(b*u - w);
    u = u + tau * (0.04*u^2 + 4.1*u + 108 - w + I);
    w = w + tau * a*(b*u - w);
elseif variant==2  % variant of equations for neuron (R)
    du = (0.04*u^2 + 5*u + 140 - w + I);
    dw = a*(b*(u+65));
    u = u + tau * (0.04*u^2 + 5*u + 140 - w + I);
    w = w + tau * a*(b*(u+65));
end

end  %end of function