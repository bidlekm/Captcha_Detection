function [subImages] = split_vector(image,sub_size)
% Get the size of the original image
[rows, cols] = size(image);

% Initialize a cell array to store sub-images
num_across = ceil(rows / sub_size);
num_down = ceil(cols / sub_size);
subImages = cell(num_across,num_down);
% Extract sub-images using cell array
for i = 1:num_across-1
    for j = 1:num_down-1
        subImages{i,j} = image((i-1)*sub_size + 1 : i*sub_size, (j-1)*sub_size+ 1 : j*sub_size, :);
    end
end
%fill in edges???

end

