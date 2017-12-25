function [ interest_points ] = harris_nms( M,T,r )
% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
[xx,yy]=meshgrid(1:2*r+1,1:2*r+1);
dis_to_center=sqrt((xx-(r+1)).^2+(yy-(r+1)).^2);
domain_r=(dis_to_center<=r);
M_nms=ordfilt2(M,sum(domain_r(:)),domain_r);
interest_points_img=(M==M_nms)&(M>T);
[xx_img,yy_img]=meshgrid(1:size(M,2),1:size(M,1));
interest_points=[xx_img(interest_points_img),yy_img(interest_points_img)];
end