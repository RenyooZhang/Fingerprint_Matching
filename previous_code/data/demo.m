clc;clear;close all;

ftitle1 = "1_1";
ftitle2 = "1_2";

img_dir = './img/';
mnt_dir = './mnt/';

img_format = '.tif';
mnt_format = '.txt';

%% load image
img1 = imread(fullfile(img_dir,ftitle1+img_format));
img2 = imread(fullfile(img_dir,ftitle2+img_format));

%% load minutiae
minu1 = LoadNeuFeature(fullfile(mnt_dir,ftitle1+mnt_format)); % [x, y, theta] for n points
minu2 = LoadNeuFeature(fullfile(mnt_dir,ftitle2+mnt_format));

%% show minutiae on image 
fig = figure(1);
imshow(img1);
% only use x and y
DrawMinu(fig,minu1(:,1:2));

fig = figure(2);
imshow(img1);
% use x y theta
DrawMinu(fig,minu1(:,1:3));

%% load minutiae pair
pair = load(fullfile(mnt_dir,strcat(ftitle1, '-', ftitle2, '.mat'))).pairs;
matched_pts1 = minu1(pair(:,1),1:2);
matched_pts2 = minu2(pair(:,2),1:2);

%% show pairs
% show in form of image pairs
figure(3);
showMatchedFeatures(img1, img2, matched_pts1, matched_pts2, 'montage');

% Project points from the first set to the second set
tform = estimateGeometricTransform(matched_pts1, matched_pts2, 'Similarity');
projected_pts1 = transformPointsForward(tform, matched_pts1);
% show in form of reprojection
fig=figure(4);
backgound = 255*ones(size(img1));
imshow(backgound);
DrawMinu(fig,projected_pts1,'b');
hold on;
DrawMinu(fig,matched_pts2,'r');