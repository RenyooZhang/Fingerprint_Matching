close all, clear all;

I1 = imread("data\img\2_1.tif");
I2 = imread("data\img\1_2.tif");
I1 = im2double(I1);
I2 = im2double(I2);

% 得到特征点
[list1, len1] = GetPoint(I1);
[list2, len2] = GetPoint(I2);


% %% 给好的特征点
% ftitle1 = "2_1";
% ftitle2 = "1_2";
% 
% img_dir = './img/';
% mnt_dir = './mnt/';
% 
% img_format = '.tif';
% mnt_format = '.txt';
% 
% I1 = imread(fullfile(img_dir,ftitle1+img_format));
% I2 = imread(fullfile(img_dir,ftitle2+img_format));
% 
% list1 = LoadNeuFeature(fullfile(mnt_dir,ftitle1+mnt_format));
% ze1 = zeros(size(list1, 1), 1);
% len1 = length(ze1);
% list1 = [ze1, list1];
% list1(:, [2, 3]) = list1(:, [3, 2]);
% list1(:, 4) = list1(:, 4) * pi / 180;
% 
% list2 = LoadNeuFeature(fullfile(mnt_dir,ftitle2+mnt_format));
% ze2 = zeros(size(list2, 1), 1);
% len2 = length(ze2);
% list2 = [ze2, list2];
% list2(:, [2, 3]) = list2(:, [3, 2]);
% list2(:, 4) = list2(:, 4) * pi / 180;


%% 特征点匹配
[dx, dy, dtheta, match_index1, match_index2, match_list1_transed] = Match(list1, list2, len1, len2);

% 可视化预处理
minu1 = list1;
minu1(:, [2, 3]) = minu1(:, [3, 2]); 
minu1(:, 4) = minu1(:, 4) * 180 / pi;
minu2 = list2;
minu2(:, [2, 3]) = minu2(:, [3, 2]);
minu2(:, 4) = minu2(:, 4) * 180 / pi;

%% show minutiae on image 
% only use x and y
fig = figure(1);
imshow(I1);
DrawMinu(fig, minu1(:,2:3));
saveas(1, '4_no_dir_given.png');
% use x y theta
fig = figure(2);
imshow(I1);
DrawMinu(fig,minu1(:,2:4));
saveas(2, '4_dir_given.png');

%% show pairs
pair = [match_index1', match_index2'];
matched_pts1 = minu1(pair(:,1),2:3);
matched_pts2 = minu2(pair(:,2),2:3);

% show in form of image pairs
figure(3);
showMatchedFeatures(I1, I2, matched_pts1, matched_pts2, 'montage');
saveas(3, '4_match_given.png');

% Project points from the first set to the second set
tform = estimateGeometricTransform(matched_pts1, matched_pts2, 'Similarity');
projected_pts1 = transformPointsForward(tform, matched_pts1);
% show in form of reprojection
fig=figure(4);
backgound = 255*ones(size(I1));
imshow(backgound);
DrawMinu(fig,projected_pts1,'b');
hold on;
DrawMinu(fig,matched_pts2,'r');
saveas(4, '4_match_point_given.png');
