function S = myclassifier(im)
    % Preprecossing
    I = im2double(im2gray(im));
    % Filter in the fourier domain
    fourier = fftshift(fft2(I));
    fourier(160,211) = 0;
    fourier(157,204) = 0;
    fourier(166,225) = 0;
    fourier(169,232) = 0;
    filteredImage = ifft2(ifftshift(fourier)) + mean2(I);
    filteredImage = mat2gray(real(filteredImage));
    % Wiener filter gaussian noise
    denoiseImage = wiener2(filteredImage,[5,5]);
    % Thresholding
    eqDigits = histeq(denoiseImage);
    noisyDigits = eqDigits < 0.085;
    % Morphology
    disk1 = strel("disk",1);
    binaryImage = imerode(noisyDigits,disk1);
    binaryImage = imerode(binaryImage,disk1);
    binaryImage = imerode(binaryImage,disk1);
    binaryImage = imdilate(binaryImage,disk1);
    binaryImage = imdilate(binaryImage,disk1);
    % Area filtering
    BW2 = bwareafilt(binaryImage,[180 50000]);
    % Segmentation by cropping and splitting
    croppedDigits = crop_edges(BW2);
    digitThirds = split_image(croppedDigits,3);
    % Load templates
    imagefiles = dir('Templates/*.jpg');      
    nfiles = length(imagefiles);
    templates = cell(1,nfiles);
    yLen = 40;
    xLen = 25;
    for i=1:nfiles
       currentfilename = imagefiles(i).name;
       templates{1,i} = imread(currentfilename);
    end

    % Template matching
    digits=zeros(1,3);
    for i=1:3
        % Crop individual digit
        croppedDigit = crop_edges(digitThirds(:,:,i));
        % Scale digit
        scaledDigit = imresize(croppedDigit,[yLen xLen],'nearest');
        max_value=0;
        for l = 1:nfiles
            % Check is a valid digit for matching
            if sum(scaledDigit,'all')~=0
                % Find maximum correlation
                normx_corrmap=normxcorr2(scaledDigit,templates{1,l}); 
                current_max = max(normx_corrmap(:));
                if(current_max > max_value)
                    max_value=current_max;
                    digits(i)=map_digit(nfiles,l);
                end
            else
                % Guess if invalid
                digits(i)=randi([1,3],1);
            end
        end
    end
    S = digits;
    
end

