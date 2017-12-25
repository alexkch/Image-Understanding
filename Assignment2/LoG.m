
function LoG
  
    img = double(rgb2gray(imread('synthetic.png')));
    
    radius = 2;
    
    threshold = 0.2;
    k = 1.1;
    sigma = 5;
    s = k.^(1:50)*sigma;
    
    resLoG = zeros(size(img,1),size(img,2),length(s));
    figure, imagesc(img), axis image, colormap(gray),hold on
    
    %% Filter over a set of scales - borrowed from tutorial
    for si = 1:length(s);
        
        sL = s(si);
        hs= max(25,min(floor(sL*3),128));
        HL = fspecial('log',[hs hs],sL);
        imgFiltL = conv2(img,HL,'same');
        resLoG(:,:,si)  = (sL^2)*imgFiltL;
    end

    for i = 1:length(s)
        
        sc = s(i);
        max_filter = strel('disk', radius).Neighborhood;    
        ord_max = nnz(max_filter==1);
        n = ordfilt2(resLoG(:,:,i), ord_max, max_filter);
        t = threshold*min(n(:));
        [y,x] = find(n<=t);
        total_pts = size(y, 1);
        
        for j = 1:length(total_pts)
            
            if i == 1
                result = isScaleMax(resLoG(:,:,1:1),resLoG(:,:,2:3), x(j), y(j));
            elseif i == length(s)
                result = isScaleMax(resLoG(:,:,i:i), resLoG(:,:,i-2:i-1), x(j), y(j));
            else
                result = isScaleMax(resLoG(:,:,i:i),resLoG(:,:,i-1:2:i+1), x(j), y(j));
            end
                     
            if result == 1
                
                xc = sc*sin(0:0.1:2*pi)+x(j);
                yc = sc*cos(0:0.1:2*pi)+y(j);
                drawnow;
                plot(xc,yc,'r');
        
            end           
        end
    end      
end
