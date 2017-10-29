%% Tri-state median filter
%Adding noise to an example image
I = imnoise(rgb2gray(mat2gray(imread('peppers.png'))),'salt & pepper',0.1);
%Size of I
[f,c] = size(I);
% image with the cwmf filter
Icwmf = zeros(f,c);
% image with the tristate filter
Inueva = zeros(f,c);
%image with the median filter
Imedian = zeros(f,c);
% v is the cwmf filter parameter
v = 5;
% window size for median filter
w = 3;
% threshold for tristate filter
T = 0.1;
%main loop
for i=1:f
    for j=1:c
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
        %neighborhood
        ngh = I(i1:i2,j1:j2);
        %neighborhood as array
        ngh1 = reshape(ngh',size(ngh,1)*size(ngh,2),1);
        %increasing center point
        ngh1(end+1:end+v) = ngh(w,w)*ones(1,v);
        % cwmf value
        Icwmf(i,j)=median(ngh1);  
    end
end
% median filter
Imedian=medfilt2(I,[3,3]);
% implementing tristate filter
for i=1:f
    for j=1:c
        d1 = abs(I(i,j)-Imedian(i,j));
        d2 = abs(I(i,j)-Icwmf(i,j));
        if T >= d1
            Inueva(i,j) = I(i,j);
        elseif d2 <= T
            Inueva(i,j) = Icwmf(i,j);
        else
            Inueva(i,j) = Imedian(i,j);
        end
    end
end

figure;
subplot(2,3,[1,3]); imshow(I);
subplot(2,3,4); imshow(Imedian); title('Median');
subplot(2,3,5); imshow(Icwmf); title('CWMF');
subplot(2,3,6); imshow(Inueva); title('Tristate');