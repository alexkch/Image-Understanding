function [digits] = readThermometer(im, templates, dimensions)
% Returns the digits detected in the input image.
% By Andrei Barsan, UofT, based on the code from Sanja Fidler, UofT.

% It's important to pay attention to this convention. Different
% environments/libraries can have different ways of representing image
% dimensions, e.g., either width/height or rows/cols (note the different order).
% Here, we use the former, width M = width, N = height.
M = size(im, 1);  % Image width
N = size(im, 2);  % Image height

% convert image to grayscale
im_input = im;
im = rgb2gray(im);
im = double(im);

% Prepare the 3D array where we will be storing all our template responses.
corrArray = zeros(M, N, length(templates));

% (c) Template matching.
for i = 1:length(templates)
  templateWidth = dimensions(i).width;
  templateHeight = dimensions(i).height;
  fprintf("Processing template #%d, of size [%d, %d].\n", i, templateWidth, templateHeight);
  
  % (c.i) Prepare the template by also converting it to double and grayscale.
  % Note: braces are used instead of parentheses for indexing since 'templates'
  % is a MATLAB cell array. Please see the documentation for further details.
  template = double(rgb2gray(templates{i}));
  % normalized cross-correlation
  response = normxcorr2(template, im);
  
  % (c.ii) Ensure the response is pruned to the right size.
  offsetX = round(templateWidth / 2);
  offsetY = round(templateHeight / 2);
  response = response(offsetY : offsetY + M - 1, offsetX : offsetX + N - 1);
  
  corrArray(:, :, i) = response;
end

% (d) Find the peaks.
[maxCorr, maxIdx] = max(corrArray, [], 3); 

% (e) Perform the thresholding.
% THRESHOLD = 0.678: Zero false positives.
THRESHOLD = 0.678;
maxIdx(maxCorr < THRESHOLD) = 0;

% (f) Perform local maximum detection and box drawing.
% Note that this could be done more efficiently by avoiding explicit for-loops,
% but at the expense of readability.
imshow(im_input);
hold on;

% Keep track of the digits we detected (not required for the assignment).
digits = [];

% (f.i)
for x = 1:N
  for y = 1:M
    % Ignore points below the threshold.
    templateIndex = maxIdx(y, x);
    if templateIndex == 0
      continue
    end
    
    % (f.ii)
    thisCorr = corrArray(:, :, templateIndex);
    
    % (f.iii)
    if isLocalMaximum(x, y, thisCorr)
      digits = [digits; mod(templateIndex, 10)];
      
      % (f.iv)
      drawAndLabelBox(x, y, templateIndex, dimensions);
      drawnow();
    end
  end
end


end