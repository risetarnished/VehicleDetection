%% start CarRecogintion.m
[FileName,PathName] = uigetfile('*.mp4','Select the Traffic Video file');
trafficObj = VideoReader([PathName '\' FileName]);
thresh = 40; % thershold for the difference between the frames
bg = read(trafficObj, 1); % read the first frame
bg_bw = rgb2gray(bg); % convert background to greyscale
% ----------------------- set frame size variables -----------------------
fr_size = size(bg); % get the size of the first frame that has size 1x2
width = fr_size(2); % x
height = fr_size(1); % y
fg = zeros(height, width); % the image with the vehicles only

%% Create video streams
frameRate = get(trafficObj,'FrameRate');
nframes = get(trafficObj, 'NumberOfFrames');

taggedCars = zeros([size(bg,1) size(bg,2) 3 71], class(bg)); % the output video with the tagged cars

taggedCars(:,:,:,1) = bg;
%% Define Line for Counting Cars
% xy = defineLine(rgb2gray(bg));
% CRegionXSt = min(xy(:, 2));
% CRegionXEn = max(xy(:, 2));
% CRegionYSt = min(xy(:, 1));
% cRegionSize = max(xy(:, 1)) - min(xy(:,1));
% xy = plot()
countCars = 0;
plotThres = 40;%the differrence of current and previous frame
sumCr1 = 0;% the sum of pixels of region that user defines
RC_Val = true;
close all; figure(2)
%% --------------------- process frames -----------------------------------
fprintf(1,'Parsing Frames...    ');
for i = 2:nframes
    fr = read(trafficObj, i); % read i frame
    taggedCars(:,:,:,i) = fr;

    fr_bw = rgb2gray(fr); % convert frame to grayscale

    fr_diff = abs(double(fr_bw) - double(bg_bw));

    prev = [-12 -12]; % Keep the position of last detected counted car
    for j=1:width
        for k=1:height
            if ((fr_diff(k,j) > thresh))
                fg(k,j) = fr_bw(k,j);
                if or(abs(prev(1) - j) > plotThres, abs(prev(2) -k) > plotThres)
                    % Plot the red rectungle around the car
                    if(and(k-2 > 0, k+2 > 0, j+2 > 100))
                        countCars=countCars+1;
                        RC_Val = false;
                    end
                end
            end
        end
    end
    if(RC_Val == false)
        if(abs(sumCr1 - sumCr2)  == 0)
            RC_Val = true;
        end
    end
    bg_bw = fr_bw;
    subplot(3,1,1),imshow(fr)
    title(['frame #' num2str(i)])
    subplot(3,1,2),imshow(fr_bw)
    subplot(3,1,3),imshow(uint8(fg))
    fprintf(2,'\b\b\b\b%3.0f%c',(double(i)/double(nframes))*100, '%');
end
%% Plot the Line where counting cars
 fprintf(2,'\nPlotting...     ');
 % aviobj = VideoWriter('C:\Users\chris\Dropbox\Lessons\csd\cs474\project\Submit\out4.avi');
 aviobj = VideoWriter([pwd '\out4.avi']);
 aviobj.FrameRate = frameRate;
 open(aviobj);
for f = 1:nframes
    for i = CRegionXSt:CRegionXEn
        for j = CRegionYSt:CRegionYSt+cRegionSize
            taggedCars(:,:,:,f) = plotColor( taggedCars(:,:,:,f), j, i, 200, 150, 125 );
        end
    end
    writeVideo(aviobj, taggedCars(:,:,:,f));
    fprintf(2,'\b\b\b\b%3.0f%c',(double(f)/double(nframes))*100, '%');
end
close(aviobj);
implay(taggedCars, frameRate)
fprintf(2,'\nCars passed: %s\n',num2str(countCars));
%% end
