function out = template_match(original,template)
    % Based on the approach outlined
    %https://stackoverflow.com/questions/32664481/matlab-template-matching-using-fft

    template = imresize(template, size(original));
    % Compute the 2D FFT of the images
    fft_image1 = fft2(original);
    fft_image2 = fft2(template);
    
    % Compute the cross power spectrum
    cross_power_spectrum = fft_image1 .* conj(fft_image2);
    
    % Compute the inverse FFT to obtain the cross-correlation
    cross_correlation = ifft2(cross_power_spectrum);
    out = abs(cross_correlation);
end
