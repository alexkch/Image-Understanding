%or load a real image
%img = rand(imSize,imSize);
img = imread('synthetic.png');
img = double(img);
img = mean(img,3);

%%perform base-level smoothing to supress noise
imgS = img;%conv2(img,fspecial('Gaussian',[25 25],0.5),'same');%Base smoothing
cnt = 1;
clear responseDoG responseLoG
k = 1.1;
sigma = 2.0;
s = k.^(1:50)*sigma;
responseDoG = zeros(size(img,1),size(img,2),length(s));
responseLoG = zeros(size(img,1),size(img,2),length(s));
imG = zeros(size(img,1),size(img,2),length(s));

d = [1 1]';
%% Filter over a set of scales
for si = 1:length(s);
    sL = s(si);
    hs= max(25,min(floor(sL*3),300));
    HL = fspecial('log',[hs hs],sL);
    H = fspecial('Gaussian',[hs hs],sL);
    if(si<length(s))
        Hs = fspecial('Gaussian',[hs hs],s(si+1));
    else
        Hs = fspecial('Gaussian',[hs hs],sigma*k^(si+1));
    end
    imgFiltL = conv2(imgS,HL,'same');
    imgFilt = conv2(imgS,H,'same');
    imG(:,:,si) = imgFilt;
    imgFilt2 = conv2(imgS,Hs,'same');
    %Compute the DoG
    responseDoG(:,:,si)  = (imgFilt2-imgFilt);
    %Compute the LoG
    responseLoG(:,:,si)  = (sL^2)*imgFiltL;
    
    n = ordfilt2(responseLoG(:,:,si), si, strel('disk', floor(si/2)).Neighborhood);
    t = 0.9*min(n(:));
    [r,c] = find(n<=t);
    rc = [r c];
    d = [d rc'];
end

% figure, imagesc(img), axis image, colormap(gray),hold on
% plot(d(1,:), d(2,:), 'ro'), title('Corners detected');
% hold off;

%Why do responseDoG and responseLoG look different for larger k?

%% Explore the scale space
t = 1;
DESC = 1;

for i = size(d(1,:))
    fg = figure;imagesc(img);axis image;hold on;colormap gray;
    x = d(1,i);
    y = d(2,i);

    x= round(x);
    y = round(y);



    if(isempty(x))
        t = 0;
    else
        plot(x,y,'r.');

        %Get the maxima/minima over scale
        f = squeeze(responseLoG(y,x,:));
        [fMax,fmaxLocs] = findpeaks(f');%maxima
        [fMin,fminLocs] = findpeaks(-f');%minima
        for i = 1:numel(fmaxLocs)
            sc = s(fmaxLocs(i));
            %Draw a circle
            figure(fg);
            xc = sc*sin(0:0.1:2*pi)+x;
            yc = sc*cos(0:0.1:2*pi)+y;
            plot(xc,yc,'r');

            %% Is it also a spatial maxima/minima?
            [nx,ny,nz] = meshgrid(x-1:x+1,y-1:y+1,fmaxLocs(i));
            inds = sub2ind(size(responseLoG),ny,nx,nz);
            df = responseLoG(inds(5))-responseLoG(inds);
            df(5)=[];%don't compare to itself
            if(min(df)>=0)
                plot(xc,yc,'r-o');
            end

        end
    end
end