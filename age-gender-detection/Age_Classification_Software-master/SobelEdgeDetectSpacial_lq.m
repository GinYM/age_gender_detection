function [Im,Edges,Sobel] = SobelEdgeDetectSpacial_lq(Img,Thresh)
               
                %This function detects edges in images using the Sobel 
                %Operator method via Spacial Filtering.
                %Reference: http://en.wikipedia.org/wiki/Sobel_operator
                
                %Outputs are:
                %          - Im = Enhanced edges on a binary mask of
                %            original image
                %          - Edges = Detected Edges
                %          - Sobel = Sobel Gradient
                
                %Inputs are:
                %          - Img = RGB image
                %          - Thresh = integer from 0-255. Determines the 
                %            strength of edge detection

%Im = rgb2gray(Img);       %Convert to gray scale
Im_d = double(Img);        %Convert to double presision 

for i=1:size(Im_d,1)-2
    for j=1:size(Im_d,2)-2
        %Horizontal direction - Find Derivative
        Gx = ((2*Im_d(i+2,j+1)+Im_d(i+2,j) + Im_d(i+2,j+2)) - ...
            (2*Im_d(i,j+1)+Im_d(i,j)+Im_d(i,j+2)));
        %Vertical direction - Find Derivative
        Gy = ((2*Im_d(i+1,j+2)+Im_d(i,j+2) + Im_d(i+2,j+2)) - ...
            (2*Im_d(i+1,j)+Im_d(i,j)+Im_d(i+2,j)));
      
        %Gradient
        Im(i,j) = uint8(sqrt(Gx.^2+Gy.^2));    
    end
end
%Calculated Sobel Gradient
Sobel = Im;

%Threshold on sobel gradient  
Im = max(Im,Thresh);          %Smallest value = thresh
Im(Im == round(Thresh)) = 0;  %Scale image to threshold value

Im = uint8(Im);               %Convert to uint8
Edges = ~Im;
end

