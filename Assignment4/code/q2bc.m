
data = getData([], 'test','list');
ids = data.ids(1:3);
dtype = {'person', 'bicycle', 'car'};
person_threshold = -0.5;
cyclist_threshold = -0.355;
car_threshold = -0.5487;
for idx= 1:3
    
    if idx == 1
        dtype = 'detector-person';
        thresh = person_threshold;
        rtype = 'person';
    elseif idx == 2
        dtype = 'detector-cyclist';
        thresh = cyclist_threshold;
        rtype = 'cyclist';
    else
        dtype = 'detector-car';
        thresh = car_threshold;
        rtype = 'car';
    end
    for k= 1:3    
        data = getData([], [], dtype);
        model = data.model;
        imdata = getData(ids{k}, 'test', 'left');
        im = imdata.im;
        f = 1.5;
        imr = imresize(im,f); % if we resize, it works better for small objects

        % detect objects
        fprintf('running the detector, may take a few seconds...\n');
        tic;
        [ds, bs] = imgdetect(imr, model, thresh); % you may need to reduce the threshold if you want more detections
        e = toc;
        fprintf('finished! (took: %0.4f seconds)\n', e);
        nms_thresh = 0.5;
        top = nms(ds, nms_thresh);
        if model.type == model_types.Grammar
          bs = [ds(:,1:4) bs];
        end
        if ~isempty(ds)
            % resize back
            ds(:, 1:end-2) = ds(:, 1:end-2)/f;
            bs(:, 1:end-2) = bs(:, 1:end-2)/f;
        end;
        fprintf('detections:\n');
        ds = ds(top, :);
        result=sprintf('../data/test/results/%s-%s',ids{k}, rtype);
        save(result, 'ds');
    end
end

color = {'blue', 'cyan', 'red', 'magenta'};
for k = 1:3
    data = getData(ids{k}, 'test', 'detection-results');
    imdata = getData(ids{k}, 'test', 'left');
    im = imdata.im;
    figure; axis ij; hold on; drawnow;
    imagesc(im);
    for c = 1:3
        showboxesMy(im, data.score{c}.ds(:,1:4), color{c});
        text(data.score{c}.ds(:,1), data.score{c}.ds(:,2), data.class{c},'Color',color{4},'FontSize',12);
    end
end

