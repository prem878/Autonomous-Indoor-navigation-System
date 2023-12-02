% Create a video input object with the webcam as the video source
vidObj = videoinput('winvideo', 1, 'RGB24'); % 'winvideo' for Windows platform, 'RGB24' for 24-bit color

% Set the video input parameters
set(vidObj, 'FramesPerTrigger', 1);
set(vidObj, 'TriggerRepeat', Inf);
set(vidObj, 'ReturnedColorSpace', 'rgb');

% Start the video acquisition
start(vidObj);

% Create a figure to display the webcam feed
figure;
hImage = imshow(zeros(480, 640, 3)); % Adjust the size as needed

% Create a SURF object for feature extraction
surfObj = vision.SURF('MetricThreshold', 500); % Adjust the metric threshold as needed

while ishandle(hImage)
    % Capture a frame from the webcam
    frame = getsnapshot(vidObj);
    
    % Convert the frame to grayscale for feature extraction
    grayFrame = rgb2gray(frame);
    
    % Detect SURF features
    points = step(surfObj, grayFrame);
    
    % Display the captured frame with detected features
    annotatedFrame = insertMarker(frame, points, 'circle', 'Size', 10, 'Color', 'r');
    set(hImage, 'CData', annotatedFrame);
    
    % You can further process or analyze the detected features here
    
    drawnow; % Update the figure
end

% Stop the video acquisition and clean up
stop(vidObj);
delete(vidObj);
release(surfObj);
clear vidObj surfObj;
% Author 
   Chilumula.Prem Kumar.
%
