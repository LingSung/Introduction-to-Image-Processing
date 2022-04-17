clear all;
image_name = "Fig0441(a)(characters_test_pattern).tif";
image = imread(image_name);
[row, column] = size(image);
image = im2single(image);

subplot(1,3,1),imshow(image),title('original image');

D0 = 60;
sz = 1024;
H = GaussianHF(sz, sz, D0);
highpass_img60 = highpass_filter(image, H, sz);
subplot(1,3,2),imshow(highpass_img60),title('highpass image with cf=60');

D0 = 160;
sz = 1024;
H = GaussianHF(sz, sz, D0);
highpass_img160 = highpass_filter(image, H, sz);
subplot(1,3,3),imshow(highpass_img160),title('highpass image with cf=160');

function output_img = highpass_filter(img, H, sz)
    [row, column] = size(img);
    padding_img = zeros(sz, sz);
    img_DFT = zeros(sz, sz);
    output_DFT = zeros(sz, sz);
    output = zeros(sz, sz);
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
            padding_img(u,v) = padding_img(u,v) * (-1)^(u+v);
        end
    end

    %FFT
    for i = 1:1:sz
        img_DFT(i, :) = FFT(padding_img(i, :), sz, 0);
    end
    for j = 1:1:sz
        img_DFT(:, j) = FFT(img_DFT(:, j), sz, 0);
    end

    % filter function
    for u = 1:1:sz
        for v = 1:1:sz
            output_DFT(u,v) = img_DFT(u,v) * H(u,v);
        end
    end

    %IFFT
    for i = 1:1:sz
        output(i, :) = FFT(output_DFT(i, :), sz, 1);
    end
    for j = 1:1:sz
        output(:, j) = FFT(output(:, j), sz, 1);
    end
    output = real(output) / sz / sz; 
    % output = real(ifft2(output_DFT));
    
    for u = 1:1:sz
        for v = 1:1:sz
            output(u,v) = output(u,v) * (-1)^(u+v);
        end
    end

    output_img =  zeros(row, column);
    for u = 1:1:row
        for v = 1:1:column
            output_img(u,v) = output(u,v);
        end
    end  
    output_img = abs(output_img);
end

function H = GaussianHF(M, N, D0)
    H = zeros(M,N);
    for u = 1:1:M
        for v = 1:1:N
            H(u,v) = 1 - (exp((-1) * ((u-M/2)^2 + (v-N/2)^2) / (2*D0*D0)));
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
