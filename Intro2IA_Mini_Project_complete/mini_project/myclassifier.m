function S = myclassifier(im,Mdl)
    I = im2double(im2gray(im));
    % imshow(I)
    %Filter structured noise in fourier domain
    fourier = fftshift(fft2(I));
    fourier(160,211) = 0;
    fourier(157,204) = 0;
    fourier(166,225) = 0;
    fourier(169,232) = 0;
    filteredImage = ifft2(ifftshift(fourier)) + mean2(I);
    filteredImage = mat2gray(real(filteredImage));
    % imshow(filteredImage)
    noisyDigits = filteredImage < 0.60;
    % imshow(noisyDigits)
    
    disk1 = strel("disk",1);
    disk2 = strel("disk",2);
    binaryImage = imerode(noisyDigits,disk1);
    %binaryImage = imdilate(binaryImage,disk1);
    binaryImage = imerode(binaryImage,disk1);
    BW2 = bwareafilt(binaryImage,[120 50000]);
    
    % imshow(BW2)
    
    stats = regionprops(BW2, 'basic');
    allBoundingBoxes = cat(1, stats.BoundingBox);
    areas = [stats.Area];
    [~, idx] = sort(areas, 'descend');
    sortedBoundingBoxes = allBoundingBoxes(idx, :);
    desiredSize  = 3;
    if(size(allBoundingBoxes,1)< 3)
        desiredSize  = size(allBoundingBoxes);
    end
    boxes_to_keep = sortedBoundingBoxes(1:desiredSize , :);
    xMin = min(boxes_to_keep(:, 1));
    yMin = min(boxes_to_keep(:, 2));
    xMax = 0;
    yMax =0;
    [nBoxes,~] = size(boxes_to_keep);
    for q=1:nBoxes
        if boxes_to_keep(q,1)+boxes_to_keep(q,3) > xMax
            xMax=boxes_to_keep(q,1)+boxes_to_keep(q,3);
        end
        if boxes_to_keep(q,2)+boxes_to_keep(q,4) > yMax
            yMax=boxes_to_keep(q,2)+boxes_to_keep(q,4);
        end
    end
    % Get the minimum bounding box that encloses all objects
    enclosingBox = [xMin,yMin,xMax-xMin,yMax-yMin];
    % Crop the binary image using the enclosing bounding box
    croppedDigits = imcrop(BW2, enclosingBox);
    %Split to thirds
    digitThirds = split_image(croppedDigits,3)*255;
    %Load templates
    %imagefiles = dir('Templates/*.jpg');      
    %nfiles = length(imagefiles);
    %templates = cell(1,nfiles);
    %for i=1:nfiles
    %   currentfilename = imagefiles(i).name;
    %   currentimage = imread(currentfilename);
    %   templates{1,i} = currentimage;
    %end 
    %Find best template match
    digits = zeros(1,3);
    % Uncomment digits 2 to see templates that were matched
    %digits2 = zeros(1,3);
    for i=1:3
        croppedDigit = crop_edges(digitThirds(:,:,i));
        % Uncomment below for debugging to see digits being matched to templates
        % figure();
        % imshow(croppedDigit);
        % Fix scaling
        scaledDigit = imresize(croppedDigit,[60 120]);
        flatDigit = reshape(scaledDigit.',1,[]);
        %for l = 1:nfiles
        digits(i)=predict(Mdl,flatDigit);
            %correlation_map = template_match(greyDigit,templates{1,l});
            %current_max = max(correlation_map,[],'all');
            %if(current_max > max_value)
            %    max_value=current_max;
            %    digits(i)=map_digit(nfiles,l);
            %    %digits2(i)=l
            %end
        %end
    end
    S = digits;
end

