%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTRY POINT FOR THE STREAMER GUI
% requires: eeglab with load_xdf plugin, LSL libraries for Matlab
%
% insert path and filename at the indicated positions 
% eeglab will load dataset and stream the eeg data alongside with the
% markers via an LSL stream
%
% author: Sarah Blum, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = streamControl(varargin)
% STREAMCONTROL MATLAB code for streamControl.fig
%      STREAMCONTROL by itself, creates a new STREAMCONTROL or raises the
%      existing singleton*.
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
%      H = STREAMCONTROL returns the handle to a new STREAMCONTROL or the handle to
%      the existing singleton*.
%
%      STREAMCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STREAMCONTROL.M with the given input arguments.
%
%      STREAMCONTROL('Property','Value',...) creates a new STREAMCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before streamControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to streamControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help streamControl

% Last Modified by GUIDE v2.5 02-Jul-2016 16:13:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @streamControl_OpeningFcn, ...
                   'gui_OutputFcn',  @streamControl_OutputFcn, ...
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

% --- Executes just before streamControl is made visible.
function streamControl_OpeningFcn(hObject, ~, h, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to streamControl (see VARARGIN)

global handles 
handles = h;

% Call this function once when creating the figure so that eeglab is being
% started once. It will load the given dataset.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR PATH HERE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rawdatapath = 'datasets/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR FILENAME HERE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fname = input('type in dataset name lying in datasets folder: ', 's');

oneChannel = false;
pamperEEGLab(rawdatapath, fname, oneChannel);
initializeReplayerState();


% Choose default command line output for streamControl
h.output = 'Yes';

% Update handles structure
guidata(hObject, h);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3)
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(h.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat


questIconMap(256,:) = get(h.figure1, 'Color');
IconCMap=questIconMap;

set(h.figure1, 'Colormap', IconCMap);


% Make the GUI not modal if you dont want it to be obnoxious af
set(h.figure1,'WindowStyle','normal')

% UIWAIT makes streamControl wait for user response (see UIRESUME)
uiwait(h.figure1);
%set (h.figure1, 'Visible', 'on', 'WaitStatus', 'waiting');

% --- Outputs from this function are returned to the command line.
function varargout = streamControl_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout = cell(1);
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end 



% --- Executes on button press in StartEEGStream.
% this is "StartEEGStream"
function StartEEGStream_Callback(hObject, eventdata, handles)
% hObject    handle to StartEEGStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global running 
if ~running
SendEEGdataBlindly();
end



% --- Executes on button press in PauseEEGStream.
% this is "pause eeg stream"
function PauseEEGStream_Callback(hObject, eventdata, handles)
% hObject    handle to PauseEEGStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pauseEEGstream();


% --- Executes on button press in StopEEGStream.
% this is "Stop eeg stream"
function StopEEGStream_Callback(hObject, eventdata, handles)
% hObject    handle to StopEEGStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stopEEGstream();


% --- Executes on button press in ResumeEEGStream.
% this is "resume EEG stream"
function ResumeEEGStream_Callback(hObject, eventdata, handles)
% hObject    handle to ResumeEEGStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global running paused

paused = false;
if ~running
    SendEEGdataBlindly();
end


% --- Executes during object creation, after setting all properties.
function sampleCounterTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleCounterTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function SampleCounterDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleCounterDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp 'closing';
% perform the quit logic
quitStreamReplayer();
