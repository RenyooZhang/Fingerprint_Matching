function output_image = bbpf(input_image, D0, W, n)
    % 输入：二值图像input_image, 中心频率D0，频带宽度W，滤波器阶次n
    % 输出：二值图
    [M, N] = size(input_image);
    P = max(2 * [M N]);             % Padding size. 
    H = filter(D0, W, n, P);

    F = fftshift(fft2(input_image, P, P));
    G = F .* H;
    g = real(ifft2(ifftshift(G)));
    output_image = g(1:M, 1:N);
end

function H = filter(D0, W, n, M)
    % Create a Butterworth band pass filter
    [DX, DY] = meshgrid(1:M);
    D = sqrt((DX-M/2-1).^2+(DY-M/2-1).^2);
    H = 1./(1+((D.^2-D0^2)./(D*W+eps)).^(2*n));
end