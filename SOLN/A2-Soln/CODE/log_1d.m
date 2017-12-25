function [ x,f ] = log_1d( sigma,k )
% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
x=-k:0.1:k;
f=-exp(-x.^2/2/sigma/sigma).*(1-x.^2/2/sigma/sigma)/pi/(sigma^4);
end