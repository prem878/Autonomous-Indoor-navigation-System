# Autonomous-Indoor-navigation-System
Algorithm for a Autonomous  Indoor navigation System of a drone in indoor environment implemented using MATLAB.
Implementing Simultaneous Localization and Mapping (SLAM) using a webcam in MATLAB can be a
complex task, as it involves computer vision techniques, feature extraction, and sensor fusion.
However, I can provide you with a high-level overview of the steps involved. Keep in mind that the
actual implementation details will depend on your specific requirements and the camera setup.
Here is a general outline of the process:
1. Image Acquisition: Use MATLAB's Image Acquisition Toolbox to capture frames from the webcam.
You can create a video object and specify the webcam as the video source.
2. Feature Extraction: Apply computer vision techniques to extract relevant features from the
acquired images. Commonly used feature extraction methods include corner detection (e.g., Harris
corners), scale-invariant feature transform (SIFT), or speeded-up robust features (SURF).
3. Feature Matching: Compare the extracted features between consecutive frames to establish
correspondences. Techniques like nearest neighbor matching or the RANSAC algorithm can be used
to robustly match the features.
4. Motion Estimation: Use the matched feature correspondences to estimate the camera's motion
between frames. There are different approaches for motion estimation, such as using the Essential
Matrix or the Fundamental Matrix. You can also use the 8-point algorithm or the RANSAC algorithm
to estimate the motion robustly.
5. Mapping: Combine the estimated camera motion with the known camera parameters to generate
a 3D map of the environment. This can be done by triangulating the matched feature points or using
a structure from motion (SfM) approach.
6. Localization: Use the generated map and the camera's current frame to estimate the camera's
pose (position and orientation) relative to the map. This step involves solving the Perspective-nPoint (PnP) problem or employing a bundle adjustment algorithm.
7. Loop Closure: Detect and handle loop closures to improve the accuracy of the estimated map and
camera poses. Loop closure refers to the detection of previously visited locations to correct
accumulated errors.
8. Visualization: Display the camera's estimated trajectory and the reconstructed map using
MATLAB's plotting or visualization capabilities.
