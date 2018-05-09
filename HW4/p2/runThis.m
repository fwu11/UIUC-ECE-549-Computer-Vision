%% ECE 549 HW4 
%% Question 2 EM algorithm
clear all; close all
load('annotation_data.mat');
N = length(image_ids);

% initialization
beta = 0.5;
bad_annotator = zeros(1,25);
sigma = 1;
maxiter = 1000;
niter = 0;
alpha = zeros(1,25);

% change the data into 30*25
annotator = reshape(annotator_ids,[30,25]);
score = reshape(annotation_scores,[30,25]);
image = reshape(image_ids,[30,25]);

% data into 150*5
score_2 = reshape(annotation_scores,[150,5]);
% initialize mean
mu = mean(score_2,2);

while niter < maxiter 
    for j = 1:25     
        % 5 annotators in 1 image, find their scores
        x = score(:,j);
        index = image(:,j);
        p = zeros(1,30);
        for count = 1:30
            p(count) = normpdf(x(count),mu(index(count)),sigma);
        end
        % e-step
        % use logsumexp
        numerator = sum(log([p,beta]));
        denominator = logsumexp([numerator;(30*log(0.1)+log(1-beta))]);
        alpha(j) = exp(numerator-denominator);
    end   
    
    % alpha into 150*5
    posterior = reshape(reshape(repmat(alpha,[30,1]),[750,1]),[150,5]);
    
    % m-step
    mu = sum(posterior.*score_2,2)./sum(posterior,2);
    sigma = sqrt(sum(sum(posterior.*(bsxfun(@minus, score_2, mu).^2)))/(sum(sum(posterior))));
    beta = sum(sum(posterior))/N;
    niter = niter+1;
end

figure;plot(1:150,mu(1:150));title('Mean scores for each image');
figure;bar(1:25, alpha); title('Probabilty of good for each annotator');