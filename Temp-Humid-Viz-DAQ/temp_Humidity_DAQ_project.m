function varargout = temp_Humidity_DAQ_project(varargin)
% ESD_PROJECT MATLAB code for ESD_project.fig
%      ESD_PROJECT, by itself, creates a new ESD_PROJECT or raises the existing
%      singleton*.
%
%      H = ESD_PROJECT returns the handle to a new ESD_PROJECT or the handle to
%      the existing singleton*.
%
%      ESD_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESD_PROJECT.M with the given input arguments.
%
%      ESD_PROJECT('Property','Value',...) creates a new ESD_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ESD_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ESD_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ESD_project

% Last Modified by GUIDE v2.5 16-Jul-2021 17:45:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ESD_project_OpeningFcn, ...
                   'gui_OutputFcn',  @ESD_project_OutputFcn, ...
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


% --- Executes just before ESD_project is made visible.
function ESD_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ESD_project (see VARARGIN)
 ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to this toolbox, you can use another image file instead.
I=imread('esddht.jpg');
imagesc(I)
%hi = imagesc(I)
%colormap gray
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
            'visible','off')
% Now we can use the figure, as required.
% Choose default command line output for ESD_project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ESD_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ESD_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;   

%%%%%%%%%%%%%%%%%%
global T 
T = [0;0];
global H
H = [0;0];
%%%%%%%%%%%%%%
% --- Executes on button press in DA_button.
function DA_button_Callback(hObject, eventdata, handles)
% hObject    handle to DA_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 Ta = table(T,H);
    A = table2array(Ta);
    csvwrite('Weather_raw.csv',A)
    system('csvconv.py')
    
% --- Executes on button press in Plot_button.
function Plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
clc;
s = serial('COM3');
time = 100;
i = 1;
%T = [0;0];
%H = [0;0];
while(i<time)
    fopen(s)
    %fprint(s,'Your Serial Data goes Here')
    out = fscanf(s)
    
    Temp(i) = str2num(out(1:4));
    %
     T(i+1) = Temp(i);
    %
    subplot(121);
    bar(T,'hist');
    axis([0,time,20,50]);
    title('Parameter: DHT11 Temperature','Color','white');
    xlabel('++++>Time','Color','white');
    ylabel('++++>  % Temperature ','Color','white');
    ylim([0 35])
    grid
    
    
    Humi(i) = str2num(out(6:9));
    %
    H(i+1) = Humi(i);
    %
    subplot(122);
    bar(H,'hist');
    axis([0,time,25,100]);
    title('Parameter: DHT11 Humidity','Color','white');
    xlabel('===>Time ','Color','white');
    ylabel('===>  %Humidity ','Color','white');
    ylim([0 100])
    grid
    
    fclose(s);
    i = i+1;
    drawnow;
end
delete(s)
clear s
