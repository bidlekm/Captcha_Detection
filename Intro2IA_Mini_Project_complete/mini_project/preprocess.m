clc;clear;

%I = im2double(im2gray(imread("Train/captcha_0654.png")));

%fourier = fftshift(fft2(I));
%fourier2 = fftshift(fft2(I));
%imagesc(log(abs(fourier)))
%absFourier = abs(fourier);
%maxValue = max(absFourier(:));
%thresh_val = 0.01 * maxValue;
%mask = absFourier < thresh_val;
%fourierFilt = fourier .* mask;
%fourier(160,211) = mean(fourier,'all');
%fourier(157,204) = mean(fourier,'all');
%fourier(166,225) = mean(fourier,'all');
%fourier(169,232) = mean(fourier,'all');
%fourier2(160,211) = 0;
%fourier2(157,204) = 0;
%fourier2(166,225) = 0;
%fourier2(169,232) = 0;
%filteredImage = ifft2(ifftshift(fourier)) + mean2(I);
%filteredImage = mat2gray(real(filteredImage));
%filteredImage2 = ifft2(ifftshift(fourier2)) + mean2(I);
%filteredImage2 = mat2gray(real(filteredImage2));
% imshow(fourier)
% % crop = filteredImage(1:100, 1:100); imshow(crop); cropHist = imhist(crop);
% % J = imgaussfilt(filteredImage,4);
% % imshow(J);
%X1 = EM_DenoiseTV(filteredImage,0.2);

%X2 =  histeq(X1);
%absJ = abs(X1);
%maxValueJ = max(absJ(:));
%binaryImage = X2 < 0.09;

SE = strel("disk",2);
% for i = 1:2
%     binaryImage = imerode(binaryImage,SE);
% end
original = X2
binaryImage = imerode(original,SE);

figure;
subplot(1, 2, 1);
imshow(filteredImage);
title('original');

subplot(1, 2, 2);
imshow(binaryImage);
title('filtered');
