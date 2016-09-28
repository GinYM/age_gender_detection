function [ERROR,centreleftx,centrelefty,centrerightx,centrerighty] ...
    = DetectEyes(Im)

%Split Image
im_cx = length(Im(1,:))/2;          %Find Centre of Image
eyeoffset = 7;                      %Offset for eye centre
left_face = Im(:,im_cx:end);
right_face = Im(:,1:im_cx);

%Detect Eyes
eyedetector_right = vision.CascadeObjectDetector('RightEyeCART');
eyedetector_left = vision.CascadeObjectDetector('LeftEyeCART');
right_eye = step(eyedetector_right,right_face);
left_eye = step(eyedetector_left,left_face);

if isempty(right_eye) || isempty(left_eye)
    ERROR = 1;
    centreleftx = 0;
    centrelefty = 0;
    centrerightx = 0;
    centrerighty = 0;
else
    %Remove False Detections
    if size(right_eye,1) > 1
    right_eye(2:end,:) = [];
    end
    if size(left_eye,1) > 1
    left_eye(2:end,:) = [];
    end

    %Perform Offset
    right_eye(1,2) = right_eye(1,2)+eyeoffset;
    left_eye(1,2) = left_eye(1,2)+eyeoffset;

    %Find CentrePoints of eyes
    centrerightx = ceil((right_eye(1,1)+right_eye(1,1)+right_eye(1,4))/2);
    centrerighty = ceil((right_eye(1,2)+right_eye(1,2)+right_eye(1,3))/2);

    centreleftx = ceil((left_eye(1,1)+left_eye(1,1)+left_eye(1,4))/2);
    centrelefty = ceil((left_eye(1,2)+left_eye(1,2)+left_eye(1,3))/2);

    %Translate back to original Image - CentrepointRight does not change
    %Nor does centrelefty
    centreleftx = centreleftx + im_cx;
    ERROR = 0;
end
end

