function varargout = SD_WM_CH(varargin)
% SD_WM_CH M-file for SD_WM_CH.fig
%      SD_WM_CH, by itself, creates a new SD_WM_CH or raises the existing
%      singleton*.
%
%      H = SD_WM_CH returns the handle to a new SD_WM_CH or the handle to
%      the existing singleton*.
%
%      SD_WM_CH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SD_WM_CH.M with the given input arguments.
%
%      SD_WM_CH('Property','Value',...) creates a new SD_WM_CH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SD_WM_CH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SD_WM_CH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SD_WM_CH

% Last Modified by GUIDE v2.5 16-Mar-2015 22:12:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SD_WM_CH_OpeningFcn, ...
                   'gui_OutputFcn',  @SD_WM_CH_OutputFcn, ...
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
% End initialization code - DO NOT EDIT






% --- Executes just before SD_WM_CH is made visible.
function SD_WM_CH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SD_WM_CH (see VARARGIN)


% Choose default command line output for SD_WM_CH
handles.output = hObject;
a=ones(255,255);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);
axes(handles.axes5);
imshow(a);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SD_WM_CH wait for user response (see UIRESUME)
% uiwait(handles.figure1);
        

% --- Outputs from this function are returned to the command line.
function varargout = SD_WM_CH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in push1.
function push1_Callback(hObject, eventdata, handles)
% hObject    handle to push1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.jpg','Select the Input Image to be watermarked');
if isequal(filename,0) || isequal(pathname,0)
    warndlg('File not found');
else
    input = imread(fullfile(pathname,filename));
%     input=aviread(filename);
    axes(handles.axes1);
    handles.input=input;
    handles.filename=filename;
    guidata(hObject,handles);
    helpdlg('Input Image selected!');
    axes(handles.axes1);
    imshow(input);
end



% --- Executes on button press in push2.
function push2_Callback(hObject, eventdata, handles)
% hObject    handle to push2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename1,pathname1]=uigetfile('*.*','select image to be watermarked');
if isequal(filename1,0) || isequal(pathname1,0)
    warndlg('Watermark image is not selected');
else
    wlogo=imread(filename1);
    [r c p]=size(wlogo);
    if p==3

    wlogo=rgb2gray(wlogo);
    end
    axes(handles.axes2);
    imshow(wlogo);
    handles.logo=wlogo;
    [r3 c3]=size(wlogo);
    handles.r3=r3;
    handles.c3=c3;
    guidata(hObject,handles); 
    helpdlg('Watermark logo selected');
end


% --- Executes on button press in push3.
function push3_Callback(hObject, eventdata, handles)
% hObject    handle to push3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

wlogo=handles.logo;
wimage=handles.input;
R=wimage(:,:,1);
    R=imresize(R,[255 255]);
    
    G=wimage(:,:,2);
    G=imresize(G,[255 255]);
    
    B=wimage(:,:,3);
    B=imresize(B,[255 255]);
    
    B=double(B);
    B1=imresize(wlogo,[255 255]);
    B1=double(B1);
    k=0.01;

    
    [r1 c1]=size(B);
            for i=1:5:r1
                for j=1:5:c1
                    block=B(i:i+4,j:j+4);
                    wblock=B1(i:i+4,j:j+4);
                    
                    [U,S,V]=svd(block);
                    A=U*S;
                    D=A+(wblock*k);
           
                    [U1,S1,V1]=svd(D);
                    W=U*S1*V';
                    W11(i:i+4,j:j+4)=W;
                    U11(i:i+4,j:j+4)=U1;
                    V11(i:i+4,j:j+4)=V1;
                    A11(i:i+4,j:j+4)=A;
                end
            end
                    WY(:,:,1)=R;
                    WY(:,:,2)=G;
                    WY(:,:,3)=W11;
axes(handles.axes3);
imshow(WY);
handles.WY=WY;
handles.U11=U11;
handles.V11=V11;
handles.A11=A11;
handles.k=k;
guidata(hObject,handles);
helpdlg('Embedding process completed');


% --- Executes on button press in push4.
function push4_Callback(hObject, eventdata, handles)
% hObject    handle to push4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)W1=handles.WY;
W1=handles.WY;
R=W1(:,:,1);
 G=W1(:,:,2);
 W11=double(W1(:,:,3));
 U11=double(handles.U11);
 V11=double(handles.V11);
 A11=double(handles.A11);
 k=handles.k;
 [r2 c2]=size(W11);
 for i=1:5:r2
                for j=1:5:c2
                    W22=W11(i:i+4,j:j+4);
                    U22=U11(i:i+4,j:j+4);
                    V22=V11(i:i+4,j:j+4);
                    A2=A11(i:i+4,j:j+4);
                    [U2,S2,V2]=svd(W22);
                    Wt=U22*S2*V22';
                    W0=(Wt-A2)./k;
                    WT(i:i+4,j:j+4)=W0;
                end
 end
handles.WT=WT;
guidata(hObject,handles);
helpdlg('Extraction process Completed');


% --- Executes on button press in push5.
function push5_Callback(hObject, eventdata, handles)
% hObject    handle to push5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WT=handles.WT;
r3=handles.r3;
c3=handles.c3;
water_logo=imresize(WT,[r3 c3]);
axes(handles.axes4);
imshow(water_logo,[]);

% --- Executes on button press in push6.
function push6_Callback(hObject, eventdata, handles)
% hObject    handle to push6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
a=ones(255,255);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);
axes(handles.axes5);
imshow(a);
