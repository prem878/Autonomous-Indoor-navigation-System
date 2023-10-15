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

% Create variables to store the map and camera poses
mapPoints = pointCloud([0, 0, 0]);
cameraPoses = rigid3d;

while ishandle(hImage)
    % Capture a frame from the webcam
    frame = getsnapshot(vidObj);
    
    % Convert the frame to grayscale for feature extraction
    grayFrame = rgb2gray(frame);
    
    % Detect SURF features
    points = step(surfObj, grayFrame);
    
    % Add the newly detected points to the map
    mapPoints = pcmerge(mapPoints, pointCloud(points.Location, 'Color', frame));
    
    % Try to detect loop closures
    if size(cameraPoses, 2) > 1 % Need at least two camera poses for loop closure
        % Perform feature matching between the current frame and previous frames
        indexPairs = matchFeatures(points, mapPoints);
        
        if ~isempty(indexPairs)
            % Estimate relative pose with a previous frame
            [relativeOrientation, relativeLocation] = estimateRelativeCameraPose(indexPairs, points, mapPoints, cameraParams);
            
            % If a loop closure is detected, update the camera poses
            if isLoopClosureDetected(relativeOrientation, relativeLocation)
                % Update the camera pose
                relativePose = rigid3d(relativeOrientation, relativeLocation);
                cameraPoses = [cameraPoses, relativePose];
                
                % Update the point cloud with the new camera pose
                mapPoints = pcmerge(mapPoints, pointCloud(points.Location, 'Color', frame), relativePose);
            end
        end
    end
    
    % Display the point cloud and camera pose
    pcshow(mapPoints, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down', 'MarkerSize', 30);
    showCamera(cameraPoses, 'Parent', gca);
    
    % Update the figure
    set(hImage, 'CData', frame);
    drawnow;
end

% Stop the video acquisition and clean up
stop(vidObj);
delete(vidObj);
release(surfObj);
clear vidObj surfObj;

% Function to detect loop closure (simplified for demonstration)
function isClosure = isLoopClosureDetected(~, ~)
    % You can implement more advanced criteria for loop closure detection here
    % For example, check if the relative pose is consistent with a previously visited location.
    isClosure = false; % Implement your logic here
end
