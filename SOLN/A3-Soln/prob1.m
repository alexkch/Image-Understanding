% CSC420 Assignment 3
% Problem 1 solution
% Author: Jake Snell <jsnell@cs.toronto.edu>
% 10/12/2017

clear;
clc;
close all;

% Uses method from Appendix of (Criminisi 2002)

% Image coordinates of bill (found by manually clicking with getpts)
% Note that we treat the bottom left of the image as the origin
% First row:   x coordinates
% Second row:  y coordinates
p = [1168 1371  776 1067;
       41  594  195  667;
        1    1    1    1];

% World coordinates of bill
d1 = 15.24;      % length of bill in cm
d2 =  6.985;     % height of bill in cm
P = [ 0 d1  0 d1;
      0  0 d2 d2;
      1  1  1  1];

% Construct A
A = zeros(2*size(p,2), 3*size(p,1));
A(1:2:end,1:size(p,1)) = p';
A(2:2:end,size(p,1)+1:2*size(p,1)) = p';
A(1:2:end,2*size(p,1)+1:3*size(p,1)) = -p' .* P(1,:)';
A(2:2:end,2*size(p,1)+1:3*size(p,1)) = -p' .* P(2,:)';

% Compute h as the null vector of A
h = null(A);
H = reshape(h, size(p,1), size(p,1))';

% Image coordinates of shoe (bottom left, bottom right, top left)
q = [274 963  12;
     209 870 372;
       1   1   1];

% Convert to world coordinates by pre-multiplying with H
Q = H*q;

% Convert out of homogeneous coordinates
Qx = Q(1,:) ./ Q(3,:);
Qy = Q(2,:) ./ Q(3,:);

Qbl = [Qx(1) Qy(1)];  % bottom-left
Qbr = [Qx(2) Qy(2)];  % bottom-right
Qtl = [Qx(3) Qy(3)];  % top-left

% Compute length and width of shoe by l2-norm of difference
% in world coords
fprintf('estimated length: %0.2f cm\n', norm(Qbr - Qbl));
fprintf('estimated width:  %0.2f cm\n', norm(Qtl - Qbl));
