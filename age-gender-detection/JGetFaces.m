%% Face dection
function [I_faces,box]= JGetFaces(faceDetector, I)
[w h b]=size(I);
if w>300
    I=imresize(I,[300 300*h/w]);
end
[w h b]=size(I);
if h>400
    I=imresize(I,[400*w/h 400]);
end
% dection
bbox = step(faceDetector, I);
sexs=zeros(size(bbox, 1),1);
n=size(bbox, 1);
text_str = cell(n,1);
position = zeros(n,2);
for ii=1:n
   text_str{ii} = ['Female'];
end
%    box_color = {'red','green','yellow'};  
for i = 1:size(bbox, 1)
    xs = bbox(i, 1);
    xe = xs + bbox(i,3);
    ys = bbox(i, 2);
    ye = ys + bbox(i,4);
    gray=rgb2gray(I(ys:ye, xs:xe, :));
    gray2=imresize(gray,[80 80]);
    sexs(i)=GenderRec(gray2);
    position(i,1)=xs;
    position(i,2)=ye;
    if sexs(i)~=2
        text_str{i}=['female'];
    else
        text_str{i}=['male'];
    end 
end
box=bbox;
% 'BoxColor', box_color,
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 0 0]);
I = step(shapeInserter, I, int32(bbox));
I_faces = insertText(I, position, text_str, 'FontSize', 12, 'BoxOpacity', 0.6);

% plot bounding box
end