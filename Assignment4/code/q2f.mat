data = getData([], 'test','list');
ids = data.ids(1:3);
col = {'r', 'b', 'c'};
for i = 1:3
    data = getData(ids{i}, 'test', 'ds');
    imdata = getData(ids{i}, 'test', 'left');
    im = imdata.im;
    d={};
    for c = 1:3
        X = data.dss{c}.ds(:,7);
        Y = data.dss{c}.ds(:,8);
        Z = data.dss{c}.ds(:,9);
        for j = 1:size(Z)
            d{end+1,1} = norm([X(j), Y(j), Z(j)]);
            d{end,2} = data.class{c};
            d{end,3} = X(j);
        end       
    end  
    d = sortrows(d); %information about whatever is closest is presented first
    for j = 1:size(d,1)
        if d{j,3} >= 0, txt = 'to your right'; else txt = 'to your left'; end; 
        fprintf('There is a %s %0.1f meters %s \n', d{j,2}, d{j,3}, txt);
        fprintf('It is %0.1f meters away from you \n', d{j,1});
        
    end
    fprintf('-----------------------------------------]\n');
end