function [end_map, cross_map] = Detect(input_image)
    % 输入：1为底（白底）二值图
    % 输出：end_map, cross_map，0为底
    end_kernel = cell(8, 1);
    end_kernel{1} = [2, 0, 0; 0, 2, 0; 0, 0, 0] - 1;
    end_kernel{2} = [0, 2, 0; 0, 2, 0; 0, 0, 0] - 1;
    end_kernel{3} = [0, 0, 2; 0, 2, 0; 0, 0, 0] - 1;
    end_kernel{4} = [0, 0, 0; 2, 2, 0; 0, 0, 0] - 1;    
    end_kernel{5} = [0, 0, 0; 0, 2, 2; 0, 0, 0] - 1;
    end_kernel{6} = [0, 0, 0; 0, 2, 0; 2, 0, 0] - 1;
    end_kernel{7} = [0, 0, 0; 0, 2, 0; 0, 2, 0] - 1;
    end_kernel{8} = [0, 0, 0; 0, 2, 0; 0, 0, 2] - 1;

    cross_kernel = zeros(9, 56);
    cross_k = zeros(3, 3, 56);
    updated = zeros(56);
    id = [1, 2, 3, 6, 9, 8, 7, 4];
    cross_kernel(:, 1) = -[-1, 1, -1, 1, -1, 1, 1, 1, -1];
    cross_kernel(:, 9) = -[-1, 1, -1, 1, -1, 1, 1, -1, 1];
    cross_kernel(:, 17) = -[-1, 1, -1, -1, -1, 1, 1, 1, -1];
    cross_kernel(:, 25) = -[-1, 1, 1, -1, -1, -1, 1, -1, 1];
    cross_kernel(:, 33) = -[-1, 1, -1, -1, -1, -1, 1, -1, 1];
    cross_kernel(:, 41) = -[-1, 1, -1, 1, -1, 1, -1, -1, -1];
    cross_kernel(:, 49) = -[-1, 1, -1, -1, -1, 1, 1, -1, -1];
    updated(1) = 1;
    updated(9) = 1;
    updated(17) = 1;
    updated(25) = 1;
    updated(33) = 1;
    updated(41) = 1;
    updated(49) = 1;
    
    for i = 1:56
        if ~updated(i)
            for j = 1:8
                cross_kernel(id(j), i) = cross_kernel(id(mod(j, 8) + 1), i-1);
                cross_kernel(5, i) = 1;
            end
        end
        updated(i) = 1;
        cross_k(:, :, i) = reshape(cross_kernel(:, i), [3,3]);
    end

    [I_X, I_Y] = size(input_image);
    end_map = zeros(I_X, I_Y);
    cross_map = zeros(I_X, I_Y);

    input_image = ~input_image;

    hit1 = zeros(I_X, I_Y, 8);
    hit2 = zeros(I_X, I_Y, 56);

    for i = 1:8
        hit1(:, :, i) = bwhitmiss(input_image, end_kernel{i});
        end_map = end_map | hit1(:, :, i);
    end

    for i = 1:56
        hit2(:, :, i) = bwhitmiss(input_image, cross_k(:, :, i));
        cross_map = cross_map | hit2(:, :, i);
    end
end

