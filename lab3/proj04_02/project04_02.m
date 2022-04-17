clear all;
image_name = "Fig0441(a)(characters_test_pattern).tif";
image = imread(image_name);
[row, column] = size(image);
img = im2single(image);

sum = 0;
sz = 1024;
padding_img = zeros(sz,sz);
img_DFT = zeros(sz,sz);

for i = 1:1:sz
    for j = 1:1:sz
        if i <= row && j <= column
            padding_img(i,j) = img(i,j);
        else
            padding_img(i,j) = 0;
        end
    end
end
for u = 1:1:sz
    for v = 1:1:sz
        sum = sum + padding_img(u,v);
    end
end
for u = 1:1:sz
    for v = 1:1:sz
        padding_img(u,v) = padding_img(u,v) * (-1)^(u+v);
    end
end
image_mean = sum / sz / sz;

%FFT
for i = 1:1:sz
    img_DFT(i, :) = FFT(padding_img(i, :), sz, 0);
end
for j = 1:1:sz
    img_DFT(:, j) = FFT(img_DFT(:, j), sz, 0);
end

DFT_mean = img_DFT(sz/2+1, sz/2+1) / sz / sz;
img_DFT = uint8(abs(img_DFT));
subplot(1,2,1),imshow(image),title('original image');
subplot(1,2,2),imshow(img_DFT),title('Fourier spectrum');

disp({'image_mean: ', num2str(image_mean)});
disp({'DFT_mean: ', num2str(DFT_mean)});

function output = FFT(f, sz, inst)
    % bit reverse
    arr = zeros(1, sz);
    for i = 1:1:sz
        arr(i) = bi2de( fliplr( de2bi(i-1 , log2(sz)) )) + 1;
        % disp(arr(i));
    end

    % ---------------start FFT--------------------%
    %---------------------------------------------%
    % the result of each layer
    checkpoint = zeros(1, sz);
    temp = zeros(1, sz);
    for i = 1:1:sz
        checkpoint(i) = f(arr(i));
    end
    % how many numbers in a group
    partition = 2;
    % total layers
    layers = log2(sz);
    for rnd = 1:1:layers
        % how many groups to calculate
        time = sz / partition;
        for i = 1:1:time
            % tackle with the cross part
            pos_neg = partition / 2;
            for j = 1:1:pos_neg
                if inst == 0
                    temp((i-1)*partition + j) = checkpoint((i-1)*partition + j) + checkpoint((i-1)*partition + j + pos_neg) * exp((-1j)*2*pi*(j-1)/partition);
                    temp((i-1)*partition + j + pos_neg) = checkpoint((i-1)*partition + j) - checkpoint((i-1)*partition + j + pos_neg) * exp((-1j)*2*pi*(j-1)/partition);
                else
                    temp((i-1)*partition + j) = checkpoint((i-1)*partition + j) + checkpoint((i-1)*partition + j + pos_neg) * exp(1j*2*pi*(j-1)/partition);
                    temp((i-1)*partition + j + pos_neg) = checkpoint((i-1)*partition + j) - checkpoint((i-1)*partition + j + pos_neg) * exp(1j*2*pi*(j-1)/partition);
                end
            end

        end
        checkpoint = temp;
        partition = partition * 2;
    end
    output = checkpoint;

end
