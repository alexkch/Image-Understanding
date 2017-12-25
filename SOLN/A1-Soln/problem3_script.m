im = imread('thermometer.png');

% (b) Read in the templates.
[templates, dimensions] = readInTemplates();

digits = readThermometer(im, templates, dimensions);

fprintf("Read %d digits from the thermometer image:\n", length(digits));
disp(digits);
