function [] = generate_templates()
%GENERATETEMPLATES
rotations=linspace(-45,45,7);
[~,rotationNo] = size(rotations);
three = rgb2gray(imread('OriginalTemplates/3.jpg'));
four = rgb2gray(imread('OriginalTemplates/4.jpg'));
five = rgb2gray(imread('OriginalTemplates/5.jpg'));
oT = cell(1,3);
oT{1} = three;
oT{2} = four;
oT{3} = five;
for i=1:3
    for k=1:rotationNo
        out = oT{i};
        out = imrotate(out, rotations(k))>50;
        out = crop_edges(out);
        out = imresize(out, [40 25],'nearest');
        fileName = sprintf('Templates/%d%d.jpg',i,k);
        imwrite(out,fileName);
    end
end
end

