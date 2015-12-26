clear all;
close all;
[x] = textread('Lena128x128g_8bits.dat','%s');
y = bin2dec(x);

img = uint8(reshape(y, [128 128]))';

img1=zeros(size(img));
% kernel = [0 0 0 ;0 1 0;0 0 0]; % Delta 
kernel = [1 1 1 ;1 0 1;1 1 1]*1/8; % Blur 
% kernel = [-1 0 1;-2 0 2;-1 0 1]*1/8; % Sobel-X
% kernel = [-1 -2 -1;0 0 0;1 2 1]*1/8; % Sobel-Y
% kernel = [0 -1 0; -1 4 -1; 0 -1 0]*1/4; % Laplacian
for i=2:size(img,1)-1
    for j=2:size(img,2)-1
        tmp1 = double(img(i-1:i+1,j-1:j+1));
        X=tmp1.*(kernel);
        img1(i+1,j) = sum(X(:));
    end
end
% imgcomplete = abs(img1);
% img1 = [imgcomplete(1:end, 2:end) zeros(128, 0)]

img1 = uint8(abs(img1));

% Output Lena
% [A] = textread('Output_10_sobel.dat','%s');
[A] = textread('Lena128x128g_8bits_o.dat','%s');
A = bin2dec(A);
output = uint8(reshape(A, [128 128]))';

% Difference
diff = output - img1;

figure;
subplot(141),imshow(img); title('Original');
subplot(142),imshow(img1, []); title('MATLAB');
subplot(143),imshow(output,[]); title('VHDL');
subplot(144),imshow(diff,[]); title('Difference');

