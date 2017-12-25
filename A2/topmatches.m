function top = topmatches(mscores, x, y, k)

    combined = [mscores, x, y];
    sorted = sortrows(combined, 1);
    
    top = sorted(1:k, :);

end