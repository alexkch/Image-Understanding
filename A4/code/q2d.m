data = getData([], 'test','list');
ids = data.ids(1:3);
for i = 1:3
    data = getData(ids{i}, 'test', 'detection-results');
    calib = getData(ids{i}, 'test', 'calib');
    disp = getData(ids{i}, 'test', 'disp');
    disparity = disp.disparity;
    depth = (calib.f*calib.baseline)./disparity;
    
    for j = 1:3     
        data.score{j} = calc3D(data.score{j}, depth, calib);
        ds = data.score{j}.ds;
        fname=sprintf('../data/test/results/%s-%s',ids{i}, data.class{j});
        save(fname, 'ds');
    end
end

