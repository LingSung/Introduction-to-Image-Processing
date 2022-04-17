clear all;
image_name = "Fig0308(a)(fractured_spine).tif";
image = imread(image_name);

% show original image %
subplot(2,3,1),imshow(image),title('original image');

[row, column] = size(image);
MN = row * column;
r = zeros(256);
x = 0:255;

% calculate rk
for i = 1:1:row
    for j = 1:1:column
        temp = double(image(i,j)) + 1;
        r(temp) = r(temp) + 1;
    end
end

% calculate the pk (possibility of rk)
p = zeros(256);
p = r/MN;
subplot(2,3,2), plot(x,p),title('original histogram');

% calculate sk
s = zeros(256);
round_s = zeros(256);
for i = 1:1:256
    if i == 1
        s(i) = 255 * p(i);
    else
        s(i) = s(i-1) + 255 * p(i);
    end
    round_s(i) = round(s(i));
end
subplot(2,3,3),stairs(x,round_s),title('original transformation function');

global_mean = 0;
global_variance = 0;
image = double(image);
 
% calculate the global mean
for i = 1:1:256
    global_mean = global_mean + (i-1) * p(i);
end

% calculate the global variance
for i = 1:1:256
    global_variance = global_variance + ((i-1)-global_mean) * ((i-1)-global_mean) * p(i);
end

% calculate the local mean & variance
local_mean = zeros(row, column);
local_variance = zeros(row, column);
for i = 1:row
    for j = 1:column
        % calculate the local mean
        if i-1 >= 1
            local_mean(i,j) = local_mean(i,j) + image(i-1,j) / 8;
            if j-1 >= 1
                local_mean(i,j) = local_mean(i,j) + image(i-1,j-1) / 8; 
            end
            if j+1 <= column
                local_mean(i,j) = local_mean(i,j) + image(i-1,j+1) / 8; 
            end
        end
        if i+1 <= row
            local_mean(i,j) = local_mean(i,j) + image(i+1,j) / 8;
            if j-1 >= 1
                local_mean(i,j) = local_mean(i,j) + image(i+1,j-1) / 8; 
            end
            if j+1 <= column
                local_mean(i,j) = local_mean(i,j) + image(i+1,j+1) / 8; 
            end
        end
        if j+1 <= column
            local_mean(i,j) = local_mean(i,j) + image(i,j+1) / 8;
        end
        if j-1 >= 1
            local_mean(i,j) = local_mean(i,j) + image(i,j-1) / 8;
        end

        % calculate the local variance
        if i-1 >= 1
            local_variance(i,j) = local_variance(i,j) + (image(i-1,j)-local_mean(i,j)) * (image(i-1,j)-local_mean(i,j)) / 8;
            if j-1 >= 1
                local_variance(i,j) = local_variance(i,j) + (image(i-1,j-1)-local_mean(i,j)) * (image(i-1,j-1)-local_mean(i,j)) / 8; 
            end
            if j+1 <= column
                local_variance(i,j) = local_variance(i,j) + (image(i-1,j+1)-local_mean(i,j)) * (image(i-1,j+1)-local_mean(i,j)) / 8; 
            end
        end
        if i+1 <= row
            local_variance(i,j) = local_variance(i,j) + (image(i+1,j)-local_mean(i,j)) * (image(i+1,j)-local_mean(i,j)) / 8;
            if j-1 >= 1
                local_variance(i,j) = local_variance(i,j) + (image(i+1,j-1)-local_mean(i,j)) * (image(i+1,j-1)-local_mean(i,j)) / 8; 
            end
            if j+1 <= column
                local_variance(i,j) = local_variance(i,j) + (image(i+1,j+1)-local_mean(i,j)) * (image(i+1,j+1)-local_mean(i,j)) / 8; 
            end
        end
        if j+1 <= column
            local_variance(i,j) = local_variance(i,j) + (image(i,j+1)-local_mean(i,j)) * (image(i,j+1)-local_mean(i,j)) / 8;
        end
        if j-1 >= 1
            local_variance(i,j) = local_variance(i,j) + (image(i,j-1)-local_mean(i,j)) * (image(i,j-1)-local_mean(i,j)) / 8;
        end

    end
end

% enhancement image
enhancement_img = zeros(row, column);
k0 = 0;
k1 = 1.3;
k2 = 0;
k3 = 1.5;
C = 7;
for i = 1:row
    for j = 1:column
        mean_left = k0 * global_mean;
        mean_right = k1 * global_mean;
        variance_left = k2 * global_variance;
        variance_right = k3 * global_variance;
        if ((mean_left <= local_mean(i,j)) & (local_mean(i,j) <= mean_right) & (variance_left <= local_variance(i,j)) & (local_variance(i,j) <= variance_right))
            enhancement_img(i,j) = C * image(i,j);
        else
            enhancement_img(i,j) = image(i,j);
        end
    end
end
enhancement_img = uint8(enhancement_img);
subplot(2,3,4),imshow(enhancement_img),title('enhancement image');

enhance_r = zeros(256);
% calculate rk
for i = 1:1:row
    for j = 1:1:column
        temp = double(enhancement_img(i,j)) + 1;
        enhance_r(temp) = enhance_r(temp) + 1;
    end
end

% calculate the pk (possibility of rk)
enhance_p = zeros(256);
enhance_p = enhance_r/MN;
subplot(2,3,5), plot(x,enhance_p),title('enhancement image histogram');




