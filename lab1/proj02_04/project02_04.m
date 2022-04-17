image_name = 'Fig0220(a)(chronometer 3692x2812  2pt25 inch 1250 dpi).tif';
output = imread(image_name);
subplot(1,2,1),imshow(output),title('original image');
[row, column] = size(output);
zoom_img = zeros(row, column);

R = floor(row/12.5);
C = floor(column/12.5);
shrink_img = zeros(R,C);
for i = 1:1:R
    for j = 1:1:C
        x = (i-1) * (row-1) / (R-1);
        y = (j-1) * (column-1) / (C-1);
        x1 = floor(x) + 1;
        x2 = ceil(x) + 1;
        y1 = floor(y) + 1;
        y2 = ceil(y) + 1;
        a = x + 1 - x1;
        b = y + 1 - y1;
        shrink_img(i,j) = (1-a) * ((1-b)*output(x1,y1) + b*output(x1,y2)) + a * ((1-b)*output(x2,y1) + b*output(x2,y2));
    end
end


for i = 1:1:row
    for j = 1:1:column
        x = (i-1) * (R-1) / (row-1);
        y = (j-1) * (C-1) / (column-1);
        x1 = floor(x) + 1;
        x2 = ceil(x) + 1;
        y1 = floor(y) + 1;
        y2 = ceil(y) + 1;
        a = x + 1 - x1;
        b = y + 1 - y1;
        zoom_img(i,j) = (1-a) * ((1-b)*shrink_img(x1,y1) + b*shrink_img(x1,y2)) + a * ((1-b)*shrink_img(x2,y1) + b*shrink_img(x2,y2));
    end
end

img_resized=uint8(zoom_img);
subplot(1,2,2),imshow(img_resized),title('zoom/shrink using bilinear interpolation');




