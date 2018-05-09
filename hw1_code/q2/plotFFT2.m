function plotFFT2(image,i,l)
	%this function plots 2D fft
	
    name ={'Laplacian','Gaussian'};
    level =['1','2','3','4','5'];
    %this function plots the 2D FFT
    image_fft = fft2(image);
    image_fft = fftshift(image_fft);
    image_fft_log = log(abs(image_fft+eps)); %avoid log(0) case
    %sv = sort(image_fft_log(:));  
    %minv = sv(1); maxv = sv(end);
    %minv = sv(round(0.005*numel(sv)));
    imagesc(image_fft_log, [0 5]),axis off, colormap jet, axis image
    colorbar
    title(['Level ',level(l),name(i),' Pyramid'], 'FontSize', 10);
end

