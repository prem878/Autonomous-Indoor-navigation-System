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

% Create an empty array to store camera poses
cameraPoses = {};

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
        
        % Use the PnP algorithm to estimate the camera pose
        [worldOrientation, worldLocation] = estimateWorldCameraPose(matchedPoints1, matchedPoints2, cameraParams);
        
        % Create a camera pose object
        cameraPose = rigid3d(worldOrientation, worldLocation);
        cameraPoses{end + 1} = cameraPose;
        
        % Display the camera pose on the frame
        frameWithPose = insertCameraPose(frame, cameraPose, 'Size', 20);
        set(hImage, 'CData', frameWithPose);
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
