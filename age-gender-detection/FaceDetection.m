function varargout = FaceDetection(varargin)
 
% Begin initialization code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceDetection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code

% --- Executes just before FaceDectect is made visible.
function FaceDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FaceDectect (see VARARGIN)
% Choose default command line output for FaceDectect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FaceDectect wait for user response (see UIRESUME)
% uiwait(handles.figure1);
t = timer('TimerFcn', {@timerCallback, handles}, 'ExecutionMode', 'fixedDelay', 'Period', 0.1);
set(handles.edit1, 'DeleteFcn', {@DeleteFcn, t});
% 启动定时器
start(t);
global faceDetector;
faceDetector = vision.CascadeObjectDetector;
global vid;
vid = videoinput('winvideo', 1, 'YUY2_320x240');
set(vid,'ReturnedColorSpace','rgb');
vidRes=get(vid,'VideoResolution');
width=vidRes(1);
height=vidRes(2);
nBands=get(vid,'NumberOfBands');
% figure('Name', 'Matlab调用摄像头 By Lyqmath', 'NumberTitle', 'Off', 'ToolBar', 'None', 'MenuBar', 'None');
hImage=image(zeros(height,width,nBands));
axes(handles.axes2);
preview(vid,hImage);
% hImage=image('parent',handles.axes1);
% preview(vid,hImage);
% 窗口关闭的响应函数－停止计时器
function DeleteFcn(hObject, eventdata, t)
stop(t);

% --- Outputs from this function are returned to the command line.
function varargout = FaceDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timerCallback(obj, event, hEdit)
set(hEdit.edit1, 'String', datestr(now, 'HH:MM:SS'));

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global faceDetector;
axes(handles.axes1);
% while ishandle(handles.axes1)
if ishandle(handles.axes1)
    snapshot=getsnapshot(vid);
    flushdata(vid);
    [gray,box]= JGetFaces(faceDetector, snapshot);
%     gray=rgb2gray(snapshot);

    imshow(gray);
    drawnow;
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global faceDetector;
axes(handles.axes1);
% while ishandle(handles.axes1)
[FileName,PathName] = uigetfile('*.jpg', 'select a query image');
if isequal(FileName,0)
    disp('Please select again！')
    I = [];
else
    I = imread(fullfile(PathName,FileName));
    [gray,box]= JGetFaces(faceDetector, I);
    imshow(gray);
end
