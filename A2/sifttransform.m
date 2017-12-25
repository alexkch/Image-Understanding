function sifttransform

    %% Setup

    %run('/h/u9/g6/00/changkao/Downloads/vlfeat-0.9.20/toolbox/vl_setup')
    book = imread('book.jpg');
    findbook = imread('findBook.JPG');



    %% Part (a)

    imbook = single(rgb2gray(book)) ;
    imfindbook = single(rgb2gray(findbook)) ;

    [f,d] = vl_sift(imbook) ;
    [f2, d2] = vl_sift(imfindbook) ;

    figure, imagesc(imbook), axis image,hold on
    perm = randperm(size(f,2)) ;
    sel = perm(1:50) ;
    h1 = vl_plotframe(f(:,perm)) ;
    h2 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
    set(h1,'color','y','linewidth',3) ;
    set(h2,'color','g') ;
    hold off;

    figure, imagesc(imfindbook), axis image,hold on
    perm2 = randperm(size(f2,2)) ;
    sel2 = perm2(1:50) ;
    hb1 = vl_plotframe(f2(:,perm2)) ;
    hb2 = vl_plotsiftdescriptor(d2(:,sel2),f2(:,sel2));
    set(hb1,'color','y','linewidth',3) ;
    %hold off;
    %figure, image(imfindbook), axis image, hold on
    set(hb2,'color','g') ;
    hold off;



    %% Part (b)

     %threshold = 0.747
     %threshold = 0.221
    %threshold = 0.275;
    threshold = 0.673;

    %offset for montage (displaying 2 images together)
    offset = size(imfindbook);
    offset = offset(2);

    e_dist= pdist2(double(d)', double(d2)', 'euclidean');
    ascending_l = sort(e_dist, 2);
    r=ascending_l(:,1)./ascending_l(:,2);
    %ratios=euc(:,1)./euc(:,2);

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

    figure, imshowpair(imbook, imfindbook, 'montage'), axis image, hold on

    for i = 1:size(mscores,1)

        drawnow;
        plot([x_coordinates(i,1) offset+x_coordinates(i,2)],[y_coordinates(i,1) y_coordinates(i,2)], 'g');

    end

    hold off;



    %% Part (c and d)

    %k = 1;
    %k = 4;
    k = 12;
    %k = 50;

    %helper to get k top matches and their coordinates
    top = topmatches(mscores, x_coordinates, y_coordinates, k);

    image_dim = size(imbook);

    x = [0;image_dim(2);image_dim(2);0];
    y = [0;0;image_dim(1);image_dim(1)];

    P = [];
    PP = [];

    for i = 1:k

        %coordinates from top matches corresponding to image 1
        x1 = top(i,2);
        y1 = top(i,4);

        %coordinates from top matches corresponding to image 2
        x2 = top(i,3);
        y2 = top(i,5);


        P(size(P,1)+1,:) = [x1 y1 0 0 1 0];
        P(size(P,1)+1,:) = [0 0 x1 y1 0 1];

        PP(size(PP,1)+1,:) = x2;
        PP(size(PP,1)+1,:) = y2;


    end

    affine = (P'*P)'*inv((P'*P)*(P'*P)')*P'*PP
    Px = (P'*P)'
    affine2 = inv(P'*P)*P'*PP
    A = [];

    for i = 1:4
        A(size(A,1)+1,:) = [x(i) y(i) 0 0 1 0];
        A(size(A,1)+1,:) = [0 0 x(i) y(i) 0 1];
    end

    transform = A*affine;

    new_x = transform(1:2:length(transform));
    new_y = transform(2:2:length(transform));
    offset_x = new_x + offset;

    figure, imshowpair(imbook, imfindbook, 'montage'), axis image, hold on
    for i = 1:4
        drawnow;
        plot([x(i) offset_x(i)], [y(i) new_y(i)], 'g');
    end

    connect_x= [offset_x' offset_x(1)];
    connect_y= [new_y' new_y(1)];
    plot(connect_x,connect_y);
    hold off;

end

