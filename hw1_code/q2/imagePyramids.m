%% ECE549 Computer Vision Homework 1
% Fangwen Wu (fwu11)
% Question 2 Image Pyramids
% 1)Display Gaussian and Laplacian pyramid
% 2)Display FFTs of Gaussian and Laplacian pyramid
clear all
close all
A = imread('man.tiff');
G = im2double(A);
H = fspecial('gaussian',[7 7],2);	% Gaussian filter with size of 7 by 7 and sigma of 2.
figure;
ha = tight_subplot(2, 5,[.01 .03],[.1 .01],[.01 .01]);
figure;
hb = tight_subplot(2, 5,[.01 .03],[.1 .01],[.01 .01]);
axes(ha(1));
imshow(G);							% show the first level of gaussian pyramid (literally just the original image)
axes(hb(1));
plotFFT2(G,2,1);					% call the function plotFFT2 to show the FFT of the first level guaasian pyramid
for i = 1:4						
    temp = G;						% temporary variable that stores the gaussian pyramid one level below. 
    G = imfilter(G,H,'symmetric');	% smooth
    G = G(1:2:end,1:2:end);			% and down sample
    axes(ha(i+1));
    imshow(G);						
    axes(hb(i+1));
    plotFFT2(G,2,i+1);
	% Laplacian pyramid of level n = Gaussian pyramid of level n-1 - smoothed upsampled Gaussian pyramid of level n
    L = temp - imfilter(imresize(G,2,'nearest'),H,'symmetric');	 
    axes(ha(i+5));
    imshow(mat2gray(L));			% show the Laplacian pyramid
    axes(hb(i+5));
    plotFFT2(L,1,i);				% show the fft of the laplacian pyramid
end
axes(ha(10)); axis off; 
axes(hb(10)); axis off; 








