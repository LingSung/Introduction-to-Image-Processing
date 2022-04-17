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