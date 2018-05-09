%% ECE549 HW3
%% fwu11
%% Question 4 Affine Structure from Motion
load('tracked_points.mat');
[m,n] = size(Xs);

% for each image subtract the mean of all features
x_hat = bsxfun(@minus,Xs,mean(Xs,2));
y_hat = bsxfun(@minus,Ys,mean(Ys,2));

% construct D matrix
D = zeros(2*m,n);
D(1:2:end,:) = x_hat;
D(2:2:end,:) = y_hat;

% factorize D
[U,W,V] = svd(D);
U_3 = U(:,1:3);
V_3 = V(:,1:3);
W_3 = W(1:3,1:3);

% motion and shape matrices
A = U_3*sqrt(W_3);
X = sqrt(W_3)*V_3';

% eliminate affine ambiguity
% construct the matrix similar to the system of equations in 8-point algorithm
% the system of equations has 3*m rows
M = zeros(3*m,9);
b = zeros(3*m,1);
for i = 1:m
    a1 = A(2*i-1,:);
    a2 = A(2*i,:);
    M(3*i-2,:) = [a1(1)*a1(1) a1(1)*a1(2) a1(1)*a1(3) a1(2)*a1(1) a1(2)*a1(2) a1(2)*a1(3) a1(3)*a1(1) a1(3)*a1(2) a1(3)*a1(3)];
    M(3*i-1,:) = [a2(1)*a2(1) a2(1)*a2(2) a2(1)*a2(3) a2(2)*a2(1) a2(2)*a2(2) a2(2)*a2(3) a2(3)*a2(1) a2(3)*a2(2) a2(3)*a2(3)];
    M(3*i,:) = [a1(1)*a2(1) a1(1)*a2(2) a1(1)*a2(3) a1(2)*a2(1) a1(2)*a2(2) a1(2)*a2(3) a1(3)*a2(1) a1(3)*a2(2) a1(3)*a2(3)];
    b(3*i-2) = 1;
    b(3*i-1) = 1;
    b(3*i) = 0;
end

% solve L by least squares
L = M\b;
L = reshape(L,[3 3])';

%solve Q by Cholesky decomposition
Q = chol(L);
A = A*Q;
X = Q\X;

% calculate the camera position for each frame
A_i = A(1:2:end,:);
A_j = A(2:2:end,:);
K = cross(A_i,A_j,2);
K = bsxfun(@rdivide,K,sqrt(K(:,1).^2 + K(:,2).^2 + K(:,3).^2));

figure
scatter3(X(1,:),X(2,:),X(3,:),'b.');
title('3D locations of the tracked points')

figure
subplot(1,3,1); plot(1:m,K(:,1)); title('Predicted X dimension path of the cameras');
subplot(1,3,2); plot(1:m,K(:,2)); title('Predicted Y dimension path of the cameras');
subplot(1,3,3);plot(1:m,K(:,3)); title('Predicted Z dimension path of the cameras');