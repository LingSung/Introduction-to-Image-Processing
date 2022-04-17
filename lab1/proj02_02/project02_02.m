clear all;
image_name = 'Fig0221(a)(ctskull-256).tif';
image = imread(image_name);
figure (1);
imshow(image);
title('original image');

image = double(image);
figure(2);

% intensity level = 2 
level = 2;
output_level2 = Intensity_level(image, level);
subplot(2,4,1),imshow(output_level2, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 4 
level = 4;
output_level4 = Intensity_level(image, level);
subplot(2,4,2),imshow(output_level4, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 8 
level = 8;
output_level8 = Intensity_level(image, level);
subplot(2,4,3),imshow(output_level8, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 16 
level = 16;
output_level16 = Intensity_level(image, level);
subplot(2,4,4),imshow(output_level16, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 32 
level = 32;
output_level32 = Intensity_level(image, level);
subplot(2,4,5),imshow(output_level32, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 64 
level = 64;
output_level64 = Intensity_level(image, level);
subplot(2,4,6),imshow(output_level64, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 128 
level = 128;
output_level128 = Intensity_level(image, level);
subplot(2,4,7),imshow(output_level128, [0,level-1]), title(['level = ', num2str(level)]);

% intensity level = 256 
level = 256;
output_level256 = Intensity_level(image, level);
subplot(2,4,8),imshow(output_level256, [0,level-1]), title(['level = ', num2str(level)]);



function output = Intensity_level(img, level)
    level = 256 / level;
    [row, column] = size(img);
    output = zeros(row, column);
    for i = 1:1:row
        for j = 1:1:column
            output(i,j) = floor((img(i,j)/level));
        end
    end
end