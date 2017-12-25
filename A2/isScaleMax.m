function result = isScaleMax(reslog, scalelogs, x, y)

    
    Scale3_1 = scalelogs(y-1:y+1, x-1:x+1, 1:1); 
    Scale3_2 = scalelogs(y-1:y+1, x-1:x+1, 2:2); 

    [min_1, ~] = min(Scale3_1(:));
    [min_2, ~] = min(Scale3_2(:));
    
    % compare with neighborhood in the other scale spaces,
    % return true, if it is the maximum in 3x3x3 neighborhood
    if (reslog(y, x) <= min_1)&&(reslog(y, x) <= min_2)
        result = 1;
    else
        result = 0;
    end

end