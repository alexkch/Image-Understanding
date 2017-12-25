function [indexs, max_affine] = RANSAC(top_pts, trials, num_perm, threshold)

    indexs = [];
    max_matches = 0;
    

    P = [];
    Pa = [];
    for i = 1:size(top_pts, 1);
        
        x1 = top_pts(i,2);
        y1 = top_pts(i,4);
        
        
        x2 = top_pts(i,3);
        y2 = top_pts(i,5);

        P(size(P,1)+1,:) = [x1 y1 0 0 1 0];
        P(size(P,1)+1,:) = [0 0 x1 y1 0 1];

        Pa(size(Pa,1)+1,:) = x2;
        Pa(size(Pa,1)+1,:) = y2;
    end

    
    
    while trials > 0
        
        random_choices = randperm(size(top_pts,1), num_perm);
        random_pts = top_pts(random_choices,:);
        
        trials = trials-1;
        Rp = [];
        Rpa = [];

        for i = 1:3
            
            % random points from img 1
            x1 = random_pts(i,2);
            y1 = random_pts(i,4);
            
            % random points from img 2
            x2 = random_pts(i,3);
            y2 = random_pts(i,5);

            Rp(size(Rp,1)+1,:) = [x1 y1 0 0 1 0];
            Rp(size(Rp,1)+1,:) = [0 0 x1 y1 0 1];

            Rpa(size(Rpa,1)+1,:) = x2;
            Rpa(size(Rpa,1)+1,:) = y2;
            
        end
                
        
        %affine = P'*inv(P*P')*Pa;
        random_affine = inv(Rp'*Rp)*Rp'*Rpa;
        
        transform = P*random_affine;
        
        T_x = transform(1:2:length(transform));
        T_y = transform(2:2:length(transform));
        Pa_x = Pa(1:2:length(Pa));
        Pa_y = Pa(2:2:length(Pa));
        
        diff_x = abs(Pa_x - T_x);
        diff_y = abs(Pa_y - T_y);
        diff_total = abs(diff_x+diff_y);
        closest = find(diff_total < threshold);
        
        if max_matches < size(closest, 1);
            max_matches = size(closest,1);
            max_affine = random_affine;
            indexs = closest;
        end
    end
end