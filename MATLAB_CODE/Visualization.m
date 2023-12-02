% Create a video input object with the webcam as the video source
vidObj = videoinput('winvideo', 1, 'RGB24'); % 'winvideo' for Windows platform, 'RGB24' for 24-bit color

% Set the video input parameters
set(vidObj, 'FramesPerTrigger', 1);
set(vidObj, 'TriggerRepeat', Inf);
set(vidObj, 'ReturnedColorSpace', 'rgb');

% Start the video acquisition
start(vidObj);

% Create a figure to display the webcam feed and visualization
figure;
hImage = imshow(zeros(480, 640, 3)); % Adjust the size as needed

% Create a point cloud object to store the map
mapPoints = pointCloud([0, 0, 0]);

% Create variables to store the camera poses
cameraPoses = rigid3d;

while ishandle(hImage)
    % Capture a frame from the webcam
    frame = getsnapshot(vidObj);
    
    % Display the current frame
    set(hImage, 'CData', frame);
    
    % Try to detect loop closures and update cameraPoses and mapPoints
    
    % Visualize the reconstructed map and camera trajectory
    pcshow(mapPoints, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down', 'MarkerSize', 30);
    hold on;
    
    % Visualize camera poses
    showCamera(cameraPoses, 'Parent', gca, 'Size', 0.1);
    
    % Connect camera poses to form the trajectory
    if numel(cameraPoses) > 1
        trajectory = [cameraPoses.AbsolutePose];
        plot3(trajectory(1, :), trajectory(2, :), trajectory(3, :), 'g-', 'LineWidth', 2);
    end
    
    hold off;
    drawnow;
end

% Stop the video acquisition and clean up
stop(vidObj);
delete(vidObj);

% Release any other resources used
% Release mapPoints and other resources

% Clear variables
clear vidObj mapPoints cameraPoses;
% Author 
   Chilumula.Prem Kumar.
%
