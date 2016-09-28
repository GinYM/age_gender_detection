function [Normalised,ERROR,angle] = ImNormalise(Im)
        %This function returns the normalised, face cropped image by first
        %detecting eyes and rotating the image about the eyes. 

        %Assumes image is in grayscale
        %Detects and crops the face
        %Splits face into 2 sections - left and right
        %Detects eyes
        %Normalise and return image
        
Break = 0;
%Detect and Crop face
[CroppedFace0,ERRORface] = CropFace(Im);     %Call function to crop face
if ERRORface == 1
    Break = 1;
end

if Break == 1 
    Normalised = 0;
    angle = 0;
    ERROR = 1;
else
    %Detect Centre Points of Eyes
    Normalised = cell(size(CroppedFace0,1),1);
    for i = 1:size(CroppedFace0,1)
        CroppedFace = CroppedFace0{i};
        [ERROR,centreleftx,centrelefty,centrerightx,centrerighty] ...
            = DetectEyes(CroppedFace);      %Call function to find eyes
        if ERROR == 1
            Normalised0 = CroppedFace;
            angle = 0;
        else
            %Find angle and Normalise
            angle = asind((centrelefty-centrerighty)/(centreleftx-centrerightx));
            Normalised1 = imrotate(Im,angle,'crop');
            Normalised0 = CropFace(Normalised1);
            ERROR = 0;
            Normalised0 = Normalised0{1};
        end
        Normalised{i} = Normalised0;
    end
end
end

