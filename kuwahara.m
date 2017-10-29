%% Kuwahara Filter
% neighborhood size
n = 30;
% loading example image
I = rgb2gray(mat2gray(imread('peppers.png')));
% size of I
[f,c]=size(I);
% empty array like I
Inueva = zeros(f,c);
% main loop
for i=1:f
    for j=1:c
        % border conditions
        if i-n < 1 || i+n > f-1 || j-n < 1 || j+n > c-1
            Inueva(i,j) = I(i,j);
            continue;
        end
        % empty array where variances will be stored
        vari = [];
        % empty array where mean values will be stored
        proms = [];
        % neighborhood
        ven_temp = I(i-n:i+n,j-n:j+n);
        % defining the four regions
        r1 = ven_temp(1:n,1:n+1);
        r2 = ven_temp(n+1:(2*n)+1,1:n);
        r3 = ven_temp(n+2:(2*n)+1,n+1:(2*n)+1);
        r4 = ven_temp(1:n+2,n+2:(2*n)+1);
        % estimating the variance of each region
        vari(1) = var(r1(:));
        vari(2) = var(r2(:));
        vari(3) = var(r3(:));
        vari(4) = var(r4(:));
        % estimating the mean of each region
        proms(1) = mean(r1(:));
        proms(2) = mean(r2(:));
        proms(3) = mean(r3(:));
        proms(4) = mean(r4(:));
        % estimating the index of the region with lower variance
        [~,index] = min(vari);
        % assigning the mean value to the filtered image
        Inueva(i,j) = proms(index);
    end
end

figure; 
subplot(1,2,1);imshow(I);title("Original Image")
subplot(1,2,2);imshow(Inueva);title("Image with Kuwahara Filter")

