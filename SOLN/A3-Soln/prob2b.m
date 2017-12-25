% CSC420 Assignment 3
% Problem 2b solution
% Author: Jake Snell <jsnell@cs.toronto.edu>
% 10/24/2017

%% prepare workspace
clear variables;
close all;
clc;
% replace with path to your own VLFEAT installation
VLFEAT_ROOT = '/Users/jakesnell/build/vlfeat/';
run(strcat(VLFEAT_ROOT, 'toolbox/vl_setup'));

%% load images
x = double(imread('mugShot.jpg')) / 255.0;
x = imresize(x, 0.5);
xgray = single(rgb2gray(x));
[fxRaw,dxRaw] = getSift(xgray);

%% iterate through random permutations
nIter = 100;

bestSsd = Inf;
bestY = [];

for i=1:nIter
    perm = randperm(6);
    y = assembleCuts(perm);
    ygray = single(rgb2gray(y));
    [fy,dy] = getSift(ygray);
    
    [fx,fy] = matchSift(fxRaw,dxRaw,fy,dy);
    
    [A, inliers] = ransacHomography(fx, fy, 100, false);
    fyhat = affineTransform(fx, A);

    ssd = mean(sum((fyhat - fy).^2, 1));
    
    fprintf('iter %02d: ssd = %f\n', i, ssd);
    
    if ssd < bestSsd
        bestSsd = ssd;
        bestY = y;
    end
end

%% show best y and ssd
fprintf('best ssd = %f\n', bestSsd);
figure;
imshow(bestY);
title('Reconstructed image');

%% function definitions
function y = assembleCuts(perm)
    y = [];
    for i=1:size(perm,2)
        cut = double(imread(sprintf('shredded/cut%02d.png', perm(i)))) / 255.0;
        cut = imresize(cut, 0.8);
        if isempty(y)
            y = cut;
        else
            y = cat(2, y, cut);
        end
    end
end