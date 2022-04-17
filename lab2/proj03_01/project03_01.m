clear all;
image_name = "Fig0308(a)(fractured_spine).tif";
image = imread(image_name);

% show original image %
subplot(3,3,1),imshow(image),title('original image');

[row, column] = size(image);

% log transformation %
c = 1;
log_trans_image = zeros(row, column);
for i = 1:1:row
    for j = 1:1:column
        r = double(1 + image(i,j));
        log_trans_image(i,j) = c * log10(r);
    end
end
log_trans_image = uint8(255 * mat2gray(log_trans_image));
% show log transformation image %
subplot(3,3,2),imshow(log_trans_image),title('log transformation image');

% power-law transformation %
c = 1;

gamma = 0.1;
power_law_trans_image1 = power_law_transformation(image, gamma, c);
power_law_trans_image1 = uint8(255 * mat2gray(power_law_trans_image1));
subplot(3,3,4),imshow(power_law_trans_image1),title('power-law transformation image r = 0.1');

gamma = 0.3;
power_law_trans_image2 = power_law_transformation(image, gamma, c);
power_law_trans_image2 = uint8(255 * mat2gray(power_law_trans_image2));
subplot(3,3,5),imshow(power_law_trans_image2),title('power-law transformation image r = 0.3');

gamma = 0.7;
power_law_trans_image3 = power_law_transformation(image, gamma, c);
power_law_trans_image3 = uint8(255 * mat2gray(power_law_trans_image3));
subplot(3,3,6),imshow(power_law_trans_image3),title('power-law transformation image r = 0.7');

gamma = 2.0;
power_law_trans_image4 = power_law_transformation(image, gamma, c);
power_law_trans_image4 = uint8(255 * mat2gray(power_law_trans_image4));
subplot(3,3,7),imshow(power_law_trans_image4),title('power-law transformation image r = 2.0');

gamma = 7.0;
power_law_trans_image5 = power_law_transformation(image, gamma, c);
power_law_trans_image5 = uint8(255 * mat2gray(power_law_trans_image5));
subplot(3,3,8),imshow(power_law_trans_image5),title('power-law transformation image r = 7.0');

gamma = 12.5;
power_law_trans_image6 = power_law_transformation(image, gamma, c);
power_law_trans_image6 = uint8(255 * mat2gray(power_law_trans_image6));
subplot(3,3,9),imshow(power_law_trans_image6),title('power-law transformation image r = 12.5');

function output = power_law_transformation(img, gamma, c)
    [row, column] = size(img);
    e = 1;
    output = zeros(row, column);
    for i = 1:1:row
        for j = 1:1:column
            r = double(img(i,j));
            if r == 0
                output(i,j) = c * (e ^ gamma);
            else
                output(i,j) = c * (r ^ gamma);
            end
        end
    end
end

