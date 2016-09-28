function [Race] = SortRace(Im)

EQ = adapthisteq(Im);

%Calculating average intensity over Band
%Identifying Black Males by band limited HistEq and averaging 
band = 50:150;  %Band for finding black faces
band2 = 200:250; %Band for half faces
Av = zeros(size(EQ,3),2);    
[histEQ,~] = imhist(EQ);
[histORIG,~] = imhist(Im);

n_histEQ = (histEQ-min(histEQ))/(max(histEQ)-min(histEQ)); %NormaliseEQ
n_histORIG = (histORIG-min(histORIG))/(max(histORIG)-min(histORIG)); %NormaliseOrig

Av(2) = sum(n_histEQ(band))/length(n_histEQ(band));     %Average valEQ
Av(1) = sum(n_histORIG(band))/length(n_histORIG(band));     %Average valOrig

if Av(2) >= 0.5             %First pass with EQ face
    black_face = Im;
else
    if Av(1) <= 0.3         %Second pass with Orig Face
        white_face = Im;
    else                      %Some other checking method
        %EQ2 = adapthisteq(faces(1:45,:,i));
        %[halfHist,~] = imhist(EQ2);
        [halfHist,~] = imhist(Im(1:45,:));
        n_hHist = (halfHist-min(halfHist))/(max(halfHist)-min(halfHist));
        Av_h(1) = sum(n_hHist(band2))/length(n_hHist(band2));

        close all;
        if Av_h(1) >= 0.5
            white_face = Im;
        else
            black_face = Im;
        end
    end
end


if exist('black_face','var') == 0 
    %black_face = [];
    Race = 'White';
elseif exist('white_face','var') == 0
    %white_face = [];
    Race = 'Black';
end

end





