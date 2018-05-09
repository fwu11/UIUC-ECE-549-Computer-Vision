%% ECE549 HW2 
% fwu11
% Question 1 A feature tracker
%% 1.1 Keypoint selection
close all 
clear all

im0 = imread('./images/hotel.seq0.png');
im0 = im2double(im0);
[Xo,Yo] = getKeypoints(im0,4e-8);

figure;
imshow(im0);
hold on
plot(Xo,Yo,'g.','linewidth',3);
hold off
%% 1.2 Tracking
pause;
% use the provided data
%load('initial_keypoints.mat')
startXs =zeros(length(Xo),51);
startYs = zeros(length(Yo),51);
% index = randsample(length(Xo),20);
% startXs =zeros(20,51);
% startYs = zeros(20,51);
% startXs(:,1)=Xo(index);
% startYs(:,1)=Yo(index);
startXs(:,1)=Xo;
startYs(:,1)=Yo;
image = im0;
store_out = zeros(length(Xo),1);

% calculate the all the keypoints paths
for i = 1:50  
    im1 = im2double(imread(strcat('./images/hotel.seq',num2str(i),'.png')));
    
    [newXs, newYs] = predictTranslationAll(startXs(:,i), startYs(:,i), im0, im1);
    
    startXs(:,i+1) = newXs;
    startYs(:,i+1) = newYs;
    im0 = im1;
    store_out(newXs == -1) = 1;
end

% polt the path for 20 samples
index = randsample(length(Xo),20);
figure;
imshow(image);
hold on
for i = 1:51
    for j = 1:20
        if startXs(index(j),i)~= -1 && startYs(index(j),i)~= -1
            plot(startXs(index(j),i),startYs(index(j),i),'g.','linewidth',3);
        end
    end
end
hold off

% Mark thepoints that have moced out of frame
figure;
imshow(image);
hold on

for k = 1:length(Xo)
    if store_out(k) == 1
        plot(Xo(k),Yo(k),'gx','linewidth',3);
    end
end

hold off


