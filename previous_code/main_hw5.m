close all, clear all;

% --图像载入---------------------------------------
A = imread("data\img\1_1.tif");
A = im2double(A);
A = imadjust(A);
[X_A, Y_A] = size(A);
figure(1), imshow(A);

% --图像增强----------------------------------------
% 先锐化一下
h1 = fspecial('log', 5, 0.5);                   %大小为5，sigma=0.5的LOG算子 
A = A - imfilter(A, h1, 'corr', 'replicate'); 
figure(2), imshow(A);

% 将指纹前景分离出来
[front_mask, front_binary] = Front(A);

% 巴特沃斯滤波，针对指纹频率的带通
front_binary = bbpf(front_binary, 90, 50, 1);
front_binary = imbinarize(front_binary, 0.07);
front_binary = ~(front_binary .* front_mask);

% 开闭操作
se = strel('square', 2);
% front_binary = imerode(front_binary, se);
front_binary = imopen(front_binary, se);

figure(3), imshow(front_binary);

% --检测预处理------------------------------------
% 细化操作
A_thinned = Thinning(~front_binary);
figure(4), imshow(A_thinned);

% imwrite(A_thinned, "12_thinned.png");
% A_thinned = imread("12_thinned.png");

% 修剪毛刺
A_cut = A_thinned;
for i = 1:3
    A_cut = Cut(A_cut);
end

% --细节点检测--------------------------------------
% 细节点标注
[A_end_map, A_cross_map] = Detect(A_cut);
figure(5), imshow(A_cut);
hold on;
for i = 1 : X_A
    for j = 1 : Y_A
        if A_end_map(i, j) == 1
            rectangle('Position', [j - 1, i - 1, 3, 3], 'LineWidth', 1, 'EdgeColor', 'r');
        elseif A_cross_map(i, j) == 1
            rectangle('Position', [j - 1, i - 1, 3, 3], 'LineWidth', 1, 'EdgeColor', 'b');
        end
    end
end

% 细节点验证（去除边缘虚假细节点）
[A_end_map, A_cross_map] = Verify(front_mask, A_end_map, A_cross_map);
figure(6), imshow(A_cut);
hold on;
for i = 1 : X_A
    for j = 1 : Y_A
        if A_end_map(i, j) == 1
            rectangle('Position', [j - 1, i - 1, 3, 3], 'LineWidth', 1, 'EdgeColor', 'r');
        elseif A_cross_map(i, j) == 1
            rectangle('Position', [j - 1, i - 1, 3, 3], 'LineWidth', 1, 'EdgeColor', 'b');
        end
    end
end

% 画方向
[end_direction, cross_direction] = Direction(A_end_map, A_cross_map, A_cut);
for i = 1 : X_A
    for j = 1 : Y_A
        if A_end_map(i, j) == 1
            theta = end_direction(i, j);
            r = 10;
            x = int16(r * cos(theta));
            y = int16(r * sin(theta));
            line([j j + x], [i i - y], 'Color', 'red', 'LineWidth', 1);
        elseif A_cross_map(i, j) == 1
            theta = cross_direction(i, j);
            r = 10;
            x = int16(r * cos(theta));
            y = int16(r * sin(theta));            
            line([j j + x], [i i - y], 'Color', 'blue', 'LineWidth', 1);
        end
    end
end
    