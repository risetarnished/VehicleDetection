clear;
clc;
close all;

%% If there is no available data for the video
%  call get_video_data() first
% [videoData, videoClasses] = getVideoHOG('PS12_1_1', 0.5);
% [videoData, videoClasses] = getVideoHOG('PS12_1_7', 0.25);
% [videoData, videoClasses] = getVideoHOG('PS12_1_8', 0.25);
% [videoData, videoClasses] = getVideoHOG('PS12_3_3', 0.25);

%% Load video data from saved .mat file
%  Uncomment the one that needs to be used
% load('PS12_1_1_data.mat');
% load('PS12_1_7_data.mat');
% load('PS12_1_8_data.mat');
% load('PS12_3_3_data.mat');
load('PS12_1_7_bwdata.mat');
% load('PS12_3_3_bwdata.mat');
% load('PS12_1_8_bwdata.mat');
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

%% SVM - Linear Kernel
[bestCost, linValAccu, linValConfMat, linTestAccu, linTestConfmat] = ...
    doLinearSVM(trainData, trainClasses, validateData, validateClasses, ...
                testData, testClasses);
fprintf('Linear - Validation Accuracy: %f%s\n', linValAccu * 100, '%');
fprintf('Linear - Testing Accuracy: %f%s\n', linTestAccu * 100, '%');

%% SVM - RBF Kernel
[bestGamma, rbfValAccu, rbfValConfMat, rbfTestAccu, rbfTestConfmat] = ...
    doRbfSVM(trainData, trainClasses, validateData, validateClasses, ...
                testData, testClasses);
fprintf('RBF - Validation Accuracy: %f%s\n', rbfValAccu * 100, '%');
fprintf('RBF - Testing Accuracy: %f%s\n', rbfTestAccu * 100, '%');
