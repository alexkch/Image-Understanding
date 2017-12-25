function normcorrX(image_url, templates, dimensions)

% production code

image = imread(image_url);
gray_image = double(rgb2gray(image));
[N, M] = size(gray_image);

gray_template = cell(1,30);
correlation_array = zeros(N, M, 30);

for i = 1 : 10
    
    tH = dimensions(1,i).height;
    tW = dimensions(1,i).width;
    %turn rgb matrix templates into grayscale (take 1st layer)
    gray_template{1,i} = double(templates{1,i}(:,:,1));

    offSetX_1 = round(tW/2);
    %offSetX_2 = round(tW/2) + N - 1;
    offSetX_2 = round(tW/2) + M - 1;
    offSetY_1 = round(tH/2);
    %offSetY_2 = round(tH/2) + M - 1;
    offSetY_2 = round(tH/2) + N - 1;
    output = normxcorr2(gray_template{1,i}, gray_image);
        
    correlation_array(:,:,i) = output(offSetY_1:offSetY_2, offSetX_1:offSetX_2);
    
end

[maxCorr, maxIdx] = max(correlation_array,[],3);

%THRESHOLD
%threshold = 0.618;
%threshold = 0.616;
%threshold = 0.6145;
threshold = 0.588;

candidates = struct;
candidates.map = maxCorr > threshold;
candidates.value = maxCorr(candidates.map); 


%test
candidates.maxIdx = maxIdx;
%test

[size_col, size_row] = size(candidates.map);
coordinates = find(candidates.map);

[a, b] = size(coordinates);

figure;imagesc(gray_image);colormap gray;

for i = 1 : a
    
    candidates.candX(i) = floor( (coordinates(i,1)-1) / size_col) + 1;
    candidates.candY(i) = mod(coordinates(i,1), size_col);
    
    template_index = maxIdx(candidates.candY(i),candidates.candX(i));
    
    thisCorr = correlation_array(:,:,template_index);
    result = isLocalMaximum(candidates.candX(i), candidates.candY(i), thisCorr);
    
    if result == 1
        drawnow;
        drawAndLabelBox(candidates.candX(i),candidates.candY(i),template_index , dimensions );
    end
end

end


function result = isLocalMaximum(x, y, thisCorr)

    thisCorr3 = thisCorr(y-1:y+1,x-1:x+1);
    [M, I] = max(thisCorr3(:));
    [I_row, I_col] = ind2sub(size(thisCorr3),I);
    
    if M <= thisCorr(y,x)
        result = 1;
    else
        result = 0;
    end

end


