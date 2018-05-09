function bmap = edgeGradient(im)
%   call gradientMagnitude to compute a soft boundary map
    [mag,theta] = gradientMagnitude(im, 2);
    bmap = nonmax(mag.^0.7,theta);
	
    %use canny edge detector
    %result = edge(rgb2gray(im),'canny');
    %bmap = mag.*result;
end

