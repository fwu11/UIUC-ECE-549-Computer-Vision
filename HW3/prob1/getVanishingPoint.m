function vp = getVanishingPoint(im)
% output vanishing point, input image

figure(1), hold off, imagesc(im)
hold on 

% Allow user to input line segments; compute centers, directions, lengths
disp('Set at least two lines for vanishing point')
lines = zeros(3, 0);
line_length = zeros(1,0);
centers = zeros(3, 0);
while 1
    disp(' ')
    disp('Click first point or q to stop')
    [x1,y1,b] = ginput(1);    
    if b=='q'        
        break;
    end
    disp('Click second point');
    [x2,y2] = ginput(1);
    plot([x1 x2], [y1 y2], 'b')
    lines(:, end+1) = real(cross([x1 y1 1]', [x2 y2 1]'));
    line_length(end+1) = sqrt((y2-y1)^2 + (x2-x1).^2);
    centers(:, end+1) = [x1+x2 y1+y2 2]/2;
end

%% solve for vanishing point 
% Insert code here to compute vp (3x1 vector in homogeneous coordinates)
line_num = size(lines,2);
c = combnk(1:line_num,2);
intersect_num = size(c,1);
sigma = 0.1;
score = zeros(1,intersect_num);
vp_candidate = zeros(3,0);

for k = 1:intersect_num 
    vp_candidate(:, end+1) = real(cross(lines(:,c(k,1)), lines(:,c(k,2))));
end

% compute the score
% Angular distance is the difference between 
% (1) the direction from the line segment midpoint to the vanishing point; 
% and (2) the direction of the line segment.
for j = 1:intersect_num 
    summation = 0;
    for i = 1:line_num
        theta = rem(atan(-lines(1,i)/lines(2,i))+pi,pi);
		alpha = rem(atan((centers(2,i)/centers(3,i) - vp_candidate(2,j)/vp_candidate(3,j))/(centers(1,i)/centers(3,i) - vp_candidate(1,j)/vp_candidate(3,j)))+pi,pi);
        summation = summation+line_length(i) *exp(-abs(alpha-theta)/(2*sigma^2));
    end
    score(j) = summation;
end
[~,index] = max(score);
vp = vp_candidate(:,index);

%% display 
hold on
bx1 = min(1, vp(1)/vp(3))-10; bx2 = max(size(im,2), vp(1)/vp(3))+10;
by1 = min(1, vp(2)/vp(3))-10; by2 = max(size(im,1), vp(2)/vp(3))+10;
for k = 1:size(lines, 2)
    if lines(1,k)<lines(2,k)
        pt1 = real(cross([1 0 -bx1]', lines(:, k)));
        pt2 = real(cross([1 0 -bx2]', lines(:, k)));
    else
        pt1 = real(cross([0 1 -by1]', lines(:, k)));
        pt2 = real(cross([0 1 -by2]', lines(:, k)));
    end
    pt1 = pt1/pt1(3);
    pt2 = pt2/pt2(3);
    plot([pt1(1) pt2(1)], [pt1(2) pt2(2)], 'g', 'Linewidth', 1);
end
plot(vp(1)/vp(3), vp(2)/vp(3), '*r')
axis image
axis([bx1 bx2 by1 by2]); 

