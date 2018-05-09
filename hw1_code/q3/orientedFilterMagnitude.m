function [mag,theta] = orientedFilterMagnitude(im)
%   find the magnitude and orientation for each pixel by using the oriented
%   filters
    sigma_1 = 2;
    sigma_2 = 2;
    % convert the RGB color space to HSV
    %im = rgb2hsv(im);
	
	% 8 orientations
    orientation = [0,pi/8,pi/4,3*pi/8,pi/2,5*pi/8,3*pi/4,7*pi/8];
    dx = floor(4.0*2);
    dy = floor(4.0*2);
    [X,Y] = meshgrid(-dx:dx,-dy:dy);
    row = size(im,1);
    col = size(im,2);
    Boundary_score = zeros(row,col,length(orientation));
    
    % derivative of Gaussian with 0 and 90 degree basis
    g_x=exp(-X.^2/(2*sigma_1^2))/(pi*2*sigma_1^2)^0.5;
    g_y=exp(-Y.^2/(2*sigma_2^2))/(pi*2*sigma_2^2)^0.5;
    G_0 = -g_x.*g_y.*(X/sigma_1^2);
    G_90 = -g_x.*g_y.*(Y/sigma_2^2);
    
    R_0 = imfilter(im,G_0,'symmetric');
    R_90 = imfilter(im,G_90,'symmetric');
    
    % Evaluate oriented filter response.
    for i = 1:length(orientation)
        temp = cos(orientation(i))*R_0+sin(orientation(i))*R_90;   
        %take the norm of the R,G,B gradients
        Boundary_score(:,:,i) = sqrt(temp(:,:,1).^2 + temp(:,:,2).^2 + temp(:,:,3).^2);     
    end
    
    %obtain mag and theta by finding the maximum filter responses
    [mag,index] = max(Boundary_score,[],3);
    theta = orientation(index)+pi/2;    % for nonmax.m
end

