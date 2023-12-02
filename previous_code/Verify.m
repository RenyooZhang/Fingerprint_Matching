function [end_map, cross_map] = Verify(front_mask, A_end_map, A_cross_map)

    [X_A, Y_A] = size(front_mask);
    se = strel('disk', 30);
    mask = zeros(X_A, Y_A);
    mask(2 : X_A - 1, 2 : Y_A - 1) = ones(X_A - 2, Y_A - 2);
    mask_erode = mask .* front_mask;
    mask_erode = imerode(mask_erode, se);
    
    end_map = A_end_map .* mask_erode;
    cross_map = A_cross_map .* mask_erode;
end