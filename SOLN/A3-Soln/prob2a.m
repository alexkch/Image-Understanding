% CSC420 Assignment 3
% Problem 2a solution
% Author: Jake Snell <jsnell@cs.toronto.edu>
% 10/12/2017

%% prepare workspace
clear variables;
close all;
clc;
% replace with path to your own VLFEAT installation
VLFEAT_ROOT = '/Users/jakesnell/build/vlfeat/';
run(strcat(VLFEAT_ROOT, 'toolbox/vl_setup'));

%% load images
x = vl_impattern('roofs1');
Agt = [1          tan(pi/48) 0;
       tan(pi/24) 1          0];
tform = affine2d(cat(2, Agt', [0; 0; 1]));
y = imwarp(x, tform);
y = y(1:size(x,1),1:size(x,2),:);
xgray = single(rgb2gray(x));
ygray = single(rgb2gray(y));

%% compute sift descriptors
[fx,dx] = getSift(xgray);
[fy,dy] = getSift(ygray);

%% find closest matches between left and right
[fx,fy] = matchSift(fx,dx,fy,dy);
clear dx;
clear dy;

fprintf('%d matches found\n', size(fx, 2));

%% plot greedy match
figure;
imshow(cat(2, x, y));
hold on;
title('Greedy');

for i=1:size(fx, 2)
    plot([fx(1,i), fy(1,i) + size(x,2)], [fx(2,i), fy(2,i)], 'b');
    hold on;
end

%% Perform RANSAC
[A, inliers] = ransacHomography(fx, fy, 100);

fprintf('predicted A:\n');
A
fprintf('ground truth A:\n');
Agt

figure;
imshow(cat(2, x, y));
hold on;
title('RANSAC');

fxInliers = fx(:, inliers);
fyhat = affineTransform(fxInliers, A);

for i=1:size(fxInliers, 2)
    xcoords = fxInliers(:, i);
    ycoords = fyhat(:, i);
    plot([xcoords(1), ycoords(1) + size(x,2)], [xcoords(2), ycoords(2)], 'b');
    hold on;
end
