function [ M ] = harris_metric( img_gray,sigma,alpha )
% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
img_gray=double(img_gray);
conv_kernel_x=[-1,0,1;-1,0,1;-1,0,1]; 
conv_kernel_y=conv_kernel_x';
Ix=conv2(img_gray,conv_kernel_x,'same');   
Iy=conv2(img_gray,conv_kernel_y,'same');
window_function=fspecial('gaussian',6*sigma,sigma);
Ix2=conv2(Ix.^2,window_function,'same');  
Iy2=conv2(Iy.^2,window_function,'same');
Ixy=conv2(Ix.*Iy,window_function,'same');
M=(Ix2.*Iy2-Ixy.^2)-alpha*(Ix2+Iy2).^2;
M=M/max(M(:));
end