% Create a video input object with the webcam as the video source
vidObj = videoinput('winvideo', 1, 'RGB24'); % 'winvideo' for Windows platform, 'RGB24' for 24-bit color

% Set the video input parameters
set(vidObj, 'FramesPerTrigger', 1);
set(vidObj, 'TriggerRepeat', Inf);
set(vidObj, 'ReturnedColorSpace', 'rgb');

% Start the video acquisition
start(vidObj);

% Create an empty cell array to store camera poses and point cloud data
cameraPoses = {};
pointCloud = pointCloud([0, 0, 0]); % Initialize an empty point cloud

% Create a figure to display the webcam feed
figure;
hImage = imshow(zeros(480, 640, 3)); % Adjust the size as needed

% Create a SURF object for feature extraction
surfObj = vision.SURF('MetricThreshold', 500); % Adjust the metric threshold as needed

% Initialize variables to store the previous frame's features
prevPoints = [];
prevFeatures = [];

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
        
        % Use the Essential Matrix and camera parameters to estimate camera poses
        [R, t] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);
        
        % Update the camera poses and point cloud
        cameraPose = rigid3d(R, t);
        cameraPoses{end + 1} = cameraPose;
        
        % Triangulate inlier points to generate a 3D point cloud
        worldPoints = triangulate(inlierPoints1, inlierPoints2, cameraParams, cameraParams);
        pointCloud = pcmerge(pointCloud, pointCloud(worldPoints, 'Color', frame));
        
        % Display the 3D point cloud
        pcshow(pointCloud);
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
