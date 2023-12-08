function [subImages] = split_vector(image, sub_size)
    [rows, cols] = size(image);
    sub_width = floor(cols / sub_size);
    subImages = zeros(rows, sub_width, sub_size);

    for j = 1:sub_size
        col_start = (j - 1) * sub_width + 1;
        col_end = min(j * sub_width, cols);
        subImages(:, :, j) = image(:, col_start:col_end);
    end
end