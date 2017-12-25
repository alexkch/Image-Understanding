function [ matches ] = sift_match( f1,f2,ratio,num_of_matches )
% CSC420 17Fall, solution to Assignment 2
% Author: Hang Chu
% University of Toronto
matches=[];
D=pdist2(f1,f2);
for m=1:num_of_matches
    [~,i]=min(D(:));
    [r,c]=ind2sub(size(D),i);
    vals=sort(D(r,:),'ascend');
    rt=vals(1)/(vals(2));
    if(rt<ratio)
        matches(end+1,:)=[r,c,rt];
    end
    D(i)=inf;    
    D(r,:)=inf;
    D(:,c)=inf;    
end
end
