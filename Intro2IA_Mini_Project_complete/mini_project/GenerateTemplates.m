function [] = GenerateTemplates()
%GENERATETEMPLATES
scale = [1,1.1,1.2,1.3];
[~,scaleNo] = size(scale); 
rotations=[-45,-30,-15,0,15,30,45];
[~,rotationNo] = size(rotations);
three = rgb2gray(imread('OriginalTemplates/3.jpg'));
four = rgb2gray(imread('OriginalTemplates/4.jpg'));
five = rgb2gray(imread('OriginalTemplates/5.jpg'));
oT = cell(1,3);
oT{1} = three;
oT{2} = four;
oT{3} = five;
for i=1:3
    for j=1:scaleNo
        for k=1:rotationNo
            out = oT{i};
            out = imresize(out,scale(j));
            out = imrotate(out, rotations(k));
            bounding = regionprops(out>50,'BoundingBox');
            out = imcrop(out,bounding(1).BoundingBox);
            fileName = sprintf('Templates/%d%d%d.jpg',i,j,k);
            imwrite(out,fileName);
        end
    end
end
end

