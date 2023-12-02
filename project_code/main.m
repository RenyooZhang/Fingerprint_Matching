close all, clear all;

I = imread("img\1_0.jpg");

% 图像预处理
I = Pretreat(I);

% 基础特征提取
[front_mask, dir_map, frequency_map] = GetFeatureMap(I, window_size, step);

% 基于基础特征的Gabor增强
I = GaborEnhance(front_mask, dir_map, frequency_map, I, window_size, step);

% 细节点提取算法
[end_map, cross_map, end_direction, cross_direction] = GetPoint(I);
[point_list, len] = List(end_map, cross_map, end_direction, cross_direction);

% 细节点匹配（匹配库细节点）
score = GetMatchScore(point_list, len);

% 输出分数