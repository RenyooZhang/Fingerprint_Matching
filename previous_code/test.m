% 这是用来做调试的草稿纸

list1 = [0, 0, 0, 0; 0, 0, 5, 0; 0, 1, 1, 0];
list2 = [0, 1, 1, 0; 0, 5, 4, 0; 0, 3, 8, 4];
% [dx, dy, dtheta] = GetTrans(1, 2, 1, 2, list1, list2)
% list1_transed = Trans(list1, 2, dx, dy, dtheta)
% [match_list1, match_list2] = FindMatchIndex(list1_transed, list2, 2, 2)
[dx, dy, dtheta, match_index1, match_index2, match_list1_transed] = Match(list1, list2, 3, 3)

function [dx, dy, dtheta, match_index1, match_index2, match_list1_transed] = Match(list1, list2, len1, len2)
    max_total_match = 0;
    E = 2;          % 最大容许的误差
    for i1 = 1 : len1 - 1
        for j1 = i1 + 1 : len1
            for i2 = 1 : len2 - 1
                for j2 = i2 + 1 : len2
                    % 保证类型一致
                    if list1(i1, 1) ~= list2(i2, 1) || list1(j1, 1) ~= list2(j2, 1)
                        continue;
                    end
                    % 保证距离一致
                    d1 = double(GetD(i1, j1, list1));
                    d2 = double(GetD(i2, j2, list2));
                    if abs(d1 - d2) > E
                        continue;
                    end
                    % 计算变换参数
                    [tx, ty, ttheta] = GetTrans(i1, j1, i2, j2, list1, list2);
                    % 对list1做变换
                    list1_transed = Trans(list1, len1, tx, ty, ttheta);
                    % 计算list1_transed，list2的匹配点数，并更新
                    [match_list1, match_list2] = FindMatchIndex(list1_transed, list2, len1, len2);
                    % 更新输出参数
                    total_match = length(match_list2);
                    if total_match > max_total_match
                        max_total_match = total_match;
                        dx = tx;
                        dy = ty;
                        dtheta = ttheta;
                        match_index1 = match_list1;
                        match_index2 = match_list2;
                        match_list1_transed = list1_transed;
                    end
                end
            end
        end
    end
end

function d = GetD(p1, p2, list)
    x_p1 = list(p1, 2);
    y_p1 = list(p1, 3);
    x_p2 = list(p2, 2);
    y_p2 = list(p2, 3);
    d = (x_p1 - x_p2) ^ 2 + (y_p1 - y_p2) ^ 2;
end

function [dx, dy, dtheta] = GetTrans(i1, j1, i2, j2, list1, list2)
    x_i1 = list1(i1, 2);
    y_i1 = list1(i1, 3);
    x_i2 = list2(i2, 2);
    y_i2 = list2(i2, 3);
    x_j1 = list1(j1, 2);
    y_j1 = list1(j1, 3);
    x_j2 = list2(j2, 2);
    y_j2 = list2(j2, 3);
    alpha1 = atan2(y_j1 - y_i1, x_j1 - x_i1);
    alpha2 = atan2(y_j2 - y_i2, x_j2 - x_i2);
    dtheta = alpha2 - alpha1;
    dx = x_i2 - (x_i1 * cos(dtheta) - y_i1 * sin(dtheta));
    dy = y_i2 - (x_i1 * sin(dtheta) + y_i1 * cos(dtheta));
end

% 对一个list的特征点做刚体变换
function list_transed = Trans(list, len, dx, dy, dtheta)
    list_transed = zeros(len, 4);
    for i = 1 : len
        list_transed(i, 1) = list(i, 1);
        list_transed(i, 2) = int16(list(i, 2) * cos(dtheta) - list(i, 3) * sin(dtheta) + dx);
        list_transed(i, 3) = int16(list(i, 2) * sin(dtheta) + list(i, 3) * cos(dtheta) + dy);
        list_transed(i, 4) = list(i, 4) + dtheta;
    end
end

% 
function [match_list1, match_list2] = FindMatchIndex(list1, list2, len1, len2)
    temp_match_list1 = 1 : len1;
    temp_match_list2 = 1 : len2;
    top = 1;
    for i = 1 : len1
        for j = 1 : len2
            if list1(i, 1) == list2(j, 1) && abs(list1(i, 2) - list2(j, 2)) < 2 && abs(list1(i, 3) - list2(j, 3)) < 2 && abs(list1(i, 4) - list2(j, 4)) < 1
                a = abs(list1(i, 4) - list2(j, 4));
                temp_match_list1(top) = i;
                temp_match_list2(top) = j;
                top = top + 1;
            end
        end
    end
    match_list1 = temp_match_list1(1 : top - 1);
    match_list2 = temp_match_list2(1 : top - 1);
end