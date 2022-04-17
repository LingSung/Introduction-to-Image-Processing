clear all;
image_name = "Fig0503 (original_pattern).tif";

image = imread(image_name);
[row, column] = size(image);
sp_image = image;
image = im2double(image);

subplot(1,3,1),imshow(image),title('original image');

mu = 0;
sigma = 0.15;
random = randn(row,column);
gaussian_noise = mu + (random*sigma);
gn_image = image + gaussian_noise;
subplot(1,3,2),imshow(gn_image, []),title('gaussian noise image');

random_list = randperm(row*column);
white = floor(0.04 * row * column);
black = floor(0.04 * row * column);
white_idx = 0;
black_idx = 0;

for i = 1:1:row*column
    temp = random_list(i)-1;
    r = floor(temp/column) + 1;
    c = mod(temp,column) + 1;
    if  white_idx < white 
        sp_image(r,c) = 255;
        white_idx = white_idx + 1;
    elseif black_idx < black
        sp_image(r,c) = 0;
        black_idx = black_idx + 1;
    else
        break
    end
end

subplot(1,3,3),imshow(sp_image),title('salt & pepper noise image');
