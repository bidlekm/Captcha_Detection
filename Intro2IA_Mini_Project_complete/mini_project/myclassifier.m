function S = myclassifier(im)
    I = im2double(im2gray(im));
    %Filter structured noise in fourier domain
    fourier = fftshift(fft2(I));
    fourier(160,211) = 0;
    fourier(157,204) = 0;
    fourier(166,225) = 0;
    fourier(169,232) = 0;
    filteredImage = ifft2(ifftshift(fourier)) + mean2(I);
    filteredImage = mat2gray(real(filteredImage));
    blurred = imgaussfilt(filteredImage,2);
    noisyDigits = blurred < 0.65;
    % Remove gaussian noise using energy minimisation
    % Limit to 1000 as unnecessary to go further
    %eMin = EM_DenoiseTV(filteredImage,0.2, @(varargin) disp(''),20);
    %eMinEq =  histeq(eMin);
    %Threshold for digits
    %noisyDigits = eMinEq < 0.09;
    %Remove lines using morphology
    disk = strel("disk",1);
    binaryImage = imerode(noisyDigits,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imerode(binaryImage,disk);
    binaryImage = imdilate(binaryImage,disk);
    binaryImage = imdilate(binaryImage,disk);
    %Crop to just digits
    croppedDigits = crop_edges(binaryImage);
    %Split to thirds
    digitThirds = split_image(croppedDigits,3);
    %Load templates
    imagefiles = dir('Templates/*.jpg');      
    nfiles = length(imagefiles);
    templates = cell(1,nfiles);
    for i=1:nfiles
       currentfilename = imagefiles(i).name;
       currentimage = imread(currentfilename);
       templates{1,i} = currentimage;
    end 
    %Find best template match
    digits = zeros(1,3);
    % Uncomment digits 2 to see templates that were matched
    %digits2 = zeros(1,3);
    for i=1:3
        croppedDigit = crop_edges(digitThirds(:,:,i));
        % Uncomment below for debugging to see digits being matched to templates
         figure();
         imshow(croppedDigit);
        greyDigit = croppedDigit*255;
        max_value=0;
        for l = 1:nfiles
            correlation_map = template_match(greyDigit,templates{1,l});
            current_max = max(correlation_map,[],'all');
            if(current_max > max_value)
                max_value=current_max;
                digits(i)=map_digit(nfiles,l);
                %digits2(i)=l
            end
        end
    end
    S = digits;
end

