function out = templatematch(original,template)
    % Based on the approach outlined
    %https://stackoverflow.com/questions/32664481/matlab-template-matching-using-fft
    ox = size(original, 2); 
    oy = size(original, 1);
    f_o = fft2(original);
    % Scale for cross-power spectrum calculation
    f_t = fft2(template, oy, ox); 
    % Calculate cross-power spectrum
    out = real(ifft2((f_o.*conj(f_t))./abs(f_o.*f_t),'symmetric')); 
end
