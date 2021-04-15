% Hopfield model
% <https://elearning.di.unipi.it/pluginfile.php/46092/mod_resource/content/0/LAB2_2-Assignments.pd>

load('lab2_2_data');
set(groot,'defaultFigureVisible','off');

% distorted images of pattern 0
d_0_1_orig = distort_image(p0,0.05);
d_0_2_orig = distort_image(p0,0.1);
d_0_3_orig = distort_image(p0,0.25);
% distorted images of pattern 1
d_1_1_orig = distort_image(p1,0.05);
d_1_2_orig = distort_image(p1,0.1);
d_1_3_orig = distort_image(p1,0.25);
% distorted images of pattern 2
d_2_1_orig = distort_image(p2,0.05);
d_2_2_orig = distort_image(p2,0.1);
d_2_3_orig = distort_image(p2,0.25);
%imagesc([reshape(d_0_1,32,32) reshape(d_0_2,32,32) reshape(d_0_3,32,32)]);

% (1) storage phase (learning)
W = (p0 * p0') + (p1 * p1') + (p2 * p2');
W = W/3;
I = eye(1024);
W = W - I;

% (2) retrieval phase
% (2.1) initialization
d_0_1 = d_0_1_orig; d_0_1_overlap = []; d_0_1_energy = [];
d_0_2 = d_0_2_orig; d_0_2_overlap = []; d_0_2_energy = [];
d_0_3 = d_0_3_orig; d_0_3_overlap = []; d_0_3_energy = [];

d_1_1 = d_1_1_orig; d_1_1_overlap = []; d_1_1_energy = [];
d_1_2 = d_1_2_orig; d_1_2_overlap = []; d_1_2_energy = [];
d_1_3 = d_1_3_orig; d_1_3_overlap = []; d_1_3_energy = [];

d_2_1 = d_2_1_orig; d_2_1_overlap = []; d_2_1_energy = [];
d_2_2 = d_2_2_orig; d_2_2_overlap = []; d_2_2_energy = [];
d_2_3 = d_2_3_orig; d_2_3_overlap = []; d_2_3_energy = [];

% (2.2) iteration until convergence
n_epochs = 2;
for t=1:n_epochs
    % (2.3) choose i random neuron
    for i=randperm(1024)
        % pattern 0
        d_0_1(i) = sgn(W(i,:) * d_0_1);
        d_0_1_overlap = horzcat(d_0_1_overlap,[overlap(p0, d_0_1) overlap(p1, d_0_1) overlap(p2, d_0_1)]');
        d_0_1_energy(end+1) = energy(W, d_0_1);
        
        d_0_2(i) = sgn(W(i,:) * d_0_2);
        d_0_2_overlap = horzcat(d_0_2_overlap,[overlap(p0, d_0_2) overlap(p1, d_0_2) overlap(p2, d_0_2)]');
        d_0_2_energy(end+1) = energy(W, d_0_2);
        
        d_0_3(i) = sgn(W(i,:) * d_0_3);
        d_0_3_overlap = horzcat(d_0_3_overlap,[overlap(p0, d_0_3) overlap(p1, d_0_3) overlap(p2, d_0_3)]');
        d_0_3_energy(end+1) = energy(W, d_0_3);
        
        % pattern 1
        d_1_1(i) = sgn(W(i,:) * d_1_1);
        d_1_1_overlap = horzcat(d_1_1_overlap,[overlap(p0, d_1_1) overlap(p1, d_1_1) overlap(p2, d_1_1)]');
        d_1_1_energy(end+1) = energy(W, d_1_1);
        
        d_1_2(i) = sgn(W(i,:) * d_1_2);
        d_1_2_overlap = horzcat(d_1_2_overlap,[overlap(p0, d_1_2) overlap(p1, d_1_2) overlap(p2, d_1_2)]');
        d_1_2_energy(end+1) = energy(W, d_1_2);
        
        d_1_3(i) = sgn(W(i,:) * d_1_3);
        d_1_3_overlap = horzcat(d_1_3_overlap,[overlap(p0, d_1_3) overlap(p1, d_1_3) overlap(p2, d_1_3)]');
        d_1_3_energy(end+1) = energy(W, d_1_3);
        
        % pattern 2
        d_2_1(i) = sgn(W(i,:) * d_2_1);
        d_2_1_overlap = horzcat(d_2_1_overlap,[overlap(p0, d_2_1) overlap(p1, d_2_1) overlap(p2, d_2_1)]');
        d_2_1_energy(end+1) = energy(W, d_2_1);
        
        d_2_2(i) = sgn(W(i,:) * d_2_2);
        d_2_2_overlap = horzcat(d_2_2_overlap,[overlap(p0, d_2_2) overlap(p1, d_2_2) overlap(p2, d_2_2)]');
        d_2_2_energy(end+1) = energy(W, d_2_2);
        
        d_2_3(i) = sgn(W(i,:) * d_2_3);
        d_2_3_overlap = horzcat(d_2_3_overlap,[overlap(p0, d_2_3) overlap(p1, d_2_3) overlap(p2, d_2_3)]');
        d_2_3_energy(end+1) = energy(W, d_2_3);
    end
    fprintf("Epoch: %d/%d \n",t,n_epochs);
    %fprintf("Epoch: %d/%d, overlap=%f, energy=%f, humming distance=%d \n",t,n_epochs,d_0_1_overlap(end),d_0_1_energy(end),d_0_1_hd(end));
end

fprintf('Saving figures . . . ');
% plots pattern 0 (d_0_1)
fig = figure;
hold on;
plot((1:size(d_0_1_overlap,2)),d_0_1_overlap(1,:));
plot((1:size(d_0_1_overlap,2)),d_0_1_overlap(2,:));
plot((1:size(d_0_1_overlap,2)),d_0_1_overlap(3,:));
title('Overlaps (pattern 0)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_0_1_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_0_1_energy,2)),d_0_1_energy(1,:));
title('Energy (pattern 0)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_0_1_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_0_1_orig,32,32) reshape(d_0_1,32,32)])
title(sprintf('Pattern 0 reconstructed (hamming distance=%d)',hamming_distance(d_0_1, p0)));
print(fig,'images/distorted_0_1_reconstructed.png','-dpng');

% plots pattern 0 (d_0_2)
fig = figure;
hold on;
plot((1:size(d_0_2_overlap,2)),d_0_2_overlap(1,:));
plot((1:size(d_0_2_overlap,2)),d_0_2_overlap(2,:));
plot((1:size(d_0_2_overlap,2)),d_0_2_overlap(3,:));
title('Overlaps (pattern 0)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_0_2_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_0_2_energy,2)),d_0_2_energy(1,:));
title('Energy (pattern 0)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_0_2_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_0_2_orig,32,32) reshape(d_0_2,32,32)])
title(sprintf('Pattern 0 reconstructed (hamming distance=%d)',hamming_distance(d_0_2, p0)));
print(fig,'images/distorted_0_2_reconstructed.png','-dpng');

% plots pattern 0 (d_0_3)
fig = figure;
hold on;
plot((1:size(d_0_3_overlap,2)),d_0_3_overlap(1,:));
plot((1:size(d_0_3_overlap,2)),d_0_3_overlap(2,:));
plot((1:size(d_0_3_overlap,2)),d_0_3_overlap(3,:));
title('Overlaps (pattern 0)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_0_3_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_0_3_energy,2)),d_0_3_energy(1,:));
title('Energy (pattern 0)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_0_3_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_0_3_orig,32,32) reshape(d_0_3,32,32)])
title(sprintf('Pattern 0 reconstructed (hamming distance=%d)',hamming_distance(d_0_3, p0)));
print(fig,'images/distorted_0_3_reconstructed.png','-dpng');

% plots pattern 1 (d_1_1)
fig = figure;
hold on;
plot((1:size(d_1_1_overlap,2)),d_1_1_overlap(1,:));
plot((1:size(d_1_1_overlap,2)),d_1_1_overlap(2,:));
plot((1:size(d_1_1_overlap,2)),d_1_1_overlap(3,:));
title('Overlaps (pattern 1)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_1_1_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_1_1_energy,2)),d_1_1_energy(1,:));
title('Energy (pattern 1)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_1_1_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_1_1_orig,32,32) reshape(d_1_1,32,32)])
title(sprintf('Pattern 1 reconstructed (hamming distance=%d)',hamming_distance(d_1_1, p1)));
print(fig,'images/distorted_1_1_reconstructed.png','-dpng');

% plots pattern 1 (d_1_2)
fig = figure;
hold on;
plot((1:size(d_1_2_overlap,2)),d_1_2_overlap(1,:));
plot((1:size(d_1_2_overlap,2)),d_1_2_overlap(2,:));
plot((1:size(d_1_2_overlap,2)),d_1_2_overlap(3,:));
title('Overlaps (pattern 1)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_1_2_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_1_2_energy,2)),d_1_2_energy(1,:));
title('Energy (pattern 1)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_1_2_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_1_2_orig,32,32) reshape(d_1_2,32,32)])
title(sprintf('Pattern 1 reconstructed (hamming distance=%d)',hamming_distance(d_1_2, p1)));
print(fig,'images/distorted_1_2_reconstructed.png','-dpng');

% plots pattern 1 (d_1_3)
fig = figure;
hold on;
plot((1:size(d_1_3_overlap,2)),d_1_3_overlap(1,:));
plot((1:size(d_1_3_overlap,2)),d_1_3_overlap(2,:));
plot((1:size(d_1_3_overlap,2)),d_1_3_overlap(3,:));
title('Overlaps (pattern 1)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_1_3_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_1_3_energy,2)),d_1_3_energy(1,:));
title('Energy (pattern 1)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_1_3_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_1_3_orig,32,32) reshape(d_1_3,32,32)])
title(sprintf('Pattern 1 reconstructed (hamming distance=%d)',hamming_distance(d_1_3, p1)));
print(fig,'images/distorted_1_3_reconstructed.png','-dpng');

% plots pattern 2 (d_2_1)
fig = figure;
hold on;
plot((1:size(d_2_1_overlap,2)),d_2_1_overlap(1,:));
plot((1:size(d_2_1_overlap,2)),d_2_1_overlap(2,:));
plot((1:size(d_2_1_overlap,2)),d_2_1_overlap(3,:));
title('Overlaps (pattern 2)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_2_1_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_2_1_energy,2)),d_2_1_energy(1,:));
title('Energy (pattern 2)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_2_1_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_2_1_orig,32,32) reshape(d_2_1,32,32)])
title(sprintf('Pattern 2 reconstructed (hamming distance=%d)',hamming_distance(d_2_1, p2)));
print(fig,'images/distorted_2_1_reconstructed.png','-dpng');

% plots pattern 2 (d_2_2)
fig = figure;
hold on;
plot((1:size(d_2_2_overlap,2)),d_2_2_overlap(1,:));
plot((1:size(d_2_2_overlap,2)),d_2_2_overlap(2,:));
plot((1:size(d_2_2_overlap,2)),d_2_2_overlap(3,:));
title('Overlaps (pattern 2)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_2_2_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_2_2_energy,2)),d_2_2_energy(1,:));
title('Energy (pattern 2)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_2_2_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_2_2_orig,32,32) reshape(d_2_2,32,32)])
title(sprintf('Pattern 2 reconstructed (hamming distance=%d)',hamming_distance(d_2_2, p2)));
print(fig,'images/distorted_2_2_reconstructed.png','-dpng');

% plots pattern 2 (d_2_3)
fig = figure;
hold on;
plot((1:size(d_2_3_overlap,2)),d_2_3_overlap(1,:));
plot((1:size(d_2_3_overlap,2)),d_2_3_overlap(2,:));
plot((1:size(d_2_3_overlap,2)),d_2_3_overlap(3,:));
title('Overlaps (pattern 2)');
xlabel('ticks')
ylabel('overlap function');
legend('overlap with pattern 0','overlap with pattern 1','overlap with pattern 2');
print(fig,'images/distorted_2_3_overlap.png','-dpng');
hold off;
fig = figure;
plot((1:size(d_2_3_energy,2)),d_2_3_energy(1,:));
title('Energy (pattern 2)');
xlabel('ticks')
ylabel('energy');
print(fig,'images/distorted_2_3_energy.png','-dpng');
fig = figure;
imagesc([reshape(d_2_3_orig,32,32) reshape(d_2_3,32,32)])
title(sprintf('Pattern 2 reconstructed (hamming distance=%d)',hamming_distance(d_2_3, p2)));
print(fig,'images/distorted_2_3_reconstructed.png','-dpng');

fprintf('Done!\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = sgn(v)
    if v >= 0
        x = +1;
    else
        x = -1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m = overlap(p, x)
    m = (p' * x) / 1024;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = energy(w, x)
    e = -(1/2) * (x' * w * x);
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