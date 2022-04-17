function output = bilinear_interpolation(img, R, C)
    [row, column] = size(img);
    output = zeros(R,C);
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
            output(i,j) = (1-a) * ((1-b)*img(x1,y1) + b*img(x1,y2)) + a * ((1-b)*img(x2,y1) + b*img(x2,y2));
        end
    end
end