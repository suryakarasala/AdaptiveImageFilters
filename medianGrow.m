%% Adaptive Median Filter - Neighborhood Grow
%Adding noise to an example image
I = imnoise(rgb2gray(mat2gray(imread('peppers.png'))),'salt & pepper',0.01);
% Size of I
[f,c] = size(I);
% Initial size of neighborhood
n = 1;
% w is the adaptive window size
w = n;
% empty matrix like I
Inueva = zeros(f,c);
% the resize flag is true when it's necessary to grow.
resize = false;
% conts
i=1;
j=1;
%main loop
while i < f
    while j < c
        % growing
        if resize
            i = ii;
            j = jj;
        end
        % border conditions
        if i-w < 1
            i1 = 1;
        else
            i1 = i-w;
        end
        if i+w > f-1
            i2 = f;
        else
            i2 = i+w;
        end
        if j-w < 1
            j1 = 1;
        else
            j1 = j-w;
        end
        if j+w > c-1
            j2 = c;
        else
            j2 = j+w;
        end
        % neighborhood
        ven_temp = I(i1:i2,j1:j2);
        % median of window
        ven_median = median(ven_temp(:));
        % min of window
        ven_min = min(min(ven_temp));
        % max of window
        ven_max = max(max(ven_temp));
        % checking if window must grow, the window can grow a maximum of 3 times the original window
        if (ven_min < ven_median) && (ven_median < ven_max) && (ven_min < I(i,j)) && (I(i,j) < ven_max) && (w < 3*n)
            resize = true;
            w = w+1;
            ii = i;
            jj = j;
            continue;
        else
            resize = false;
            Inueva(i,j) = ven_median;
            w = n;
        end
        j = j+1;
    end
    i=i+1;
    j=1;
end
figure;
subplot(1,2,1); imshow(I);title('Original Image')
subplot(1,2,2); imshow(Inueva);title('Image with Median Grow Filter')