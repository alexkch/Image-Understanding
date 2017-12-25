%% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
% References:
% [1] Matlab File Exchange: Keypoint Extraction by Vincent Garcia
% [2] Matlab File Exchange: Harris Corner Detector by Ali Ganoun
% [3] CSC420 16Fall by Chris McIntosh
% [4] CSC420 17Spring by Sanja Fidler
% [5] CSC420 17Fall by Ahmed Bilal Ashraf
%% Problem 1a
% parameters
HARRIS_SIGMA=2;
HARRIS_ALPHA=0.01;
% main
img=imread('../building.jpg');
[ M ] = harris_metric( rgb2gray(img),HARRIS_SIGMA,HARRIS_ALPHA );
% plot
figure;subplot(1,2,1);
image(img);
subplot(1,2,2);
imagesc(M);

%% Problem 1b
% parameters
HARRIS_R=10;
HARRIS_T=0.1;
% main
[ interest_points ] = harris_nms( M,HARRIS_T,HARRIS_R );
% plot
figure;
imshow(img);hold on;
plot(interest_points(:,1),interest_points(:,2),'r*');
hold off;

%% Problem 1c
% parameters
SIGMA_RANGE=[3,20,1.15];
LOG_THRES=51;
% main
img2=imresize(imread('../synthetic.png'),[256,256]);
[ interest_points ] = laplacian_of_gaussian( rgb2gray(img2),SIGMA_RANGE,LOG_THRES );
% plot
figure;
imshow(img2);hold on;
for ii=1:size(interest_points,1)
    x=interest_points(ii,1);y=interest_points(ii,2);r=interest_points(ii,3);
    rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','r','LineWidth',2);
end
hold off;

%% Problem 1d
% main
[ M ] = harris_metric( rgb2gray(img),HARRIS_SIGMA,HARRIS_ALPHA );
[ interest_points_1 ] = harris_nms( M,HARRIS_T,HARRIS_R );
[ M ] = harris_metric( rgb2gray(img2),HARRIS_SIGMA,HARRIS_ALPHA );
[ interest_points_2 ] = harris_nms( M,HARRIS_T,HARRIS_R );
[ interest_points_3 ] = laplacian_of_gaussian( rgb2gray(img),SIGMA_RANGE,LOG_THRES );
[ interest_points_4 ] = laplacian_of_gaussian( rgb2gray(img2),SIGMA_RANGE,LOG_THRES );
% plot
figure;subplot(2,2,1);
imshow(img);hold on;
plot(interest_points_1(:,1),interest_points_1(:,2),'r*');
hold off;
subplot(2,2,2);
imshow(img2);hold on;
plot(interest_points_2(:,1),interest_points_2(:,2),'r*');
hold off;
subplot(2,2,3);
imshow(img);hold on;
for ii=1:size(interest_points_3,1)
    x=interest_points_3(ii,1);y=interest_points_3(ii,2);r=interest_points_3(ii,3);
    rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','r','LineWidth',2);
end
hold off;
subplot(2,2,4);
imshow(img2);hold on;
for ii=1:size(interest_points_4,1)
    x=interest_points_4(ii,1);y=interest_points_4(ii,2);r=interest_points_4(ii,3);
    rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','r','LineWidth',2);
end
hold off;

%% Problem 2a
% parameters
VL_FEAT_ROOT='F:\CSC420\2017Spring\Tutorial3\vlfeat-0.9.20';
% main
src=imread('../book.jpg');
trg=imread('../findBook.jpg');
run([VL_FEAT_ROOT,'\toolbox\vl_setup.m'])
[f1,d1]=vl_sift(single(rgb2gray(src))/255);
[f2,d2]=vl_sift(single(rgb2gray(trg))/255);
% plot
figure;subplot(1,2,1);
imshow(src);
hold on;
vl_plotframe(f1);
hold off;
subplot(1,2,2);
imshow(trg);
hold on;
vl_plotframe(f2);
hold off;

%% Problem 2b
% parameters
SIFT_MATCH_RATIO=0.8;
NUM_OF_MATCHES=30;
SIFT_PATH='F:\CSC420\2017Spring\Tutorial3\sift';
% main
[ matches ] = sift_match( d1',d2',SIFT_MATCH_RATIO,NUM_OF_MATCHES );
% plot
addpath(genpath(SIFT_PATH));
figure;
plotmatches(double(src)/255,double(trg)/255,f1(1:2,:),f2(1:2,:),matches');

%% Problem 2c 2d
% parameters
MOORE_PENROSE_K=5;
% main
x_src=[f1(1:2,matches(1:MOORE_PENROSE_K,1))',ones(MOORE_PENROSE_K,1)];
x_trg=[f2(1:2,matches(1:MOORE_PENROSE_K,2))',ones(MOORE_PENROSE_K,1)];
A=inv(x_src'*x_src)*(x_src'*x_trg);
A(1:2,3)=0;
A(3,3)=1;
src_corners=[1,1,1;1,size(src,1),1;size(src,2),size(src,1),1;size(src,2),1,1;1,1,1;];
trg_corners=src_corners*A;
figure;
imshow(trg);hold on;
plot(trg_corners(:,1),trg_corners(:,2),'LineWidth',2);
hold off;

%% Problem 2e
% main
src=imresize(imread('../colourTemplate.png'),[300,300]);
trg=imread('../colourSearch.png');
[f1,d1r]=vl_sift(single(src(:,:,1))/255);
[~,d1g]=vl_sift(single(src(:,:,2))/255,'frames',f1);
[~,d1b]=vl_sift(single(src(:,:,3))/255,'frames',f1);
d1=[d1r;d1g;d1b];
[f2,d2r]=vl_sift(single(trg(:,:,1))/255);
[~,d2g]=vl_sift(single(trg(:,:,2))/255,'frames',f2);
[~,d2b]=vl_sift(single(trg(:,:,3))/255,'frames',f2);
d2=[d2r;d2g;d2b];
[ matches ] = sift_match( d1',d2',SIFT_MATCH_RATIO,NUM_OF_MATCHES*3 );
% plot
figure;
plotmatches(double(src)/255,double(trg)/255,f1(1:2,:),f2(1:2,:),matches');

%% Problem 3a
% parameters
LOG_SIGMA=2;
% main
log_kernel=fspecial('log',floor(6*LOG_SIGMA),LOG_SIGMA);
[u,a,v]=svd(log_kernel);
% plot
figure;
plot(diag(a))

%% Problem 3b
% parameters
GAUSSIAN_SIGMA=2;
GAUSSIAN_DELTA_SIGMA=0.01;
GAUSSIAN_K=12;
LOG_SIGMA=2;
LOG_K=12;
% main
[ x,f ] = log_1d( LOG_SIGMA,LOG_K );
delta_sigma_list=GAUSSIAN_DELTA_SIGMA:GAUSSIAN_DELTA_SIGMA:0.3;
for ii=1:length(delta_sigma_list)
    delta_sigma=delta_sigma_list(ii);
    [ x1,f1 ] = gaussian_1d( GAUSSIAN_SIGMA,GAUSSIAN_K );
    [ x2,f2 ] = gaussian_1d( GAUSSIAN_SIGMA-delta_sigma,GAUSSIAN_K );
    dif(ii)=sqrt(sum(((f1-f2)-f).^2));
end
idx=find(dif==min(dif));
delta_sigma=delta_sigma_list(idx);
[ x1,f1 ] = gaussian_1d( GAUSSIAN_SIGMA,GAUSSIAN_K );
[ x2,f2 ] = gaussian_1d( GAUSSIAN_SIGMA-delta_sigma,GAUSSIAN_K );
% plot
figure;hold on;
plot(x1,f1-f2,'b');
plot(x,f,'r')
