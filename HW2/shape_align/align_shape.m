function T = align_shape(im1, im2)
% ICP algorithm
% fwu11
    tic
    % compute center of mass
    [im1_y,im1_x] = find(im1==1);
    avg_x1 = mean(im1_x);
    avg_y1 = mean(im1_y);
    std_x1= std(im1_x);
    std_y1 = std(im1_y);
    normalized_x1 = (im1_x-avg_x1)./std_x1;
    normalized_y1 = (im1_y-avg_y1)./std_y1;

    [im2_y,im2_x] = find(im2==1);
    avg_x2 = mean(im2_x);
    avg_y2 = mean(im2_y);
    std_x2 = std(im2_x);
    std_y2 = std(im2_y);

    x1_prime = normalized_x1.*std_x2 + avg_x2;
    y1_prime = normalized_y1.*std_y2 + avg_y2; 
    
    num_pts1 = length(im1_x);
    num_pts2 = length(im2_x);
    difference_x = ones(num_pts1,1);
    difference_y = ones(num_pts1,1);
    max = 1000;
    threshold = 0.0000001;
    
    % set the maximum iteration in case the algorithm does not converge
    for k = 1:max
        % check if the difference between the predicted coordinates and the
        % original coordinates is smaller than the threshold
        if   sum(sqrt(difference_x.^2 + difference_y.^2)) < threshold
            break;
        else
            % assign each point in set 1 to its nearest neighbor in set 2
            record = zeros(1,num_pts1);
            for i = 1:num_pts1
                distance = sqrt((x1_prime(i)-im2_x).^2 +  (y1_prime(i)-im2_y).^2);
                [~,record(i)] = min(distance);
            end

            % use affine transformation, sovled by least squares method
            A =  zeros(2*num_pts1,6);
            b = zeros(2*num_pts1,1);
            for i = 1:num_pts1
                A(2*i-1,:) = [x1_prime(i), y1_prime(i), 1, 0, 0, 0];
                A(2*i,:) = [0, 0, 0, x1_prime(i),y1_prime(i), 1];
                b(2*i-1) = im2_x(record(i));
                b(2*i) = im2_y(record(i));
            end
            T = A\b;
            % use projective transformation
            % A =  zeros(3*num_pts1,9);
            % b = zeros(3*num_pts1,1);
            % for i = 1:num_pts1
                % A(3*i-2,:) = [x1_prime(i), y1_prime(i), 1, 0, 0, 0, 0, 0, 0];
                % A(3*i-1,:) = [0, 0, 0, x1_prime(i),y1_prime(i), 1, 0, 0, 0];
                % A(3*i,:) = [0, 0, 0, 0, 0, 0, x1_prime(i),y1_prime(i), 1];
                % b(3*i-2) = im2_x(record(i));
                % b(3*i-1) = im2_y(record(i));
                % b(3*i) = 1;
            % end
            % T = A\b;
                 
            b_prime = A*T;
            difference_x = x1_prime - b_prime(1:2:end);
            difference_y = y1_prime - b_prime(2:2:end);
            % new predicted coordinates
            x1_prime = b_prime(1:2:end);
            y1_prime = b_prime(2:2:end);
        end
    end
    toc
    figure;
%    imagesc(im2); colormap gray; title('final alignment affine');
%    hold on;
%    plot(x1_prime, y1_prime, 'go', 'linewidth', 1);

    %create the aligned image
    aligned = zeros(size(im1,1),size(im1,2));
    for i = 1:length(y1_prime)
        if round(y1_prime(i))>=1 && round(x1_prime(i))>=1 && round(x1_prime(i))<= size(im1,2) && round(y1_prime(i)) <= size(im1,1)
            aligned(round(y1_prime(i)),round(x1_prime(i))) = 1;
        end
    end
    dispim = displayAlignment(im1, im2, aligned, 'thick');
    imshow(dispim)
    err = evalAlignment(aligned, im2)
    
end

