function [ransac_pts, ransac_affine] = affineX(i1, i2, ~)


%run('/h/u9/g6/00/changkao/Downloads/vlfeat-0.9.20/toolbox/vl_setup')

%img1 = imread('/h/u9/g6/00/changkao/csc420/assignments/Assignment2/book.jpg');
%img2 = imread('/h/u9/g6/00/changkao/csc420/assignments/Assignment2/findBook.JPG');
threshold = 0.5;

img1 = single(rgb2gray(i1));
img2 = single(rgb2gray(i2));


[f,d] = vl_sift(img1) ;

[f2, d2] = vl_sift(img2) ;

  
e_dist= pdist2(double(d)', double(d2)', 'euclidean');
ascending_l = sort(e_dist, 2);
r=ascending_l(:,1)./ascending_l(:,2);

t_index = find(threshold>r);
num_matches = zeros(size(t_index,1), 3);


for i = 1:size(e_dist, 1)

    if threshold > r(i)

        num_matches(i,1) = r(i);
        num_matches(i,2)= i;
        t_matches = (e_dist(i,:)==ascending_l(i,1));        
        num_matches(i,3)=find(t_matches);
    end
end

tesmp = any(num_matches, 2);
num_matches( ~tesmp, : ) = [];
mscores = zeros(size(num_matches,1), 1);
x_coordinates = zeros(size(num_matches,1),2);
y_coordinates = zeros(size(num_matches,1),2);

for i = 1:size(num_matches,1)

    mscores(i) = num_matches(i,1);
    x_coordinates(i,1:2) = [f(1,num_matches(i,2)) f2(1,num_matches(i,3))];
    y_coordinates(i,1:2) = [f(2,num_matches(i,2)) f2(2,num_matches(i,3))];

end

    k = size(mscores,1)

    %helper to get k top matches and their coordinates
    top = topmatches(mscores, x_coordinates, y_coordinates, k);
    trials = 100;
    num_perm = 3;
    threshold2 = 2.21;

    %RANSAC ( matches, num of trials, num or pairs )
    [ransac_index, ransac_affine] = RANSAC(top, trials, num_perm, threshold2);
    ransac_pts = top(ransac_index,:);

end