% Create a video input object with the webcam as the video source
vidObj = videoinput('winvideo', 1, 'RGB24'); % 'winvideo' for Windows platform, 'RGB24' for 24-bit color

% Set the video input parameters (you may adjust these as needed)
set(vidObj, 'FramesPerTrigger', 1); % Capture one frame at a time
set(vidObj, 'TriggerRepeat', Inf);   % Capture frames until you stop the acquisition
set(vidObj, 'ReturnedColorSpace', 'rgb'); % Specify the color space

% Start the video acquisition
start(vidObj);

% Create a figure to display the webcam feed
figure;
hImage = imshow(zeros(480, 640, 3)); % Adjust the size as needed

while ishandle(hImage)
    % Capture a frame from the webcam
    frame = getsnapshot(vidObj);
    
    % Display the captured frame in the figure
    set(hImage, 'CData', frame);
    
    % You can process the frame here, e.g., detect objects or apply filters
    
    drawnow; % Update the figure
end

% Stop the video acquisition and clean up
stop(vidObj);
delete(vidObj);
clear vidObj;
