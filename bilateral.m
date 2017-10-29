%% bilateral filter
%Adding gaussian noise to an example image:
I2 = imnoise(rgb2gray(mat2gray(imread('peppers.png'))),'gaussian',0,0.001);
%Selecting a region of the image
I = I2(50:350,100:400);
%Size of image
[f,c] = size(I);
%Empty array of size I
Inueva = zeros(f,c);
%size of window
n=1;
% defining sigmas
sigmad = 0.1;
sigmar = 0.2;
%main loop
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
        %size of neighborhood
        [f1,c1] = size(ven_temp);
        %empty zeros matrix like neighborhood
        h = zeros(f1,c1);
        %performing bilateral filter
        for ii=1:f1
            for jj=1:c1
                maxi = max(max(ven_temp));
                mini = min(min(ven_temp));
                medi = mean(mean(ven_temp));
                if (ven_temp(ii,jj)-medi) > 0
                    cita = maxi - ven_temp(ii,jj);
                elseif (ven_temp(ii,jj)-medi) < 0
                    cita = mini - ven_temp(ii,jj);
                else
                    cita = 0;
                end
                h(ii,jj) = exp((-1/2*sigmad^2)*((ii-(f1/2))^2+(jj-(c1/2))^2))*exp((-1/2*sigmar^2)*(ven_temp(round(f1/2),round(c1/2))-ven_temp(ii,jj)-cita));
                
            end
        end
        Inueva(i,j) = (1/sum(sum(h)))*sum(sum(ven_temp.*h));
    end
end

figure;
subplot(1,2,1); imshow(I);title("Original Image")
subplot(1,2,2); imshow(Inueva);title("Image with Bilateral Filter")
