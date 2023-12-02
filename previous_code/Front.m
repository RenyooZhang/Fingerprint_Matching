function [front_mask, front_binary] = Front(input_image)
    % 输入：double图像
    % 输出：front_mask以0为底（黑底，前景为1），front_binary以1为底（白底）
    
    [mask1, mask2] = FindFingerprint(input_image, 32, 8);
    I = im2double(input_image) .* 255 .* mask1;

    % 区域直方图均衡
    % mex CLocalHistEq.c
    % I = imresize(CLocalHistEq(I), size(I));

    I = uint8(mask2 .* 255 + I);

    % 高斯平滑
    % I = imgaussfilt(I, 0.5);

    binary_image = imbinarize(I, 0.7);

    front_mask = mask1;
    front_binary = ~binary_image;
end

function [output_image1, output_image2] = FindFingerprint(input_image, WINDOW_SIZE, STEP)

    source = im2double(input_image);            % 预处理
    [I_X, I_Y] = size(source);                  % 得到尺寸大小
    
    max_val = zeros(int16((I_X - WINDOW_SIZE) / STEP), int16((I_Y - WINDOW_SIZE) / STEP));
    max_row = zeros(int16((I_X - WINDOW_SIZE) / STEP), int16((I_Y - WINDOW_SIZE) / STEP));
    max_col = zeros(int16((I_X - WINDOW_SIZE) / STEP), int16((I_Y - WINDOW_SIZE) / STEP));
    
    for i = 1 : int16((I_X - WINDOW_SIZE) / STEP)
        for j = 1 : int16((I_Y - WINDOW_SIZE) / STEP)
    
            % 截取window
            beginx = 1 + (i - 1) * STEP;
            beginy = 1 + (j - 1) * STEP;
            window = source(beginx : beginx + WINDOW_SIZE, beginy : beginy + WINDOW_SIZE);
    
            % 处理频谱
            fft_window = fftshift(fft2(window));                % 频谱
            abs_fft_window = abs(fft_window);                   % 幅度谱
            [freqmap_x, freqmap_y] = size(abs_fft_window);      % 幅度谱尺寸
            freq_midx = int16(freqmap_x / 2);
            freq_midy = int16(freqmap_y / 2);
            abs_fft_window(freq_midx, freq_midy) = 0;           % 幅度谱直流分量置为0
    
            % 计算幅度、频率、角度
            [max_val(i, j), max_idx] = max(abs_fft_window(:));                    % 最大幅度值
            [max_row(i, j), max_col(i, j)] = ind2sub(size(abs_fft_window), max_idx);    % 最大幅度位置，代表了最大频率

        end
    end
    
    % % 方向图（法线向）
    % kx = (max_row - double(freq_midx));
    % ky = (max_col - double(freq_midy));
    % direction_map = atan2(ky, kx);

    % 频率图
    d = sqrt((max_row - 17) .^ 2 + (max_col - 17 ) .^ 2);
    frequency_map = 2 .* d;
    
    % 条件控制，前景mask
    condition1 = 30 < max_val;
    condition2 = 5 < frequency_map;
    
    partition_map = double(condition1 & condition2);
    output_image1 = imresize(partition_map, [I_X, I_Y], "nearest");
    output_image1 = imfill(output_image1);                              % 空的地方要补起来
    output_image2 = ones(I_X, I_Y) - output_image1;
end


