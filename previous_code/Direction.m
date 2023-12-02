function [end_dire, cross_dire] = Direction(end_map, cross_map, input_image)
    % 输入：end_map, cross_map, input_image
    % 输出：对应的方向图，弧度输出
    [I_X, I_Y] = size(input_image);
    end_dire = zeros(I_X, I_Y);
    cross_dire = zeros(I_X, I_Y);
    for i = 1 : I_X
        for j = 1 : I_Y
            if end_map(i, j) == 1
                EXTEND_SIZE = 5;
                while 1
                    % 提取周围形态
                    window = input_image(i - EXTEND_SIZE : i + EXTEND_SIZE, j - EXTEND_SIZE : j + EXTEND_SIZE);
                    mark = zeros(1 + 2 * EXTEND_SIZE, 1 + 2 * EXTEND_SIZE);
                    mark(1 + EXTEND_SIZE, 1 + EXTEND_SIZE) = 1;
                    window = imreconstruct(mark, 1 - window);
                    % 计算方向向量
                    mask = ones(1 + 2 * EXTEND_SIZE, 1 + 2 * EXTEND_SIZE);
                    mask(2 : 2 * EXTEND_SIZE, 2 : 2 * EXTEND_SIZE) = zeros(2 * EXTEND_SIZE - 1, 2 * EXTEND_SIZE - 1);
                    verify_matrix = mask .* window;
                    if length(find(verify_matrix == 1))  ~= 1
                        EXTEND_SIZE = EXTEND_SIZE - 1;
                        continue;
                    else
                        [x, y] = find(verify_matrix == 1);
                        Y = - x + EXTEND_SIZE + 1;
                        X = y - EXTEND_SIZE - 1;
                        end_dire(i, j) = atan2(Y, X);
                        break;
                    end
                end
            elseif cross_map(i, j) == 1
                EXTEND_SIZE = 5;
                while 1
                    % 提取周围形态
                    window = input_image(i - EXTEND_SIZE : i + EXTEND_SIZE, j - EXTEND_SIZE : j + EXTEND_SIZE);
                    mark = zeros(1 + 2 * EXTEND_SIZE, 1 + 2 * EXTEND_SIZE);
                    mark(1 + EXTEND_SIZE, 1 + EXTEND_SIZE) = 1;
                    window = imreconstruct(mark, 1 - window);
                    % 计算方向向量
                    mask = ones(1 + 2 * EXTEND_SIZE, 1 + 2 * EXTEND_SIZE);
                    mask(2 : 2 * EXTEND_SIZE, 2 : 2 * EXTEND_SIZE) = zeros(2 * EXTEND_SIZE - 1, 2 * EXTEND_SIZE - 1);
                    verify_matrix = mask .* window;
                    if length(find(verify_matrix == 1))  ~= 3
                        EXTEND_SIZE = EXTEND_SIZE - 1;
                        continue;
                    else
                        [x, y] = find(verify_matrix == 1);
                        Y = - x + EXTEND_SIZE + 1;
                        X = y - EXTEND_SIZE - 1;
                        dire = atan2(Y, X);
                        differ(1) = abs(dire(1) - dire(2));
                        differ(2) = abs(dire(2) - dire(3));
                        differ(3) = abs(dire(3) - dire(1));
                        [~, index] = min(differ);
                        cross_dire(i, j) = 0.5 * (dire(index) + dire(mod(index, 3) + 1));
                        break;
                    end
                end
            end
        end
    end
    % % 转成角度输出，适配DrawDir函数
    % end_dire = rad2deg(end_dire);
    % cross_dire = rad2deg(cross_dire);
end

