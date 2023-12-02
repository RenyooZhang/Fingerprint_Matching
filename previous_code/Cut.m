function output_image = Cut(input_image)
    % 输入：1为底二值图
    % 输出：1为底二值图
    endpoint = cell(9, 1);
    endpoint{1} = [0,1,0; -1,1,-1; -1,-1,-1];
    endpoint{2} = [-1,-1,0; -1,1,1; -1,-1,0];
    endpoint{3} = [-1,-1,-1; -1,1,-1; 0,1,0];
    endpoint{4} = [0,-1,-1; 1,1,-1; 0,-1,-1];
    endpoint{5} = [1,-1,-1; -1,1,-1; -1,-1,-1];
    endpoint{6} = [-1,-1,1; -1,1,-1; -1,-1,-1];
    endpoint{7} = [-1,-1,-1; -1,1,-1; -1,-1,1];
    endpoint{8} = [-1,-1,-1; -1,1,-1; 1,-1,-1];
    endpoint{9} = [-1,-1,-1; -1,1,-1; -1,-1,-1];
    
    output_image = input_image;
    input_image = ~input_image;
    hit_map = zeros(size(input_image));

    for i = 1:9
        hit = bwhitmiss(input_image, endpoint{i});
        hit_map = hit_map | hit;
    end

    output_image = output_image + hit_map;

end

