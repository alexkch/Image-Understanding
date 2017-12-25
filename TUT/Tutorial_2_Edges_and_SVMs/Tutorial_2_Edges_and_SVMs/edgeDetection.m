%% Tutorial for Edge Detection written by Chris McIntosh (chris.mcintosh@rmp.uhn.on.ca)
% Some modifications by Andrei Barsan (iab@cs.toronto.edu).

close all;

% Set the random seed so the results are reproducible across runs.
rng(1);

% Generate a dummy image.
uClean = zeros(256, 256);
uClean(100:150,100:160)=1;
% uClean(90:130,80:140)=1;
u0 = uClean + 0.5*rand(size(uClean));
figure,imagesc(u0); axis image;   colormap gray;
title("Noisy image");

u = double(u0);

%% SVM Demo for edge detection
% This section is based on the libsvm MATLAB helpers, NOT the built-in MATLAB
% SVM functions! See https://www.csie.ntu.edu.tw/~cjlin/libsvm/ for more details.
% Alternative tutorial here: https://sites.google.com/site/kittipat/libsvm_matlab
% Put your own path here after you download the toolbox. You don't have to make
% a system-wide install (I didn't):
addpath(genpath('/Users/andrei/work/libsvm-3.22/matlab/'));

% Ground truth
cannyEdge = edge(uClean);
figure;imagesc(cannyEdge);
title("Ground truth (clean image)");

% Get many random image patches from uClean
k = 5;
N = 150000;
X = zeros(N, (2*k+1)^2);
Y = zeros(N, 1);
for a=1:N
    xp = round(1+rand(1)*(size(u0,2)-1));
    yp = round(1+rand(1)*(size(u0,1)-1));
    
    %Get random patch data
    X(a,:) = getPatch(uClean, xp, yp, k);
    
    %Get the label, 0 if not edge, 1 if edge.
    Y(a) = cannyEdge(yp, xp);
end

% Visualize some of the patches labeled as "edge".
edgePatches = X(Y==1, :);
nonEdgePatches = X(Y==0, :);
figure
for i = 0:5
  for j  = 0:5
    idx = i * 5 + j + 1;
    if idx > min(25, size(edgePatches, 1))
      continue
    end
    subplot(5, 5, idx);
    imagesc(reshape(edgePatches(idx, :), 2*k+1, 2*k+1));
  end
end

% This part of the code is not required, but can help lead to somewhat better
% results. Since randomly sampling patches HEAVILY biases our training data
% towards patches with the "no edge" (edge = 0) label, here we get rid of some
% of the training data points labeled as "no edge" in order to balance the
% classes a bit better.
nonEdgePatches = nonEdgePatches(1:15000, :);
X = [edgePatches; nonEdgePatches];
Y = zeros(size(X, 1), 1);
Y(1:size(edgePatches,1), 1) = 1;

fprintf('%d \tpositive labels\n%d \tnegative labels\n', sum(Y==1), sum(Y==0));
fprintf('Starting to train libsvm-powered SVM...\n');

tic;
% You don't need to worry about SVM kernels for this course!
% -t = 2 => RBF kernel, (-g)amma 0.07, (-c)ost (higher -> more aggressively fit to the data (can lead to overfitting)).
% -b = 1 => train a SVR so we can output (-b)probability estimates
% -q => be quiet.
model = svmtrain(Y, X, '-t 2 -g 0.07 -c 0.1 -b 1 -q');

fprintf('Finished training SVM in %s seconds.\n', num2str(toc));

% The MATLAB way to do the training. Slower and needs a bit more finetuning to
% get working in practice. The interface is a bit nicer than libsvm's MATLAB
% API.
% fprintf('Starting to train SVM.\n');
% model = fitcsvm(X, Y);
% fprintf('Finished training SVM.\n');

% Let's perform the predictions. 
% For EVERY pixel, we grab the patch around it, and feed it to the classifier.
edgeness = zeros(size(uClean));
edgeBinary = zeros(size(uClean));

%% Is there a more efficient way to set this up?
% Try on u0, u, and uClean
for xp = 1:size(uClean,2)
    for yp = 1:size(uClean,1)
        imgPatch = getPatch(u,xp,yp,k);
        % Make a prediction. Be (-q)uiet, and output (-b)robabilities.
        [svmOut, svmACC, svmDec] = svmpredict(1, imgPatch' , model, '-q -b 1');
        edgeness(yp, xp) = svmDec(2);
        edgeBinary(yp, xp) = svmOut;
    end
end


%% Show a side-by-side comparison between our ML-based detector's results and the
% vanilla Canny edge detector on a noisy image.
figure;
subplot(1, 2, 1);
imagesc(edgeBinary);
axis image;
colormap gray;
title("SVM edge detector result on the noisy image");

subplot(1, 2, 2);
imagesc(edge(u0));
axis image;
colormap gray;
title("Canny edge detector result on the noisy image");

figure;
imagesc(edgeness);
axis image;
colormap parula;
title("Edgeness");

