function d = getPatch(img,xp,yp,sz)
%Get a square patch from the image, assume zero padding for boundary
%condition
d = zeros((2*sz+1)^2,1);
[xi,yi] = meshgrid((xp-sz):(xp+sz),(yp-sz):(yp+sz));

%remove out of bound index
toRemove = xi<=0 | yi<=0 | xi>size(img,2) | yi > size(img,2);


%Return the data
inds = sub2ind(size(img),yi(~toRemove),xi(~toRemove));
d(~toRemove) = img(inds);
