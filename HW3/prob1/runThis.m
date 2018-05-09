%% ECE 549 HW3
%% Question 1 Single-View Metrology
clear all
close all
im = im2double(imread('kyoto_street.jpg'));
% vp = getVanishingPoint(im);

%part B: plot the ground horizon line
vp = zeros(3,3);
vp(:,1) = [6.108823637866805e+07;1.316443057883000e+07;8.892325355750243e+03];
vp(:,2) = [3.559211552882541e+06;-1.198143746752539e+07;-7.627371367802704e+03];
vp(:,3) = [4.497095557139781e+07;-6.210719945941182e+08;4.279008043753455e+04];

horizon = cross(vp(:,1),vp(:,2));
figure
imshow(im);
hold on
x = 1:size(im,2);
plot(x, (-horizon(3)- horizon(1).*x)./horizon(2), 'g', 'linewidth',3); 
hold off

% part B,C solve for camera focal length and optical center and rotation matrix 
[f, u0, v0, R] = estimateIntrinsic(vp);

% part D: horizon
im2 = im2double(imread('CIMG6476.jpg'));
%vp_d = getVanishingPoint(im2);
vp_d(:,1) =[-9.489026346852696e+07;8.359596750809178e+07;6.705762033726647e+04];
vp_d(:,2) = [-5.375052633393478e+07;-1.468980398443764e+07;-1.136952691548090e+04];
horizon_d = cross(vp_d(:,1),vp_d(:,2));
figure
imshow(im2);
hold on
x_d = 1:size(im2,2);
plot(x_d, (-horizon_d(3)- horizon_d(1).*x_d)./horizon_d(2), 'g', 'linewidth',3); 