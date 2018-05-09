%% ECE549 HW4
%% Question 3 Graph-cut segmentation
clear all
close all
addpath('./GCmex1.5/')
im = im2double(imread('cat.jpg'));
dim = size(im);
load('cat_poly.mat');
k1 = 1;
k2 = 1;
sigma = 3;
mask = poly2mask(poly(:,1),poly(:,2),dim(1),dim(2));
im_2d = reshape(im,[dim(1)*dim(2),3]);
niter = 0;
maxiter = 2;

while niter < maxiter
    foreground = im_2d(mask(:),:);
    background = im_2d(~mask(:),:);
	
	%create two gaussian mixture models for background and foreground 
    GMM_f = fitgmdist(foreground,5);
    GMM_b = fitgmdist(background,5);
    p_f = pdf(GMM_f,im_2d);
    p_b = pdf(GMM_b,im_2d);
	
	%calculate edge and pairwise potentials
    DataCost(:,:,1) = reshape(-log(p_f./p_b),[dim(1),dim(2)]);
    DataCost(:,:,2) = zeros(dim(1),dim(2));
    SmoothnessCost = [0,1;1,0];
    vC = k1+k2.*exp((-(im(:,:,1) - circshift(im(:,:,1),-1,1)).^2+(im(:,:,2) - circshift(im(:,:,2),-1,1)).^2+(im(:,:,3) - circshift(im(:,:,3),-1,1)).^2)./(2*sigma^2));
    hC = k1+k2.*exp((-(im(:,:,1) - circshift(im(:,:,1),-1,2)).^2+(im(:,:,2) - circshift(im(:,:,2),-1,2)).^2+(im(:,:,3) - circshift(im(:,:,3),-1,2)).^2)./(2*sigma^2));

    %   Performing Graph Cut energy minimization operations on a 2D grid.
    [gch] = GraphCut('open', DataCost, SmoothnessCost, vC, hC);
    [gch, labels] = GraphCut('expand', gch);
    mask = logical(~labels);
    niter = niter +1;
end
result = bsxfun(@times,im,mask);
blue = result(:,:,3);
blue(find(blue==0))=1;
result(:,:,3) = blue;
figure;imshow(result)
figure;imagesc(mat2gray(reshape(p_f,[dim(1),dim(2)]),[-5 5]));colormap(jet);colorbar;
figure;imagesc(mat2gray(reshape(p_b,[dim(1),dim(2)]),[-5 5]));colormap(jet);colorbar;