function output = calc3D(score, depth, calib)

    x_thresh = 350;
    y_thresh = 1199;
    size_i = size(score.ds,1);
    for i = 1:size_i
        
        x = score.ds(i,2):score.ds(i,4);
        y = score.ds(i,1):score.ds(i,3);
        x = round(x);
        y = round(y);
        x = x(x<=x_thresh);
        y = y(y<=y_thresh);
        z_depth = depth(x,y);
        Z = mode(round(z_depth(:)));
        cX = score.ds(i,1)+(score.ds(i,3)-score.ds(i,1))/2;
        cY = score.ds(i,2)+(score.ds(i,4)-score.ds(i,2))/2;
        X = (Z.*(cX - calib.K(1,3)))/calib.f;
        Y = (Z.*(cY - calib.K(2,3)))/calib.f;
        data.score.ds(i,7) = X;
        data.score.ds(i,8) = Y;
        data.score.ds(i,9) = Z;
        
    end
    output = score;
end