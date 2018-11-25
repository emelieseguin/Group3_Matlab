function varargout = DisplayLogFile(varargin)
% DISPLAYLOGFILE MATLAB code for DisplayLogFile.fig
%      DISPLAYLOGFILE, by itself, creates a new DISPLAYLOGFILE or raises the existing
%      singleton*.
%
%      H = DISPLAYLOGFILE returns the handle to a new DISPLAYLOGFILE or the handle to
%      the existing singleton*.
%
%      DISPLAYLOGFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYLOGFILE.M with the given input arguments.
%
%      DISPLAYLOGFILE('Property','Value',...) creates a new DISPLAYLOGFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplayLogFile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisplayLogFile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisplayLogFile

% Last Modified by GUIDE v2.5 23-Nov-2018 15:30:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplayLogFile_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplayLogFile_OutputFcn, ...
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


% --- Executes just before DisplayLogFile is made visible.
function DisplayLogFile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisplayLogFile (see VARARGIN)

% Choose default command line output for DisplayLogFile
handles.output = hObject;

logFileText = fileread('C:\MCG4322B\Group3\Log\group3_LOG.txt');
set(handles.LogTextFileReading, 'String', logFileText);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DisplayLogFile wait for user response (see UIRESUME)
% uiwait(handles.LogFilePopout);


% --- Outputs from this function are returned to the command line.
function varargout = DisplayLogFile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
