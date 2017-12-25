function [fx,dx] = getSift(x)
    % x is 2D matrix (grayscale)
    [fx,dx] = vl_sift(x);

    % keep coordinates only
    fx = fx(1:2, :);
    dx = double(dx);

    % normalize to unit length
    dx = dx ./ sqrt(sum(dx.^2, 1));

    % clip to max of .2
    dx(dx > .2) = .2;

    % re-normalize
    dx = dx ./ sqrt(sum(dx.^2, 1));
end