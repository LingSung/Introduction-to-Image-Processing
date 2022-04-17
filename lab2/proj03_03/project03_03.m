clear all;
image_name = "Fig0340(a)(dipxe_text).tif";
image = imread(image_name);

% show original image %
subplot(1,2,1),imshow(image),title('original image');

[row, column] = size(image);
mask = [1,1,1;1,1,1;1,1,1];
k = 10;
blur_image = spatial_filter(image, mask);
gmask = double(image) - blur_image;
high_boost_image = double(image) + k * gmask;
high_boost_image = uint8(high_boost_image);

% show result image %
subplot(1,2,2),imshow(high_boost_image),title('high-boost image');

function output = spatial_filter(image, mask)
    [row, column] = size(image);
    image = double(image);
    output = zeros(row, column);
    for i = 1:row
        for j = 1:column
            counter = 0;
            % start from the left-top of image 1
            if i-1 >= 1 & j-1 >=1
                output(i,j) = output(i,j) + image(i-1,j-1) * mask(3,3);
                counter = counter + 1;
            end
            % 4
            if j-1 >= 1 
                output(i,j) = output(i,j) + image(i,j-1) * mask(2,3);
                counter = counter + 1;
            end
            % 7
            if i+1 <= row & j-1 >= 1
                output(i,j) = output(i,j) + image(i+1,j-1) * mask(1,3);
                counter = counter + 1;
            end
            % 2
            if i-1 >= 1
                output(i,j) = output(i,j) + image(i-1,j) * mask(3,2);
                counter = counter + 1;
            end
            % 5
            output(i,j) = output(i,j) + image(i,j) * mask(2,2);
            counter = counter + 1;
            % 8
            if i+1 <= row
                output(i,j) = output(i,j) + image(i+1,j) * mask(1,2);
                counter = counter + 1;
            end
            % 3
            if i-1 >= 1 & j+1 <= column
                output(i,j) = output(i,j) + image(i-1,j+1) * mask(3,1);
                counter = counter + 1;
            end 
            % 6
            if j+1 <= column
                output(i,j) = output(i,j) + image(i,j+1) * mask(2,1);
                counter = counter + 1;
            end
            % 9
            if i+1 <= row & j+1 <= column
                output(i,j) = output(i,j) + image(i+1,j+1) * mask(1,1);
                counter = counter + 1;
            end
            output(i,j) = output(i,j) / counter;
        end
    end
end