% This is the driver program to classify the number of cars in a particular
% frame using K-Nearest Neighbors
% Because K (number of neighbors) is literally the only parameters able to be
% altered and there are no other methods like the different kernel functions
% in SVM, this program does K-NN classification on its own rather than calling
% other functions

clear;
clc;
close all;

%% If there is no available data for the video
%  call get_video_data() first
% [videoData, videoClasses] = getVideoHOG('PS12_1_1', 0.5);
% [videoData, videoClasses] = getVideoHOG('PS12_1_7', 0.25);
% [videoData, videoClasses] = getVideoHOG('PS12_1_8', 0.25);
% [videoData, videoClasses] = getVideoHOG('PS12_3_3', 0.25);
% [videoData, videoClasses] = getVideoBW('PS12_1_1', 0.5);
% [videoData, videoClasses] = getVideoBW('PS12_1_7', 0.25);
% [videoData, videoClasses] = getVideoBW('PS12_1_8', 0.25);
% [videoData, videoClasses] = getVideoBW('PS12_3_3', 0.25);

%% Load video data from saved .mat file
%  Uncomment the one that needs to be used
% load('PS12_1_1_data.mat');
% load('PS12_1_7_data.mat');
% load('PS12_3_3_data.mat');
% load('PS12_1_1_bwdata.mat');
% load('PS12_1_7_bwdata.mat');
% load('PS12_1_8_bwdata.mat')
load('PS12_3_3_bwdata.mat');

% Declare/Rename the data and class labels for simplicity
frameData = videoData;
classes = videoClasses;

%% Split training and testing data (60% training : 20% validation : 20% testing)
frameData = normc(frameData);
numFrames = size(frameData, 1);
idx = randperm(numFrames);
splitValidation = round(numFrames * 0.6);   % 60% mark
splitTesting = round(numFrames * 0.8);      % 80% mark
trainData = frameData(idx(1:splitValidation), :);
trainClasses = classes(idx(1:splitValidation), :);
validateData = frameData(idx((splitValidation+1):splitTesting), :);
validateClasses = classes(idx((splitValidation+1):splitTesting), :);
testData = frameData(idx((splitTesting+1):end), :);
testClasses = classes(idx((splitTesting+1):end), :);

%% Use training and validation data to determine the number of neighbors that
%  produces the highest accuracy
accuracies = zeros(1, 10);
for k = 1:10    % Try 1:10 for the number of neighbors
    mdl = fitcknn(trainData, trainClasses, 'NumNeighbors', k);
    labels = predict(mdl, validateData);
    confMat = confusionmat(validateClasses, labels);
    accuracy = sum(diag(confMat)) / sum(confMat(:));
    accuracies(k) = accuracy;
end

% Visualize the trend
figure;
plot(1:10, accuracies, 'r.-');
title('KNN - Determine the Number of Neighbors');
xlabel('Number of Neighbors');
ylabel('Accuracy');

% Get the best number of neighbors
% k are integers from 1 to 10, which corresponds with their indices
% [~, bestNumNeighbors] = max(accuracies);
[neighborRank, indices] = sort(accuracies, 'descend');
bestNumNeighbors = indices(1);
% If k=1 produces the highest accuracy, it needs to be omitted.
if bestNumNeighbors == 1
    % Take the number of neighbors that produces the second highest accuracy
    bestNumNeighbors = indices(2);
end

%% KNN classification
mdl = fitcknn(trainData, trainClasses, 'NumNeighbors', bestNumNeighbors);
validateLabel = predict(mdl, validateData);
validateConfMat = confusionmat(validateClasses, validateLabel);
validateAccuracy = sum(diag(validateConfMat)) / sum(validateConfMat(:));
fprintf('Validation Accuracy = %f%s\n', validateAccuracy * 100, '%');
testLabel = predict(mdl, testData);
testConfMat = confusionmat(testClasses, testLabel);
testAccuracy = sum(diag(testConfMat)) / sum(testConfMat(:));
fprintf('Testing Accuracy = %f%s\n', testAccuracy * 100, '%');
