function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 04-Nov-2018 22:15:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Training Aple
directories = strcat('Apel/*.jpg');
imagefiles = dir(directories);      
nfiles = length(imagefiles);

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentfilename = strcat('Apel/',currentfilename);
   gambar = imread(currentfilename);
   s = sum(sum(gambar));
   uk = size(gambar);
   rata_rata = s./(uk(1)*uk(2));
   rata_rataR = rata_rata(1);
   rata_rataG = rata_rata(2);
   rata_rataB = rata_rata(3);
   target(1,ii) = 1;
   target(2,ii) = 0;
   data_latih(1,ii) = rata_rataR;
   data_latih(2,ii) = rata_rataG;
   data_latih(3,ii) = rata_rataB;
end
%% Training pinapple
directories = strcat('Nanas/*.jpg');
imagefiles = dir(directories);      
nfiles2 = length(imagefiles);

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentfilename = strcat('Nanas/',currentfilename);
   gambar = imread(currentfilename);
   s = sum(sum(gambar));
   uk = size(gambar);
   
   rata_rata = s./(uk(1)*uk(2));
   
   rata_rataR = rata_rata(1);
   rata_rataG = rata_rata(2);
   rata_rataB = rata_rata(3);
   target(1,(ii+nfiles)) = 0;
   target(2,(ii+nfiles)) = 1;
   data_latih(1,(ii+nfiles)) = rata_rataR;
   data_latih(2,(ii+nfiles)) = rata_rataG;
   data_latih(3,(ii+nfiles)) = rata_rataB;
end
set(handles.table_meandata, 'Data', data_latih);
set(handles.table_target, 'Data', target);
save('target.mat','target');
save('data_latih.mat','data_latih');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('target.mat');
load('data_latih.mat');
%% minmax = input elemen
%% [1500, 2] size of layer and output
%% {'logsig', 'logsig'} Transfer function of ith layer
%% taingcp Backprop network training function

net1 = newff(minmax(data_latih), [100,2], {'logsig', 'logsig'}, 'traingd');
init(net1);
net1.trainParam.epochs = 10000;
net1.trainParam.goal = 0.0001;
net1 = fitnet(50);
tic;
net1 = train(net1, data_latih, target);

set(handles.txt_waktu_training, 'String', "waktu training "+toc+" detik ");
save('net.mat','net1');
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('target.mat');
load('data_latih.mat');
load('net.mat');
[file,path] = uigetfile('*.jpg', 'Buka gambar untuk di uji');
currentfilename = strcat(path,file);
img = imread(currentfilename);
sumimg = sum(sum(img));
s = size(img);
rata_rata = sumimg./(s(1)*s(2));

rata_rataR = rata_rata(1);
rata_rataG = rata_rata(2);
rata_rataB = rata_rata(3);

tabel_uji(1,1) = rata_rataR;
tabel_uji(2,1) = rata_rataG;
tabel_uji(3,1) = rata_rataB;

axes(handles.image);
imshow(img);
hasil = sim(net1, tabel_uji);

hasil

if (hasil(1) > 0.8)
    set(handles.txt_nama_buah, 'String', " Buah Apel ");
elseif (hasil(2) > 0.8)
    set(handles.txt_nama_buah, 'String', " Buah Nanas ");
else 
    set(handles.txt_nama_buah, 'String', " Bukan Buah Nanas atau Apel");
end
set(handles.nilai_red, 'String', "mean red value "+rata_rataR);
set(handles.nilai_green, 'String', "mean green value "+rata_rataG);
set(handles.nilai_blue, 'String', "mean blue value "+rata_rataB);
