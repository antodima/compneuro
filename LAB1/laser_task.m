load laser_dataset;

whole_dataset = cell2mat(laser_dataset);
whole_dataset = whole_dataset(1:2000);
input_dataset = whole_dataset(:,1:end-1);
target_dataset = whole_dataset(:,2:end);
% design set
X = input_dataset(:,1:1500);
y = target_dataset(:,1:1500);
% test set
X_test = input_dataset(:,1500:end);
y_test = target_dataset(:,1500:end);

% training set
X_train = X(:,1:1200);
y_train = y(:,1:1200);
% validation set
X_val = X(:,1200:end);
y_val = y(:,1200:end);

%figure;
%plot(X_train, 'b');
%title('training sequence');
%figure;
%plot(X, 'r');
%title('validation sequence');

%%% MODEL SELECTION %%%
excitatory_neurons = [200, 300, 400, 500, 600, 700, 800, 900];
[states,firings] = modified_lsm(X_train);
%plot(firings(:,1),firings(:,2),'.');

% training
W = y_train * pinv(states);
y_pred = W * states;
error = mean(abs(y_pred-y_train));  % mean absolute error

% dE/dWj = dE/dO * dO/dNet * dNet/dw
% dE/dWj = d/dWj * 1/n * sum_n(abs(o-t))
%        = 1/n * sum_n(d/dWj*abs(o-t))
%        = 1/n * sum_n((o / |o|) * d/dWj*(o-t))
%        = 1/n * sum_n((o / |o|) * (d/dWj*o - d/dWj*t))
%        = 1/n * sum_n((o / |o|) * d/dWj*o)
%        = 1/n * sum_n((o / |o|) * states)
%dw = (1/size(y_pred,2)) * (y_pred./abs(y_pred)) * states'
%W = W - dw



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [states,firings] = modified_lsm(input)
% Created by Eugene M. Izhikevich, February 25, 2003
% slightly modified by Claudio Gallicchio, 2021

% Excitatory neurons    Inhibitory neurons
Ne=800;                 Ni=200;
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.02*ones(Ne,1);     0.02+0.08*ri];
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
c=[-65+15*re.^2;        -65*ones(Ni,1)];
d=[8-6*re.^2;           2*ones(Ni,1)];

%scaling of input connections
win_e = 5; win_i = 2;
U=[win_e * ones(Ne,1);   win_i * ones(Ni,1)];
%scaling of recurrent connections
w_e = 0.5; w_i = -1;
S=[w_e*rand(Ne+Ni,Ne),  -w_i*rand(Ne+Ni,Ni)];

v=-65*ones(Ne+Ni,1);    % Initial values of v
u=b.*v;                 % Initial values of u
firings=[];             % spike timings

states = []; %here we construct the matrix of reservoir states

for t=1:size(input,2)            % simulation of 1000 ms
  %we don't need random thalamic input:
  %I=[5*randn(Ne,1);2*randn(Ni,1)]; % thalamic input
  %we use instead the input from the external time series!
  I=input(t) * U;
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
  
  I=I+sum(S(:,fired),2); 
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+a.*(b.*v-u);                 % stability
  
  states = [states (v>=30)];
end
end % end of function