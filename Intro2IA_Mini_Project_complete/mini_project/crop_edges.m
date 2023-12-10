function [cropped] = crop_edges(im)
    %crop_edges
    stats = regionprops(im, 'BoundingBox');
    allBoundingBoxes = cat(1, stats.BoundingBox);
    xMin = min(allBoundingBoxes(:, 1));
    yMin = min(allBoundingBoxes(:, 2));
    xMax = 0;
    yMax =0;
    [nBoxes,~] = size(allBoundingBoxes);
    for q=1:nBoxes
        if allBoundingBoxes(q,1)+allBoundingBoxes(q,3) > xMax
            xMax=allBoundingBoxes(q,1)+allBoundingBoxes(q,3);
        end
        if allBoundingBoxes(q,2)+allBoundingBoxes(q,4) > yMax
            yMax=allBoundingBoxes(q,2)+allBoundingBoxes(q,4);
        end
    end
    % Get the minimum bounding box that encloses all objects
    enclosingBox = [xMin,yMin,xMax-xMin,yMax-yMin];
    % Crop the binary image using the enclosing bounding box
    cropped = imcrop(im, enclosingBox);
end

