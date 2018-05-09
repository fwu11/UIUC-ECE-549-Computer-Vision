function [VP, lineLabel] = vpDetectionFromLines(lines)

%% Simple vanishing point detection using RANSAC
% === Input === 
% lines: [NumLines x 5]
%   - each row is a detected line segment (x1, y1, x2, y2, length)
% 
% === Output ===
% VP: [2 x 3]
%   - each column corresponds to a vanishing point in the order of X, Y, Z
% lineLabel: [NumLine x 3] logical type
%   - each column is a logical vector indicating which line segments
%     correspond to the vanishing point.

%% solve for vanishing point 
NumLines = size(lines,1);
centers = ones(NumLines,3);
centers(:,1) = (lines(:,1)+lines(:,3))/2;
centers(:,2) = (lines(:,2)+lines(:,4))/2;
M = 500;               % number of vanishing point hypothesis
threshold = 1;                %concensus threshold
PrefMat = logical(zeros(NumLines,M));
VP = zeros(2,3);

for m = 1:M
    % randomly choose one pair of edges and determine the vanishing point
    idx = randsample(NumLines,2);
    l_1 = real(cross([lines(idx(1),1); lines(idx(1),2); 1],[lines(idx(1),3); lines(idx(1),4); 1]));
    l_2 = real(cross([lines(idx(2),1); lines(idx(2),2); 1],[lines(idx(2),3); lines(idx(2),4); 1]));
    vp_sample = real(cross(l_1,l_2));
    % Assign the edge to the preference matrix if the consistency measure
    % is within the threshold
    for i = 1:NumLines
        mid_van = real(cross(centers(i,:)',vp_sample));
        distance = abs(dot(mid_van,[lines(i,1);lines(i,2);1])/sqrt(mid_van(1).^2+mid_van(2).^2));     
        PrefMat(i,m) = (distance < threshold);
    end
end

% we can get 3 clusters
lineLabel = clusterLineSeg(PrefMat);

temp = lineLabel(:,3);
lineLabel(:,3) = lineLabel(:,2);
lineLabel(:,2) = lineLabel(:,1);
lineLabel(:,1) = temp;

% we perform similar method as part A
% find the vanishing point by finding the minimum angular difference
for iter = 1:3
    index = find(lineLabel(:,iter) ==1);
    % compute the score
    % Angular distance is the difference between 
    % (1) the direction from the line segment midpoint to the vanishing point; 
    % and (2) the direction of the line segment.
    VP(:,iter) = minAngularDist( lines, centers, index);
end
end

function lineLabel = clusterLineSeg(PrefMat)

numVP = 3;

T = JLinkageCluster(PrefMat);
numCluster = length(unique(T));
clusterCount = hist(T, 1:numCluster);
[~, I] = sort(clusterCount, 'descend');

lineLabel = false(size(PrefMat,1), numVP);
for i = 1: numVP
    lineLabel(:,i) = T == I(i);
end

end

function [T, Z, Y] = JLinkageCluster(PrefMat)

Y = pDistJaccard(PrefMat');
Z = linkageIntersect(Y, PrefMat);
T = cluster(Z,'cutoff',1-(1/(size(PrefMat,1)))+eps,'criterion','distance');

end
