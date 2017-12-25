data = getData([], 'test','list');
ids = data.ids(1:3);
for i = 1:3
    
    data = getData(ids{i}, 'test', 'detection-results');
    fprintf('image %d\n', i);
    closest_d = Inf;
    closest = {};
    for j = 1:3
        
        X = data.score{j}.ds(:,7);
        Y = data.score{j}.ds(:,8);
        Z = data.score{j}.ds(:,9);
        
        for k = 1:size(X)
            distance = norm([X(k), Y(k), Z(k)]);
            label = data.class{j};
            
            if X(k) >= 0
                txt = 'to your right'; 
            else
                txt = 'to your left';
            end
            fprintf('There is a %s %0.1f meters %s \n', label, abs(X(k)), txt);
            fprintf('It is %0.1f meters away from you \n', distance);
            
            if closest_d > distance
                closest_d = distance;
                closest{1} = label;
                closest{2} = distance;
                closest{3} = X(k);
            end
        end
    end

    fprintf('\nThe %s is closest to you at %0.1f meters\n', closest{1}, closest{2});
    if closest{3} >= 0
        ctxt = 'to your right'; 
    else
        ctxt = 'to your left';
    end
    fprintf('It is %0.1f meters away %s \n', abs(closest{3}), ctxt);
    fprintf('\n\n');
end