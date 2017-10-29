%% Mean Squared Error Filter
% adding gaussian noise to an example image
I = imnoise(rgb2gray(mat2gray(imread('peppers.png'))),'gaussian',0,0.001);
% window size
n = 1;
% constant
N = sqrt(2*n+1);
% size of I
[f,c] = size(I);
% image where the filter result will be stored
Inueva = zeros(f,c);
%image with mean values
Iprom = zeros(f,c);
%image for local variances
Ivar = zeros(f,c);
% main loop
for i=1:f
    for j=1:c
        %border conditions
        if i-n < 1 
            i1 = 1;
        else
            i1 = i-n;
        end
        if i+n > f-1
            i2 = f;
        else
            i2 = i+n;
        end
        if j-n < 1 
            j1 = 1;
        else
            j1 = j-n;
        end
        if j+n > c-1
            j2 = c;
        else
            j2 = j+n;
        end
        %neighborhood
        ven_temp = I(i1:i2,j1:j2);
        %mean of neighborhood
        Iprom(i,j) = mean(ven_temp(:));
        %variance of the neighborhood
        vari = (sum(sum(ven_temp.^2))-(sum(sum(ven_temp))^2)/N)/(N*(N-1));
        Ivar(i,j) = vari;     
    end
end
% cost function
gg = zeros(f,c);
% estimating minimum of local variances
var_min = min(min(vari));
% filling cost image
for i=1:f
    for j=1:c
        g = var_min/Ivar(i,j);
        gg(i,j) = g;
    end
end
% processing cost image to improve results
gg1 = mat2gray(histeq(gg));
% appling MSE filter
for i=1:f
    for j=1:c
        Inueva(i,j) = Iprom(i,j)-gg1(i,j)*(abs(I(i,j)-Iprom(i,j)));
    end
end
figure;
subplot(1,2,1); imshow(I);title('Original Image')
subplot(1,2,2); imshow(mat2gray(Inueva));title('Image with MSE filter')
