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

% Initialize variables to store the previous frame's features
prevPoints = [];
prevFeatures = [];

% Create an empty array to store inlier points for motion estimation
inlierPoints1 = [];
inlierPoints2 = [];

while ishandle(hImage)
    % Capture a frame from the webcam
    frame = getsnapshot(vidObj);
    
    % Convert the frame to grayscale for feature extraction
    grayFrame = rgb2gray(frame);
    
    % Detect SURF features
    points = step(surfObj, grayFrame);
    
    % Perform nearest neighbor matching between the current and previous frames
    if ~isempty(prevFeatures)
        indexPairs = matchFeatures(prevFeatures, points);
        
        % Get the matched points from both frames
        matchedPoints1 = prevPoints(indexPairs(:, 1), :);
        matchedPoints2 = points(indexPairs(:, 2), :);
        
        % Estimate the Essential Matrix using RANSAC
        [E, inlierIdx] = estimateEssentialMatrix(matchedPoints1, matchedPoints2);
        
        % Get inlier points
        inlierPoints1 = matchedPoints1(inlierIdx, :);
        inlierPoints2 = matchedPoints2(inlierIdx, :);
        
        % Display the inlier correspondences
        annotatedFrame = insertShape(frame, 'Line', [inlierPoints1, inlierPoints2], 'Color', 'r');
        set(hImage, 'CData', annotatedFrame);
    end
    
    % Update the previous frame's features
    prevPoints = points;
    prevFeatures = points;
    
    drawnow; % Update the figure
end

% Stop the video acquisition and clean up
stop(vidObj);
delete(vidObj);
release(surfObj);
clear vidObj surfObj;
