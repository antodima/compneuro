% Recurrent Neural Network
% <https://elearning.di.unipi.it/mod/resource/view.php?id=10832>

clear variables;
set(groot,'defaultFigureVisible','off');

load('NARMA10timeseries');


% true=perform model selection, false=perform model assessment
isModelSelection = false;


inputs = NARMA10timeseries.input;
targets = NARMA10timeseries.target;
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
    % hyperparameters
    hiddenSizes = 10:10:50;
    epochs = 50:20:100;
    learningRates = [0.001,0.01,0.1];
    lambdas = [0.001,0.01,0.1];
    grid = gridSearch(hiddenSizes,epochs,learningRates,lambdas);
    infos = [];
    infoFieldnames = [];
    valErrors = [];

    for g=1:size(grid,1)
        params = grid(g,:);
        hiddenSize = params(1);
        epochs = params(2);
        lr = params(3);
        lambda = params(4);
        
        net = layrecnet(1,hiddenSize,'traingdx');
        net.performParam.regularization = lambda;
        net.trainParam.epochs = epochs;
        net.divideFcn = 'dividetrain';
        net.trainParam.lr = lr;
        net.trainParam.showWindow = false;

        [Xs,Xi,Ai,Ts] = preparets(net,X_train,y_train);
        
        [net,info] = train(net,Xs,Ts,'useParallel','yes');
        infoFieldnames = fieldnames(info);
        infoCell = struct2cell(info);
        infos = horzcat(infos,infoCell);
        
        y_pred = net(X_train);
        y_val_pred = net(X_val);
        err = immse(cell2mat(y_train),cell2mat(y_pred));
        val_err = immse(cell2mat(y_val),cell2mat(y_val_pred));
        valErrors(end+1) = val_err;
        
        fprintf('#%d/%d: hiddenSize=%d, epochs=%d, lr=%0.3f, lambda=%0.3f, tr.err=%0.5f, val.err=%0.5f \n',g,size(grid,1),hiddenSize,epochs,lr,lambda,err,val_err);
    end
    [val, idx] = min(valErrors);
    infoCell = infos(:,idx);
    info = cell2struct(infoCell, infoFieldnames);
    fprintf('min.val.err.=%0.5f, idx=%d, params={hiddenSize=%d, epochs=%d, lr=%0.3f, lambda=%0.3f} \n',val,idx,grid(idx,:));
    plotperform(info);
else
    disp('>> Model assessment...');
    % min.val.err.=0.00432, idx=42, params={hiddenSize=20, epochs=90, lr=0.100, lambda=0.001} 
    net = layrecnet(1,20,'traingdx');
    net.performParam.regularization = 0.001;
    net.trainParam.epochs = 90;
    net.divideFcn = 'dividetrain';
    net.trainParam.lr = 0.1;
    net.trainParam.showWindow = false;
    [Xs,Xi,Ai,Ts] = preparets(net,X_design,y_design);
    [net,info] = train(net,Xs,Ts,'useParallel','yes');
    plotperform(info);
    
    tr_pred = net(X_train);
    vl_pred = net(X_val);
    ts_pred = net(X_test);
    
    tr_err = immse( cell2mat(y_train), cell2mat(tr_pred) );
    vl_err = immse( cell2mat(y_val)  , cell2mat(vl_pred) );
    ts_err = immse( cell2mat(y_test) , cell2mat(ts_pred) );
    
    fig = figure;
    scatter((1:size(y_train,2)),cell2mat(y_train));
    hold on;
    scatter((1:size(tr_pred,2)),cell2mat(tr_pred));
    xlabel('time')
    ylabel('target');
    title('Training targets and predictions');
    legend('target','prediction');
    print(fig,'images/rnn_training_targets.png','-dpng');
    
    fig = figure;
    scatter((1:size(y_test,2)),cell2mat(y_test));
    hold on;
    scatter((1:size(ts_pred,2)),cell2mat(ts_pred));
    xlabel('time')
    ylabel('target');
    title('Test targets and predictions');
    legend('target','prediction');
    print(fig,'images/rnn_test_targets.png','-dpng');
    
    view(net);
    
    fprintf('tr_err=%0.5f, vl_err=%0.5f, ts_err=%0.5f \n',tr_err,vl_err,ts_err);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g = gridSearch(hiddenSizes,epochs,learningRates,lambdas)
    sets = {hiddenSizes,epochs,learningRates,lambdas};
    [H,E,LR,L] = ndgrid(sets{:});
    g = [H(:) E(:) LR(:) L(:)];
end