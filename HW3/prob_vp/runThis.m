%% Evaluation script for vanishing point detection and camera calibration

% 
% Jia-Bin Huang
% University of Illinois, Urbana-Champaign
% www.jiabinhuang.com

%%
clear
addpath('lsd-1.5');
addpath('JLinkage');

% A subset of YorkUrban dataset
datasetPath = 'YorkUrbanDB';

% Loading groundtruth camera parameters: [focal, pixelSize, pp]
load(fullfile(datasetPath, 'cameraParameters.mat'));

% Image list
imgDir = dir(fullfile(datasetPath, '*.jpg'));
numImg = length(imgDir);
numImg = 1;

% Initialize error measures
errFocalLength = zeros(numImg, 1);
errImgCenter   = zeros(numImg, 2);
errAngleZenith = zeros(numImg, 1);
errHorizon     = zeros(numImg, 1);

% Process imagess
for i = 1:numImg
    imgName = imgDir(i).name;
    
    % Load image
    imgColor = imread(fullfile(datasetPath, imgName));
    img = rgb2gray(imgColor);
    img = im2double(img);
    
    % Line segment detection
    lines = lsd(img*255);
    
    % Vanishing point detection from line segments
    [VP, lineLabel] = vpDetectionFromLines(lines);
       
    % Camera calibration
    [f, u0, v0, R] = camCalibFromVP(VP);
    
    % === Visualization ===
    visLineSegForVP(imgColor, lines, lineLabel, VP, imgName(1:end-4));
    
    % === Evaluation ===
    % Evaluation - camera calibration
    errFocalLength(i) = f*pixelSize - focal;
    errImgCenter(i,1) = u0 - pp(1);
    errImgCenter(i,2) = v0 - pp(2);
    
    % Evaluation - angular error of zenith
    load(fullfile(datasetPath, [imgName(1:end-4), 'zen.mat']));
    errAngleZenith(i) = angleBetweenZeniths(VP(:,3), zenith, pp);
    
    % Evaluation - accuracy of ground plane
    load(fullfile(datasetPath, [imgName(1:end-4), 'hor.mat']));
    vLine = VP(:,1:2)'\([-1;-1]);
    errHorizon(i) = distanceBetweenLines( cat(1, vLine, 1), horizon, size(img, 2)) / size(img, 1);
end

% Report results
medianFocalLenthError = median(abs(errFocalLength));
medianMeanDistPPError = median(sqrt(sum(errImgCenter.^2, 2)));
medianAngleZenithError= median(errAngleZenith);
medianHorizonError    = median(errHorizon);

disp(['Median focal length error: ', num2str(medianFocalLenthError), ' mm']);
disp(['Median image center error: ', num2str(medianMeanDistPPError), ' pixels']);
disp(['Median zenith angle error: ', num2str(medianAngleZenithError), ' degree']);
disp(['Median horizon line error: ', num2str(medianHorizonError)]);