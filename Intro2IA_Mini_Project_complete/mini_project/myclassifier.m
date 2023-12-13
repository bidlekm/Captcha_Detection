function S = myclassifier(im)
    I = im2double(im2gray(im));
    fourier = fftshift(fft2(I));
    fourier(160,211) = 0;
    fourier(157,204) = 0;
    fourier(166,225) = 0;
    fourier(169,232) = 0;
    filteredImage = ifft2(ifftshift(fourier)) + mean2(I);
    filteredImage = mat2gray(real(filteredImage));
    denoiseImage = wiener2(filteredImage,[10,10]);
    eqDigits = histeq(denoiseImage);
    noisyDigits = eqDigits < 0.07;
    disk1 = strel("disk",1);
    disk2 = strel("disk",2);
    binaryImage = imerode(noisyDigits,disk1);
    binaryImage = imerode(binaryImage,disk1);
    binaryImage = imerode(binaryImage,disk1);
    %figure();
    %imshow(binaryImage);
    BW2 = bwareafilt(binaryImage,[300 50000]);
    BW2 = imdilate(BW2,disk1);
    BW2 = imdilate(BW2,disk1);
    BW2 = imdilate(BW2,disk1);
    croppedDigits = crop_edges(BW2);
    %figure();
    %imshow(croppedDigits);
    digitThirds = split_image(croppedDigits,3);

    %Load templates
    imagefiles = dir('Templates/*.jpg');      
    nfiles = length(imagefiles);
    templates = cell(1,nfiles);
    %yLen = 26;
    %xLen = 16;
    yLen = 40;
    xLen = 25;
    %Find best template match
    for i=1:nfiles
       currentfilename = imagefiles(i).name;
       templates{1,i} = imread(currentfilename);
    end
    digits=zeros(1,3);
    bestCell = cell(1,3);
    for i=1:3
        croppedDigit = crop_edges(digitThirds(:,:,i));
        scaledDigit = imresize(croppedDigit,[yLen xLen],'nearest');
        %figure();
        %imshow(scaledDigit);
        max_value=0;
        for l = 1:nfiles
            normx_corrmap=normxcorr2(scaledDigit,templates{1,l}); 
            current_max = max(normx_corrmap(:));
            %correlation_map = template_match(scaledDigit,templates{1,l});
            %current_max = min(correlation_map,[],'all');
            if(current_max > max_value)
                max_value=current_max;
                digits(i)=map_digit(nfiles,l);
                bestCell{1,i} = templates{1,l};
            end
        end
    end
    % figure();
    % imshow(bestCell{1,1})
    % figure();
    % imshow(bestCell{1,2})
    % figure();
    % imshow(bestCell{1,3})
    S = digits;
    
end

