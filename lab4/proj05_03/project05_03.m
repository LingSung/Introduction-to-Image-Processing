clear all;
image_name = "Fig0526(a)(original_DIP).tif";
image = imread(image_name);
%[row, column] = size(image);
subplot(2,3,1),imshow(image),title('original image');
row = 512;
column = 512;
sz = 512;
image = im2double(image);
image = bilinear_interpolation(image, row, column);
noise = zeros(row, column);

A = 0.8;
u0 = row/4 - 1;
v0 = column/4 - 1;

for i = 1:1:row
    for j = 1:1:column
        noise(i,j) = A * sin(2*pi*(u0*i/row + v0*j/column));
    end
end

sin_noise_image = image + noise;
subplot(2,3,2),imshow(sin_noise_image),title('sinusoidal noises image');

for i = 1:1:row
    for j = 1:1:column
        sin_noise_image(i,j) = sin_noise_image(i,j) * ((-1) ^ (i+j));
    end
end

%FFT
DFT_image = zeros(sz, sz);
for i = 1:1:sz
    DFT_image(i, :) = FFT(sin_noise_image(i, :), sz, 0);
end
for j = 1:1:sz
    DFT_image(:, j) = FFT(DFT_image(:, j), sz, 0);
end
%DFT_image = fft2(sin_noise_image);

subplot(2,3,3),imshow(uint8(abs(DFT_image))),title('frequency domain image');
Notch_filter = zeros(row, column);
D0 = 50;
for i = 1:1:row
    for j = 1:1:column
        d1 = sqrt((i-row/2-u0)^2 + (j-column/2-v0)^2);
        d2 = sqrt((i-row/2+u0)^2 + (j-column/2+v0)^2);
        if d1 <= D0 || d2 <= D0
            Notch_filter(i,j) = 0;
        else
            Notch_filter(i,j) = 1;
        end
    end
end
subplot(2,3,4),imshow(Notch_filter),title('notch filter');

after_filter = DFT_image .* Notch_filter;
subplot(2,3,5),imshow(uint8(abs(after_filter))),title('frequency domain result');

%IFFT
result = zeros(sz,sz);
for i = 1:1:sz
    result(i, :) = FFT(after_filter(i, :), sz, 1);
end
for j = 1:1:sz
    result(:, j) = FFT(result(:, j), sz, 1);
end
result = real(result) / sz / sz; 
%result = ifft2(after_filter);
for i = 1:1:row
    for j = 1:1:column
        result(i,j) = result(i,j) * ((-1) ^ (i+j));
    end
end
subplot(2,3,6),imshow(result),title('spatial domain result');
