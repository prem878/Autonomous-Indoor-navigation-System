% Load two example frames (you should replace these with frames from your video source)
frame1 = imread('frame1.png');
frame2 = imread('frame2.png');

% Convert frames to grayscale for feature extraction
grayFrame1 = rgb2gray(frame1);
grayFrame2 = rgb2gray(frame2);

% Detect and extract features from both frames (e.g., using SURF)
surfObj = vision.SURF('MetricThreshold', 1000); % Adjust the threshold as needed

points1 = step(surfObj, grayFrame1);
points2 = step(surfObj, grayFrame2);

% Perform nearest neighbor matching
indexPairs = matchFeatures(points1, points2);

% Get the matched points from both frames
matchedPoints1 = points1(indexPairs(:, 1), :);
matchedPoints2 = points2(indexPairs(:, 2), :);

% Use the RANSAC algorithm for robust feature matching
[tform, inlierIdx] = estimateGeometricTransform(...
    matchedPoints1, matchedPoints2, 'affine', 'MaxNumTrials', 2000, 'MaxDistance', 10);

% Filter out the inlier points
inlierPoints1 = matchedPoints1(inlierIdx, :);
inlierPoints2 = matchedPoints2(inlierIdx, :);

% Visualize the correspondences
figure;
showMatchedFeatures(grayFrame1, grayFrame2, inlierPoints1, inlierPoints2, 'montage');
title('Inlier correspondences');

% Display the number of inlier correspondences
numInliers = size(inlierPoints1, 1);
disp(['Number of inlier correspondences: ', num2str(numInliers)]);
% Load two example frames (you should replace these with frames from your video source)
frame1 = imread('frame1.png');
frame2 = imread('frame2.png');

% Convert frames to grayscale for feature extraction
grayFrame1 = rgb2gray(frame1);
grayFrame2 = rgb2gray(frame2);

% Detect and extract features from both frames (e.g., using SURF)
surfObj = vision.SURF('MetricThreshold', 1000); % Adjust the threshold as needed

points1 = step(surfObj, grayFrame1);
points2 = step(surfObj, grayFrame2);

% Perform nearest neighbor matching
indexPairs = matchFeatures(points1, points2);

% Get the matched points from both frames
matchedPoints1 = points1(indexPairs(:, 1), :);
matchedPoints2 = points2(indexPairs(:, 2), :);

% Use the RANSAC algorithm for robust feature matching
[tform, inlierIdx] = estimateGeometricTransform(...
    matchedPoints1, matchedPoints2, 'affine', 'MaxNumTrials', 2000, 'MaxDistance', 10);

% Filter out the inlier points
inlierPoints1 = matchedPoints1(inlierIdx, :);
inlierPoints2 = matchedPoints2(inlierIdx, :);

% Visualize the correspondences
figure;
showMatchedFeatures(grayFrame1, grayFrame2, inlierPoints1, inlierPoints2, 'montage');
title('Inlier correspondences');

% Display the number of inlier correspondences
numInliers = size(inlierPoints1, 1);
disp(['Number of inlier correspondences: ', num2str(numInliers)]);
