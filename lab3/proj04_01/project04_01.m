clear all;
image_name = "Fig0431(d)(blown_ic_crop).tif";
image = imread(image_name);
[row, column] = size(image);
image = im2single(image);
subplot(3,3,1),imshow(image),title('original image');

sz = 2048;
padding_img = zeros(sz, sz);
for i = 1:1:sz
    for j = 1:1:sz
        if i <= row && j <= column
            padding_img(i,j) = image(i,j);
        else
            padding_img(i,j) = 0;
        end
    end
end
subplot(3,3,2),imshow(padding_img),title('padding image');

for u = 1:1:sz
    for v = 1:1:sz
        padding_img(u,v) = padding_img(u,v) * (-1)^(u+v);
    end
end
subplot(3,3,3),imshow(padding_img),title('padding image multiply by -1^(x+y)');

img_DFT = zeros(sz, sz);
%FFT
for i = 1:1:sz
    img_DFT(i, :) = FFT(padding_img(i, :), sz, 0);
end
for j = 1:1:sz
    img_DFT(:, j) = FFT(img_DFT(:, j), sz, 0);
end
subplot(3,3,4),imshow(uint8(abs(img_DFT))),title('spectrum of F');

D0 = 20;
H = GaussianLF(sz, sz, D0);
subplot(3,3,5),imshow(H),title('Center Gaussian lowpass filter');

G = H .* img_DFT;
subplot(3,3,6),imshow(G),title('spectrum of HF');

%IFFT
output = zeros(sz,sz);
for i = 1:1:sz
    output(i, :) = FFT(G(i, :), sz, 1);
end
for j = 1:1:sz
    output(:, j) = FFT(output(:, j), sz, 1);
end
output = real(output) / sz / sz; 
for u = 1:1:sz
    for v = 1:1:sz
        output(u,v) = output(u,v) * (-1)^(u+v);
    end
end
output = abs(output);
subplot(3,3,7),imshow(output),title('the IDFT of HF');

output_img =  zeros(row, column);
for u = 1:1:row
    for v = 1:1:column
        output_img(u,v) = output(u,v);
    end
end  
subplot(3,3,8),imshow(output_img),title('Final result');

function H = GaussianLF(M, N, D0)
    H = zeros(M,N);
    for u = 1:1:M
        for v = 1:1:N
            H(u,v) = exp((-1) * ((u-M/2)^2 + (v-N/2)^2) / (2*D0*D0));
        end
    end
end

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