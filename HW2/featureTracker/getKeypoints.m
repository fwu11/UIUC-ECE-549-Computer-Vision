function [keyXs, keyYs] = getKeypoints(im, tau)
% this function returns the X,Y coordinates of the selected keypoints
% fwu11

    alpha = 0.05;

    % smooth the image before taking the derivatives
    G1 = fspecial('gaussian',[7 7],2);	% Gaussian filter with size of 7 by 7 and sigma of 2.
    smoothed = imfilter(im,G1,'symmetric','conv');

    % compute the x, y gradient value
    [I_x,I_y] = gradient(smoothed);

    % product of derivatives at every pixel
    I_x2 = I_x.*I_x;
    I_y2 = I_y.*I_y;
    I_xI_y = I_x.*I_y;

    % further gaussian filtering
    gIx2 = imfilter(I_x2,G1,'symmetric','conv');
    gIy2 = imfilter(I_y2,G1,'symmetric','conv');
    gIxIy = imfilter(I_xI_y,G1,'symmetric','conv');

    % cornerness function
    har = gIx2.*gIy2-gIxIy.*gIxIy - alpha*(gIx2+gIy2).*(gIx2+gIy2);

    % threshold for selecting key points
    index = (har>tau);
    [y,x] = find(index==1);
    
    % non-maxima suppression 5*5 window
    for iter=1:length(y)
        temp = zeros(5);
        for dx = -2:2
            for dy = -2:2                            
                if x(iter)+dx <= size(im,2) && x(iter)+dx>=1 && y(iter)+dy <=size(im,1) && y(iter)+dy >= 1                         
                    temp(3+dy,3+dx) = har(y(iter)+dy,x(iter)+dx);
                end
            end
        end
        if har(y(iter),x(iter)) ~= max(max(temp))
            index(y(iter),x(iter))= 0;
        end
    end
    har = har.*index;
      
    [keyYs, keyXs] = find(har~=0);
end

