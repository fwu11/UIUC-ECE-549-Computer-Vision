function [newXs, newYs] = predictTranslationAll(startXs, startYs, im0, im1)
    % the prediction of all key points
    % fwu11
    newXs = zeros(length(startXs),1);
    newYs = zeros(length(startXs),1);
    
    % compute the x, y gradient value
    [I_x,I_y] = gradient(im0);
    
    for i= 1:length(startXs)
        [newX, newY] = predictTranslation(startXs(i), startYs(i),I_x,I_y,im0,im1 );            
        newXs(i) = newX;
        newYs(i) = newY;
    end

end

