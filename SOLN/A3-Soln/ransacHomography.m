function [A, bestInliers] = ransacHomography(fx, fy, nIter, verbose)
    if nargin < 4
        verbose = true;
    end
    
    bestNInliers = 0;
    bestInliers = [];
    
    for i=1:nIter
        % Select 3 correspondences at random
        curInds = randperm(size(fx, 2));
        curInds = curInds(1:3);

        % find homography
        A = homography(fx(:, curInds), fy(:, curInds));
 
        % apply transform to get predicted locations
        fyhat = affineTransform(fx, A);
        
        % compute euclidean distances between pred and true keypoints
        fdist = fy - fyhat;
        fdist = sqrt(sum(fdist .^ 2, 1));
        
        % compute inliers
        inliers = (fdist <= 3.0);
        nInliers = sum(inliers);

        if verbose
            fprintf('iter %d: %d inliers (%0.2f%%)\n', i, nInliers, 100 * nInliers / size(fx, 2));
        end

        if nInliers > bestNInliers
            bestNInliers = nInliers;
            bestInliers = inliers;
        end
    end
    
    if verbose
        fprintf('best fit: %d inliers (%0.2f%%)\n', bestNInliers, 100 * bestNInliers / size(fx, 2));
    end

    % Use inliers to re-fit homography
    A = homography(fx(:,bestInliers), fy(:, bestInliers));
end

function A = homography(X1, X2)
    % computes affine transform between X1 and X2
    % X1: 2 x N
    % X2: 2 x N
    P = zeros(2 * size(X1, 2), 6);
    P(1:2:end, 1:2) = X1';
    P(2:2:end, 3:4) = X1';
    P(1:2:end, 5) = 1;
    P(2:2:end, 6) = 1;
    p = X2(:);
    
    % solve for affine transform
    if size(X1, 2) == 3
        a = pinv(P) * p;
    else
        a = pinv(P' * P) * P' * p;
    end
    A = [a(1) a(2) a(5);
         a(3) a(4) a(6)];
end