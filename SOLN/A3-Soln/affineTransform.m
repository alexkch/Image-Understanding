function X2 = affineTransform(X1, A)
    % Applies affine transform A to X1
    % X1: 2 x N
    % A: 2 x 3
    
    X1 = cat(1, X1, ones(1, size(X1, 2)));
    X2 = A * X1;
end