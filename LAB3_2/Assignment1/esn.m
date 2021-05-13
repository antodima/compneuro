% Echo State Network
% <https://elearning.di.unipi.it/mod/resource/view.php?id=10931>
clear variables;
set(groot,'defaultFigureVisible','off');

load('NARMA10timeseries');


% true=perform model selection, false=perform model assessment
isModelSelection = false;


inputs = cell2mat(NARMA10timeseries.input);
targets = cell2mat(NARMA10timeseries.target);
% design set
X_design = inputs(1:5000);
y_design = targets(1:5000);
% training set
X_train = X_design(1:4000);
y_train = y_design(1:4000);
% validation set
X_val = X_design(4001:end);
y_val = y_design(4001:end);
% test set
X_test = inputs(5001:end);
y_test = targets(5001:end);



if isModelSelection
    disp('>> Model selection...');
    Nhs = [10,25,50,100,150,200];
    rhos = [0.7, 0.9, 1, 1.1, 1.2, 2];
    omega_ins = [0.5, 1, 2];
    lambdas = [0.001,0.01,0.1];
    grid = gridSearch(Nhs,rhos,omega_ins,lambdas);
    
    trErrors = [];
    valErrors = [];
    for g=1:size(grid,1)
        params = grid(g,:);
        Nu = 1;                 % number of inputs
        Nh = params(1);         % number of reservoir units
        Ny = 1;                 % number of output units
        rho = params(2);        % desired recurrent weight matrix radius
        omega_in = params(3);   % input scaling parameter
        lambda = params(4);     % ridge regression regularization parameter
        nGuesses = 10;          % number of reservoir guesses
        trainingSteps = size(X_train,2);
        validationSteps = size(X_val,2);
        
        E_trs = [];
        E_vls = [];
        for n=1:nGuesses
            U = 2*rand(Nh,Nu+1) - 1;
            U = omega_in * U;
            W = 2*rand(Nh,Nh) - 1;
            W = rho * ( W / max(abs(eig(W))) );
            state = zeros(Nh,1);
            
            H = [];
            % run the reservoir on the input stream
            for t=1:trainingSteps
                state = tanh(U * [X_train(t);1] + W * state);
                H(:,end+1) = state;
            end
            % discard the washout
            H = H(:,Nh+1:end);
            H = [H;ones(1,size(H,2))]; % add bias
            D = y_train(:,Nh+1:end);
            % train the readout
            V = D*H'*inv(H*H'+lambda*eye(Nh+1)); % solve the linear system (Nh+1 for the bias)
            % compute the output and error (loss) for the training samples
            Y_tr = V * H;
            E_tr = immse(D,Y_tr);
            E_trs(end+1) = E_tr;
            
            Hv = [];
            Dv = y_val;
            state = zeros(Nh,1);
            % run the reservoir on the validation stream
            for t=1:validationSteps
                state = tanh(U * [X_val(t);1] + W * state);
                Hv(:,end+1) = state;
            end
            Hv = [Hv;ones(1,size(Hv,2))]; % add bias
            % compute the output and error (loss) for the validation samples
            Y_vl = V * Hv;
            E_vl = immse(Dv,Y_vl);
            E_vls(end+1) = E_vl;
        end
        tr_err = mean(E_trs);
        vl_err = mean(E_vls);
        trErrors(end+1) = tr_err;
        valErrors(end+1) = vl_err;
        fprintf('#%d/%d: Nu=%d, Nh=%d, Ny=%d, rho=%1.1f, omega_in=%1.1f, lambda=%0.3f, tr.err=%0.5f, val.err=%0.5f \n',g,size(grid,1),Nu,Nh,Ny,rho,omega_in,lambda,tr_err,vl_err);
    end
    [val_err, idx] = min(valErrors);
    tr_err = trErrors(idx);
    p = grid(idx,:);
    fprintf('Best params: Nu=1, Nh=%d, Ny=1, rho=%1.1f, omega_in=%1.1f, lambda=%0.3f, tr.err=%0.5f, val.err=%0.5f \n',[p],tr_err,val_err);
else
    disp('>> Model assessment...');
    %Best params: Nu=1, Nh=200, Ny=1, rho=1.0, omega_in=0.5, lambda=0.100, tr.err=0.00092, val.err=0.00242
    Nu=1; Nh=200; Ny=1; rho=1.0; omega_in=0.5; lambda=0.1;
    designSteps = size(X_design,2);
    trainingSteps = size(X_train,2);
    validationSteps = size(X_val,2);
    testSteps = size(X_test,2);
    
    U = 2*rand(Nh,Nu+1) - 1;
    U = omega_in * U;
    W = 2*rand(Nh,Nh) - 1;
    W = rho * ( W / max(abs(eig(W))) );
    state = zeros(Nh,1);
    
    % retraining on the entire dataset
    H = [];
    % run the reservoir on the input stream
    for t=1:designSteps
        state = tanh(U * [X_design(t);1] + W * state);
        H(:,end+1) = state;
    end
    % discard the washout
    H = H(:,Nh+1:end);
    H = [H;ones(1,size(H,2))]; % add bias
    D = y_design(:,Nh+1:end);
    % train the readout
    V = D*H'*inv(H*H'+lambda*eye(Nh+1)); % solve the linear system (Nh+1 for the bias)
    
    % compute training error
    H_tr = [];
    D_tr = y_train;
    state = zeros(Nh,1);
    % run the reservoir on the validation stream
    for t=1:trainingSteps
        state = tanh(U * [X_train(t);1] + W * state);
        H_tr(:,end+1) = state;
    end
    H_tr = [H_tr;ones(1,size(H_tr,2))]; % add bias
    % compute the output and error (loss) for the validation samples
    Y_tr = V * H_tr;
    tr_err = immse(D_tr,Y_tr);
    
    % compute validation error
    H_vl = [];
    D_vl = y_val;
    state = zeros(Nh,1);
    % run the reservoir on the validation stream
    for t=1:validationSteps
        state = tanh(U * [X_val(t);1] + W * state);
        H_vl(:,end+1) = state;
    end
    H_vl = [H_vl;ones(1,size(H_vl,2))]; % add bias
    % compute the output and error (loss) for the validation samples
    Y_vl = V * H_vl;
    vl_err = immse(D_vl,Y_vl);
    
    % compute test error
    H_ts = [];
    D_ts = y_test;
    state = zeros(Nh,1);
    % run the reservoir on the validation stream
    for t=1:testSteps
        state = tanh(U * [X_test(t);1] + W * state);
        H_ts(:,end+1) = state;
    end
    H_ts = [H_ts;ones(1,size(H_ts,2))]; % add bias
    % compute the output and error (loss) for the validation samples
    Y_ts = V * H_ts;
    ts_err = immse(D_ts,Y_ts);
    
    %tr_err=0.00106, vl_err=0.00111, ts_err=0.00097
    save('Win.mat','U'); save('Wr.mat','W'); save('Wout.mat','V');
    fprintf('tr_err=%0.5f, vl_err=%0.5f, ts_err=%0.5f \n',tr_err,vl_err,ts_err);
    
    fig = figure;
    scatter((1:size(y_train,2)),y_train);
    hold on;
    scatter((1:size(Y_tr,2)),Y_tr);
    xlabel('time')
    ylabel('target');
    title('Training targets and predictions');
    legend('target','prediction','Location','southeast');
    print(fig,'images/esn_training_targets.png','-dpng');
    
    fig = figure;
    scatter((1:size(y_test,2)),y_test);
    hold on;
    scatter((1:size(Y_ts,2)),Y_ts);
    xlabel('time')
    ylabel('target');
    title('Test targets and predictions');
    legend('target','prediction','Location','southeast');
    print(fig,'images/esn_test_targets.png','-dpng');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g = gridSearch(Nhs,rhos,omega_ins,lambdas)
    sets = {Nhs,rhos,omega_ins,lambdas};
    [H,R,O,L] = ndgrid(sets{:});
    g = [H(:) R(:) O(:) L(:)];
end