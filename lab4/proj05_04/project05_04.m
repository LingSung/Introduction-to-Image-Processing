clear all;
image_name = "Fig0526(a)(original_DIP).tif";
image = imread(image_name);
%[row, column] = size(image);
subplot(2,3,1),imshow(image),title('original image');
image = im2double(image);
bilinear_image = bilinear_interpolation(image, 512, 512);
row = 512;
column = 512;
sz = 512;
blur_filter = zeros(row,column);
a = 0.1;
b = 0.1;
T = 1;
for i = 1:1:row
    for j = 1:1:column
        temp = a*i + b*j;
        blur_filter(i,j) = T/(pi*temp) * sin(pi*temp) * exp(-1j*pi*temp);
    end
end
%FFT
DFT_image = zeros(sz, sz);
for i = 1:1:sz
    DFT_image(i, :) = FFT(image(i, :), sz, 0);
end
for j = 1:1:sz
    DFT_image(:, j) = FFT(DFT_image(:, j), sz, 0);
end
%DFT_image = fft2(image);
blur_image = DFT_image .* blur_filter;

%IFFT
blur_result = zeros(sz,sz);
for i = 1:1:sz
    blur_result(i, :) = FFT(blur_image(i, :), sz, 1);
end
for j = 1:1:sz
    blur_result(:, j) = FFT(blur_result(:, j), sz, 1);
end
blur_result = real(blur_result) / sz / sz; 
%blur_image = ifft2(blur_image);
%blur_image = real(blur_image);

subplot(2,3,2),imshow(blur_result, []),title('blur image');

mu = 0;
sigma = sqrt(10/256/256);
random = randn(row,column);
gaussian_noise = mu + (random*sigma);
gaussian_image = blur_result + gaussian_noise;
subplot(2,3,3),imshow(gaussian_image, []),title('gaussian noise image');

%src = fft2(image);
%FFT 
src = zeros(sz, sz);
for i = 1:1:sz
    src(i, :) = FFT(image(i, :), sz, 0);
end
for j = 1:1:sz
    src(:, j) = FFT(src(:, j), sz, 0);
end

%degradation = fft2(gaussian_image);
%FFT
degradation = zeros(sz, sz);
for i = 1:1:sz
    degradation(i, :) = FFT(gaussian_image(i, :), sz, 0);
end
for j = 1:1:sz
    degradation(:, j) = FFT(degradation(:, j), sz, 0);
end

H = degradation ./ src;
wiener_image = zeros(row,column);

K = 0.001;
for u = 1:1:row
    for v = 1:1:column
        wiener_image(u,v) = 1/H(u,v)*(abs(H(u,v)))^2/((abs(H(u,v)))^2+K)*degradation(u,v);
    end
end
%wiener_image = ifft2(wiener_image);
%IFFT
result = zeros(sz,sz);
for i = 1:1:sz
    result(i, :) = FFT(wiener_image(i, :), sz, 1);
end
for j = 1:1:sz
    result(:, j) = FFT(result(:, j), sz, 1);
end
result = real(result) / sz / sz; 
%wiener_image = abs(wiener_image);
subplot(2,3,4),imshow(result),title('wiener image K=0.001');

K = 0.0001;
for u = 1:1:row
    for v = 1:1:column
        wiener_image(u,v) = 1/H(u,v)*(abs(H(u,v)))^2/((abs(H(u,v)))^2+K)*degradation(u,v);
    end
end
%IFFT
result = zeros(sz,sz);
for i = 1:1:sz
    result(i, :) = FFT(wiener_image(i, :), sz, 1);
end
for j = 1:1:sz
    result(:, j) = FFT(result(:, j), sz, 1);
end
result = real(result) / sz / sz;
%wiener_image = ifft2(wiener_image);
%wiener_image = abs(wiener_image);
subplot(2,3,5),imshow(result),title('wiener image K=0.0001');

K = 0.00001;
for u = 1:1:row
    for v = 1:1:column
        wiener_image(u,v) = 1/H(u,v)*(abs(H(u,v)))^2/((abs(H(u,v)))^2+K)*degradation(u,v);
    end
end
%IFFT
result = zeros(sz,sz);
for i = 1:1:sz
    result(i, :) = FFT(wiener_image(i, :), sz, 1);
end
for j = 1:1:sz
    result(:, j) = FFT(result(:, j), sz, 1);
end
result = real(result) / sz / sz;
%wiener_image = ifft2(wiener_image);
%wiener_image = abs(wiener_image);
subplot(2,3,6),imshow(result),title('wiener image K=0.00001');
