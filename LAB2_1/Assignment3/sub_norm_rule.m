% Assignment 2 - – Subtractive normalization Learning

U = csvread('../lab2_1_data.csv');  % load the dataset
W = -1 + (1+1)*rand(2,1);
Q = U' * U; % correlation matrix of the input
Nu = size(U,1);
n = ones(1, Nu);
n_epochs = 1000;
lr = 10e-8;
delta_norm_thr = 10e-6;
norm_w = norm(W);
Ws = [];    % weights during time
Wn = [];    % weights norms

% Training phase
for t=1:n_epochs
    U = U(:,randperm(size(U,2))); % shuffle the dataset
    
    for t=1:size(U,2)       % loop over the dataset patterns
        u = U(:,t);
        v = W' * u;
        dw = (v * u) - ((v * (n * u) * n') / Nu);    % Subtractive normalization delta
        W = W + lr * dw;                            % Subtractive normalization learning rule 
    end;
    
    Ws = horzcat(Ws,W);
    
    norm_w_new = norm(W);
    delta_norm = norm_w_new - norm_w;
    norm_w = norm_w_new;
    Wn(end+1) = norm_w;
    
    fprintf('Epoch %d/%d, |W|=%5.4f, delta norm=%5.5f, norm thr=%5.5f \n',t,n_epochs,norm_w,delta_norm,delta_norm_thr);
    
    if delta_norm >= delta_norm_thr
        fprintf('Reached threshold! \n');
        break;
    end;
end;

% P1)
[V,D] = eig(Q);
[d,ind] = sort(diag(D));
V = V(:,ind);
eigvec = V(:,1);

fig = figure;
scatter(U(1,:), U(2,:));
hold on;
plotv(eigvec);
set(findall(gca,'Type', 'Line'),'LineWidth',1.75);
plotv(W);
hold off;
legend('Data points','Principal eigenvector','Weight vector');
print(fig,'images/points_eigvect_weights.png','-dpng');

% P2)
fig = figure;
plot((1:size(Ws,2)),Ws(1,:));
xlabel('time')
ylabel('first weights component');
title('Evolution in time of the first component of the weight matrix');
print(fig,'images/first_weights_component.png','-dpng');

fig = figure;
plot((1:size(Ws,2)),Ws(2,:));
xlabel('time')
ylabel('second weights component');
title('Evolution in time of the second component of the weight matrix');
print(fig,'images/second_weights_component.png','-dpng');

fig = figure;
plot((1:size(Wn,2)),Wn(1,:));
xlabel('time')
ylabel('weights norm');
title('Evolution in time of the weights norm');
print(fig,'images/weights_norms.png','-dpng');

save('W.mat','Ws');