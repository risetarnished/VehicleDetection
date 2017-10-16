Title :- Car Identification in Videos

Run Prepare Data for Blob Analysis
1. Download the video file and save it in folder as "vt.mp4" where you are saving the      Blob.m file.
2. Run Blob.m

1. Run blackandwhite1 to detect if the car is present in the frame or not 
to run the code place the data folder and the video file vt.mp4 and the groundtruth1 file in the folder where the program is executed . 
2. create a folder called result in D drive to write the answers.

1. Run blackandwhite2 to detect if the number of cars present in the frame or not 
to run the code place the data folder and the video file vt.mp4 and the groundtruth2 file in the folder where the program is execute. 
2. create a folder called result in D drive to write theanswers. 

Run Prepare Data for SIFT resizeScale=1
1. Run [videoData, videoClasses] = getVideoHOG(videofilename, resizeScale)


Run Prepare Data for Black & White Feature resizeScale=1
1. Run [videoData, videoClasses] = getVideoBW(videofilename, resizeScale)


Run Linear SVM and RBF SVM
1. Load the prepared data generated in above lines using uncommented code in file main_SVM.m 
e.g uncomment this line and load('PS12_1_7_bwdata.mat');
2. Run main_SVM.m 

Run KNN
1. Load the prepared data generated in above lines using uncommented code in file main_KNN.m
e.g uncomment this line and load('PS12_1_7_bwdata.mat');
2. Run main_KNN.m 