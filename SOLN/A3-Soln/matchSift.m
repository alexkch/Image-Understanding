function [fx,fy] = matchSift(fx,dx,fy,dy)
    ddist = pdist2(dx', dy', 'euclidean');
    
    matchRatios = zeros(1, size(ddist, 1));
    
    xInds = 1:size(ddist, 1);
    yInds = zeros(1, size(ddist, 1));

    for i=1:size(ddist,1)
        [~, bestInd] = min(ddist(i,:));
        sortedDist = sort(ddist(i,:));

        yInds(i) = bestInd;
        matchRatios(i) = sortedDist(1) / sortedDist(2);
    end

    matchInds = cat(1, xInds, yInds);

    % keep matches where reliability ratio is good
    matchInds = matchInds(:, matchRatios < 0.8);

    fx = fx(:, matchInds(1, :));
    fy = fy(:, matchInds(2, :));
end

