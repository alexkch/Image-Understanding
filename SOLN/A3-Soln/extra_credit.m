% CSC420 Assignment 3
% Extra credit solution
% Author: Jake Snell <jsnell@cs.toronto.edu>
% 10/25/2017

%% prepare workspace
clear variables;
close all;
clc;

%% load camera params and data
camera_params
load('rgbd.mat');

%% Construct camera calibration matrix
K = [fx_d  0     px_d;
     0     fy_d  py_d;
     0     0     1];
 
 % We are working with camera coordinates so we
 % don't need rotation or 3D translation
 P = K * eye(3, 4);
 
%% Construct grid of image coordinates for each pixel
[x, y] = meshgrid(0:size(im,2)-1, 0:size(im,1)-1);
y = size(im,1)-1-y;

%% Solve for real-world X and Y in camera coordinates
Z = depth(1:480, 1:640);
X = (Z / fx_d) .* (x - px_d);
Y = (Z / fy_d) .* (y - py_d);

surf(X,Z,Y,Z,'EdgeColor','none');
xlabel('x');
ylabel('z');
zlabel('y');

%% Compute coordinates of all objects
nobj = 4;
Xobj = zeros(1, nobj);
Yobj = zeros(1, nobj);
Zobj = zeros(1, nobj);

for i=1:nobj
    [y,x] = find(labels==i);
    y = size(im,1)-1-y;
    Z = depth(labels==i);
    X = (Z / fx_d) .* (x - px_d);
    Y = (Z / fy_d) .* (y - py_d);
    
    Xobj(i) = mean(X);
    Yobj(i) = mean(Y);
    Zobj(i) = mean(Z);
end

for i=1:nobj
    fprintf('object %d: mu_x = %f, mu_y = %f, mu_z = %f\n', i, Xobj(i), Yobj(i), Zobj(i));
end
fprintf('\n');

distobj = sqrt(Xobj.^2 + Yobj.^2 + Zobj.^2);
[maxDist, maxDistInd] = max(distobj);
fprintf('object %d is farthest from the camera with distance %f\n', maxDistInd, maxDist);

[maxHeight, maxHeightInd] = max(Yobj);
fprintf('object %d is highest above the floor with height %f\n', maxHeightInd, maxHeight);