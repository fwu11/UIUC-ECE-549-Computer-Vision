function [ vp ] = minAngularDist( lines, centers, idx)
    sigma = 0.1;
    l = lines(idx,:);
    l_center = centers(idx,:);
    len = length(idx);
    c = combnk(1:len,2);
    intersect_num = size(c,1);
    vp_candidate = zeros(3,intersect_num);
    score = zeros(1,intersect_num);
    
    for j = 1:intersect_num 
        summation = 0;
        l_1 = real(cross([l(c(j,1),1); l(c(j,1),2); 1],[l(c(j,1),3); l(c(j,1),4); 1]));
        l_2 = real(cross([l(c(j,2),1); l(c(j,2),2); 1],[l(c(j,2),3); l(c(j,2),4); 1]));
        vp_candidate(:, j) = real(cross(l_1,l_2));
        
        for i = 1:len
            l_temp = real(cross([l(i,1); l(i,2); 1],[l(i,3); l(i,4); 1]));
            theta = rem(atan(-l_temp(1)/l_temp(2))+pi,pi);
            alpha = rem(atan((l_center(i,2)/l_center(i,3) - vp_candidate(2,j)/vp_candidate(3,j))/(l_center(i,1)/l_center(i,3) - vp_candidate(1,j)/vp_candidate(3,j)))+pi,pi);         
            summation = summation+l(i,5)*exp(-abs(alpha-theta)/(2*sigma^2));
        end
        score(j) = summation;
    end
    [~,index] = max(score);
    vp = [vp_candidate(1,index)/vp_candidate(3,index); vp_candidate(2,index)/vp_candidate(3,index)]; 
end

