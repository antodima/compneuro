% Hopfield model
% <https://elearning.di.unipi.it/mod/resource/view.php?id=10695>

load('lab2_2_data');
set(groot,'defaultFigureVisible','off');

% distorted images of pattern 0
d_0_1 = distort_image(p0,0.05); d_0_2 = distort_image(p0,0.1); d_0_3 = distort_image(p0,0.25);
% distorted images of pattern 1
d_1_1 = distort_image(p1,0.05); d_1_2 = distort_image(p1,0.1); d_1_3 = distort_image(p1,0.25);
% distorted images of pattern 2
d_2_1 = distort_image(p2,0.05); d_2_2 = distort_image(p2,0.1); d_2_3 = distort_image(p2,0.25);
eps = 1;

%% (1) storage phase (learning)
P = [p0';p1';p2'];
W = 1/1024 * (P' * P);
for i=1:1024
    W(i,i) = 0;
end
I = ones(1024,1)*0.5;  % bias

%% (2) retrieval phase
%% (2.1) initialization
O = [d_0_1';d_0_2';d_0_3';d_1_1';d_1_2';d_1_3';d_2_1';d_2_2';d_2_3'];  % original images
D = O;  % distorted images
L = [[0,0.05];[0,0.10];[0,0.25];[1,0.05];[1,0.10];[1,0.25];[2,0.05];[2,0.10];[2,0.25]];  % patterns info
Ps = [p0';p0';p0';p1';p1';p1';p2';p2';p2'];  % patterns of each distorted images

% for each pattern distortions
for p=1:size(D,1)
    epoch = 1;
    overlaps = [];
    energies = [];
    pattern_num = L(p,1);
    pattern_distortion = L(p,2);
    energy_old = energy(W, I, D(p,:));
    %% (2.2) iteration until convergence
    while 1
        %% (2.3) choose i random neuron
        for i=randperm(1024)
            D(p,i) = sign(W(i,:) * D(p,:)' + I(i));
            overlaps = horzcat(overlaps,[overlap(p0, D(p,:)) overlap(p1, D(p,:)) overlap(p2, D(p,:))]');
            energies(end+1) = energy(W, I, D(p,:));
        end
        % stopping condition
        energy_new = energy(W, I, D(p,:));
        fprintf('Epoch=%d, Pattern=%d, Distorsion=%0.2f, Energy=%f \n',epoch,pattern_num,pattern_distortion,energy_new);
        if abs(energy_new - energy_old) < eps
            break
        end
        energy_old = energy_new;
        epoch = epoch + 1;
    end
    
    %% plottings
    disp('Saving figures . . .');
    fig = figure;
    hold on;
    plot((1:size(overlaps,2)),overlaps(1,:));
    plot((1:size(overlaps,2)),overlaps(2,:));
    plot((1:size(overlaps,2)),overlaps(3,:));
    title(sprintf('Overlaps (pattern=%d, distortion=%0.2f)',pattern_num,pattern_distortion));
    xlabel('ticks');
    ylabel('overlap function');
    legend({'overlap with pattern 0','overlap with pattern 1','overlap with pattern 2'},'Location','southeast');
    print(fig,sprintf('images/distorted_%d_%0.2f_overlap.png',pattern_num,pattern_distortion),'-dpng');
    hold off;
    fig = figure;
    plot((1:size(energies,2)),energies(1,:));
    title(sprintf('Energy (pattern=%d, distortion=%0.2f)',pattern_num,pattern_distortion));
    xlabel('ticks');
    ylabel('energy');
    print(fig,sprintf('images/distorted_%d_%0.2f_energy.png',pattern_num,pattern_distortion),'-dpng');
    fig = figure;
    imagesc([reshape(O(p,:),32,32) reshape(D(p,:),32,32)])
    title(sprintf('Pattern %d reconstructed (distortion=%0.2f, hamming distance=%d)',pattern_num,pattern_distortion,hamming_distance(D(p,:), Ps(p,:))));
    print(fig,sprintf('images/distorted_%d_%0.2f_reconstructed.png',pattern_num,pattern_distortion),'-dpng');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m = overlap(p, x)
    m = (p' * x') / 1024;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = energy(W, I, x)
    e = (-1/2) * (x * W * x') - I'*x';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = hamming_distance(x1, x2)
    d = 0;
    for i=1:1024
        if x1(i) ~= x2(i)
            d = d + 1;
        end
    end
end