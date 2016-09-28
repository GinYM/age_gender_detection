% Add the gender classification after the face dection. (without preprocessing)
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global faceDetector;
axes(handles.axes1);
%while ishandle(handles.axes1)
   if ishandle(handles.axes1)
    snapshot=getsnapshot(vid);
    flushdata(vid);
    [gray,box]= JGetFaces(faceDetector, snapshot);
%     gray=rgb2gray(snapshot);
% Add gender classification
    imshow(gray);
%     imshow(snapshot);
    drawnow;
    
end
