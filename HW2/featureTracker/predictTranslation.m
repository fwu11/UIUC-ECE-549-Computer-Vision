function [newX, newY] = predictTranslation(startX, startY, Ix, Iy, im0, im1)
    % predicts the translation of each key point
    % fwu11
    row = size(im0,1);
    col = size(im0,2);
    epsilon = 0.0001;
    u = 10000;
    v = 10000;
    
    X = startX;
    Y = startY;
    
    % if the points in the 15 by 15 window is outside the image, stop tracking the window
    if X-7 < 1 || X+7 > col || Y-7 < 1 || Y+7 > row
        newX = -1;
        newY = -1;       
    else
        % 15 by 15 pixel window;
        [Xq,Yq] = meshgrid(-7:7,-7:7);   
        Xq = Xq+X;
        Yq = Yq+Y;
        I_wx = interp2(1:col,1:row,Ix,Xq,Yq);
        I_wy = interp2(1:col,1:row,Iy,Xq,Yq);
        % second moment matrix
        AA = [sum(sum(I_wx.*I_wx)) sum(sum(I_wx.*I_wy));sum(sum(I_wx.*I_wy)) sum(sum(I_wy.*I_wy))];
        Xo = Xq;
        Yo = Yq;
        % refinement
        while u > epsilon && v > epsilon
            if X-7 < 1 || X+7 > col || Y-7 < 1 || Y+7 > row
                newX = -1;
                newY = -1; 
                break;
            end
            % temporal gradient          
            I_t = interp2(1:col,1:row,im1,Xq,Yq) - interp2(1:col,1:row,im0,Xo,Yo);
            
            Ab = -[sum(sum(I_wx.*I_t));sum(sum(I_wy.*I_t))];
            
            % solve for u and v
            update = AA\Ab;
            u = update(1);
            v = update(2);
            X = X + u;
            Y = Y + v;
            [Xq,Yq] = meshgrid(-7:7,-7:7);   
            Xq = Xq+X;
            Yq = Yq+Y;
        end

        newX = X;
        newY = Y;
    end
end

