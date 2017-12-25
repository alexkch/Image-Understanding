

data = getData([],'test','list');
ids = data.ids(1:3);

for i= 1:3
    calib = getData(ids{i}, 'test', 'calib');
    disp = getData(ids{i}, 'test', 'disp');
    disparity = disp.disparity;
    figure;imagesc(disparity);
    fT = calib.f*calib.baseline;
    depth = fT./disparity;
    dfosho = depth;
    dfosho(dfosho>255)=255+eps;
    figure;imagesc(dfosho);
end