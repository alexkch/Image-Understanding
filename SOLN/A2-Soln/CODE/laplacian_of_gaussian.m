function [ interest_points ] = laplacian_of_gaussian( img_gray,sigma_range,log_thres )
% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
img_gray=double(img_gray);
sigma_list=zeros(sigma_range(2),1);
for ii=1:sigma_range(2)
    sigma_list(ii)=sigma_range(1)*sigma_range(3)^ii;
end
filter_buffer=zeros(size(img_gray,1),size(img_gray,2),length(sigma_list));
for ii=1:length(sigma_list)
    sigma=sigma_list(ii);
    filter_buffer(:,:,ii)=abs(sigma*sigma*imfilter(img_gray,fspecial('log',floor(3*sigma),sigma),'replicate'));
end
blob_idx=find(filter_buffer==imdilate(filter_buffer,ones(3,3,3)));
blob_val=filter_buffer(blob_idx);
[sorted_blob_val,idx]=sort(blob_val,'descend');
sorted_blob_idx=blob_idx(idx);
[y,x,s]=ind2sub(size(filter_buffer),sorted_blob_idx);
interest_points=[x,y,reshape(sigma_list(s),[size(x,1),1]),sorted_blob_val];
idxk=find(interest_points(:,4)>log_thres,1,'last');
interest_points=interest_points(1:idxk,:);
end