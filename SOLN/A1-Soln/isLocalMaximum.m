function isMax = isLocalMaximum( x, y, corr )
%ISLOCALMAXIMUM Checks if (x, y) is a local maximum in the given correlation map.
  WINDOW_SIZE = 3;
  height = size(corr, 1);
  width = size(corr, 2);
  
  % Define the search area around (x, y), making sure that image borders are
  % taken into consideration.
  botY = max(1, y - floor(WINDOW_SIZE/2));
  topY = min(height, y + floor(WINDOW_SIZE/2));
  botX = max(1, x - floor(WINDOW_SIZE/2));
  topX = min(width, x + floor(WINDOW_SIZE/2));
  localArea = corr(botY:topY, botX:topX);
  % Find the position of the local maximum.
  [~, localMaxIdx] = max(localArea(:));
  
  % Convert the 1D index returned by max into a 2D index.
  [windowMaxY, windowMaxX] = ind2sub(size(localArea), localMaxIdx);

  % Convert the 2D index of the maximum expressed in local area coordinates to
  % global image coordinates.
  localMaxX = botX + windowMaxX - 1;
  localMaxY = botY + windowMaxY - 1;
 
  % If the local maximum is (x, y), then return true.
  isMax = (x == localMaxX && y == localMaxY);
end

