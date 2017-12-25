function Harris

    radius = 5;
    threshold = 0.342;

    img = double(rgb2gray(imread('/h/u9/g6/00/changkao/csc420/assignments/Assignment2/building.jpg')));

    [Ix,Iy] = imgradientxy(img);

    g = fspecial('gaussian', 3, 6);
    
    Ix2 = conv2(Ix.^2, g, 'same'); 
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');
    R = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2);

    figure; imagesc(R); axis image; colormap(gray);
    
    max_filter = strel('disk', radius).Neighborhood;
    
    ord_max = nnz(max_filter==1);
    
    max_pixel = ordfilt2(R, ord_max, strel('disk', radius).Neighborhood);
    
    n = threshold*max(max_pixel(:));
    
    [r,c] = find(max_pixel>=n);
    
    figure, imagesc(img), axis image, colormap(gray),hold on
    plot(c, r, 'ro');
    hold off;
end