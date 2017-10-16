%% Step 1 - Import Video and Initialize Foreground Detector
% Rather than immediately processing the entire video, the example starts
% by obtaining an initial video frame in which the moving objects are
% segmented from the background. This helps to gradually introduce the
% steps used to process the video.
%
% The foreground detector requires a certain number of video frames in
% order to initialize the Gaussian mixture model. This example uses the
% first 50 frames to initialize three Gaussian modes in the mixture model.
clear;
clc;
close all;

%% Load the info file of ground truth data
% load('PS12_3_3_gt.mat');
videoData = getVideoHOG('PS12_3_3');

%% Split training and testing data (80% training : 20% testing)
idx = randperm(size(videoData, 1));
splitPoint = round(size(videoData, 1) * 0.8);
trainData = videoData(idx(1:splitPoint), :);
testData = videoData(idx((splitPoint + 1):end), :);

%% SVM classification
svmOption = '-s 0, -t 0';    % Linear kernel
mdl = svmtrain(trainData(:,end), trainData(:, 1:end-1), svmOption);
result = svmpredict(testData(:, end), testData(:, 1:end-1), mdl);

% Counter to record the current frame number
% currentFrame = 0;

% numTrainingFrames = 50;
% foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
%     'NumTrainingFrames', NumTrainingFrames);

% Update current frame count
% currentFrame = currentFrame + NumTrainingFrames;
% Load video using VideoFileReader because there is a handy step() function
% videoReader = vision.VideoFileReader('PS12_3_3.mp4');
% for i = 1:1000
%     frame = step(videoReader); % read the next video frame
%     foreground = step(foregroundDetector, frame);
% end

%% Showing and storing feature info of the first frame
% Show the first frame. For ... fun?
% frame = step(videoReader);
% frame = rgb2gray(step(videoReader));
% figure; imshow(frame); title('Video Frame');
% Extract HOG feature
% hog = extractHOGFeatures(frame, 'cellsize', [128 128], 'blocksize', [4 4]);
% Update current frame counter
% currentFrame = currentFrame + 1;

% Create and initialize matrix to store HOG features for each frame + label
% based on the size of hog feature and the total number of frames in the video
% totalData = zeros(num_frames, size(hog, 2) + 1); % + 1 for class label
% totalData(1, 1:size(hog, 2)) = hog;

%% Step 2 - Detect Cars in an Initial Video Frame
% The foreground segmentation process is not perfect and often includes
% undesirable noise. The example uses morphological opening to remove the
% noise and to fill gaps in the detected objects.
% se = strel('square', 3);
% filteredForeground = imopen(foreground, se);
% figure; imshow(filteredForeground); title('Clean Foreground');

%%
% Next, we find bounding boxes of each connected component corresponding to
% a moving car by using vision.BlobAnalysis object. The object further
% filters the detected foreground by rejecting blobs which contain fewer
% than 150 pixels.
% minBoxSize = 2500;
% maxBoxSize = 100000;
% blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%     'AreaOutputPort', false, 'CentroidOutputPort', false, ...
%     'MinimumBlobArea', minBoxSize, 'MaximumBlobArea', maxBoxSize);
% bbox = step(blobAnalysis, filteredForeground);

%%
% To highlight the detected cars, we draw green boxes around them.
% result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

%%
% The number of bounding boxes corresponds to the number of cars found in
% the video frame. We display the number of found cars in the upper left
% corner of the processed video frame.
% numCars = size(bbox, 1);
% result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
%     'FontSize', 14);
% figure; imshow(result); title('Detected Cars');

%% Step 3 - Process the Rest of Video Frames
% In the final step, we process the remaining video frames.
% videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
% videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
% se = strel('square', 3); % morphological filter for noise removal

% Get the HOG features of the frames for the rest of the video
% while ~isDone(videoReader)
% for i = 2:num_frames
%     frame = rgb2gray(step(videoReader)); % read the next video frame
%     hog = extractHOGFeatures(frame, 'cellsize', [128 128], 'blocksize', [4 4]);
%     currentFrame = currentFrame + 1;
%     totalData(currentFrame, 1:size(hog, 2)) = hog;

    % Detect the foreground in the current video frame
    % foreground = step(foregroundDetector, frame);

    % Use morphological opening to remove noise in the foreground
    % filteredForeground = imopen(foreground, se);

    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    % bbox = step(blobAnalysis, filteredForeground);

    % Draw bounding boxes around the detected cars
    % result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

    % Display the number of cars found in the video frame
    % numCars = size(bbox, 1);
    % result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
    %     'FontSize', 14);

    % step(videoPlayer, result);  % display the results
% end

% release(videoReader); % close the video file

%%
% The output video displays the bounding boxes around the cars. It also
% displays the number of cars in the upper left corner of the video.
% displayEndOfDemoMessage(mfilename)
