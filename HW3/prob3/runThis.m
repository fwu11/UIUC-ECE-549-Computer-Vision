%% ECE 549 HW3
%% fwu11
%% Question 3 Epipolar Geometry
clear all
close all
load('prob3.mat');
im1 = im2double(imread('chapel00.png'));
im2 = im2double(imread('chapel01.png'));
threshold = 1;
len = size(matches,1);
iteration = 10000;
count_best = 0;

% x = [u v 1]
% all matched points
X = ones(3,len);
X_prime = ones(3,len);
X(1,:) = c1(matches(:,1))';
X(2,:) = r1(matches(:,1))';
X_prime(1,:) = c2(matches(:,2))';
X_prime(2,:) = r2(matches(:,2))';

std_u = std(X(1,:));
std_v = std(X(2,:));
std_prime_u = std(X_prime(1,:));
std_prime_v = std(X_prime(2,:));

% construct normalization matrix 
T =[1/std_u 0 0;0 1/std_v 0;0 0 1]*[1 0 -mean(X(1,:));0 1 -mean(X(2,:)); 0 0 1];
T_prime =[1/std_prime_u 0 0;0 1/std_prime_v 0;0 0 1]*[1 0 -mean(X_prime(1,:));0 1 -mean(X_prime(2,:)); 0 0 1];

for iter = 1:iteration
    % RANSAC sample 8 points
    index = randsample(len,8)';
    F = eightPointAlgorithm(X,X_prime,T,T_prime,index);

    % epipolar lines in the first image for all 252 matched pointes
    L = F*X_prime;   
    distance = abs(dot(X,L))./sqrt(L(1,:).^2  + L(2,:).^2); 
    % count the inliers
    inlier = abs(distance) < threshold;
    count = sum(inlier);
    if count > count_best
        F_best = F;
        inlier_best = find(abs(distance) < threshold);
        outlier_best = find(abs(distance)>= threshold);
        count_best = count;
    end
end

% plot outliers
u_outlier = X(1,outlier_best);
v_outlier = X(2,outlier_best);
figure,imshow(im1),hold on;
plot(u_outlier,v_outlier,'g.','linewidth',4),hold off;
title('Outliers');

% polt epipolar lines of 7 matching points 
x_match1 = matches(:, 1)';
x_match2 = matches(:, 2)';
samples = inlier_best(randsample(length(inlier_best), 7));
im1_x = c1(x_match1(samples));
im1_y = r1(x_match1(samples));
im2_x = c2(x_match2(samples));
im2_y = r2(x_match2(samples));

figure;imshow(im1); hold on; title('points in im1');
plot(im1_x, im1_y, 'r+', 'linewidth', 2);
for i = 1:7
    epipolar1 = F_best*[im2_x(i);im2_y(i);1];
    x = 1:size(im1,2);
    plot(x, (-epipolar1(3)- epipolar1(1).*x)/epipolar1(2), 'g'); 
end
hold off

figure;imshow(im2); hold on; title('points in im2');
plot(im2_x, im2_y, 'r+', 'linewidth', 2);
for i = 1:7
    epipolar2 = F_best'*[im1_x(i);im1_y(i);1];
    x = 1:size(im2,2);
    plot(x, (-epipolar2(3)- epipolar2(1).*x)/epipolar2(2), 'g'); 
end
hold off

