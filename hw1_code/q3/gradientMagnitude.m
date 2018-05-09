function [mag,theta] = gradientMagnitude(im, sigma)
    row = size(im,1);
    col = size(im,2);
    theta = zeros(row,col);
    % convert the RGB color space to HSV
    % im = rgb2hsv(im);

    % smoothing by Gaussian filter
    H = fspecial('gaussian',[13 13],sigma);
    smoothed = imfilter(im,H,'symmetric');
    
    % compute the x, y gradient value of each R G B channel
    [fx,fy] = gradient(smoothed);
    
    % compute the overall gradient value for each color channel
    norm_3 = sqrt(fx.^2 + fy.^2);

    % compute the overall gradient magnitude (mag)
    mag = sqrt(norm_3(:,:,1).^2 + norm_3(:,:,2).^2 + norm_3(:,:,3).^2);
	% compute the orientation of each pixel (theta)
    angle = atan2(fy,fx);
    
    % based on the fx,fy that corresponds to the largest magnitude gradient for each pixel
    [~, index] = max(norm_3, [], 3);
    for i = 1:3
        theta = theta + angle(:,:,i) .* (index == i);
    end
    theta = theta + pi/2; %pi/2 added for nonmax.m purpose
end

