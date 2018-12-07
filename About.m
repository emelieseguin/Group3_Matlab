function varargout = About(varargin)
% ABOUTDIMENSIONS MATLAB code for AboutDimensions.fig
%      ABOUTDIMENSIONS, by itself, creates a new ABOUTDIMENSIONS or raises the existing
%      singleton*.
%
%      H = ABOUTDIMENSIONS returns the handle to a new ABOUTDIMENSIONS or the handle to
%      the existing singleton*.
%
%      ABOUTDIMENSIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUTDIMENSIONS.M with the given input arguments.
%
%      ABOUTDIMENSIONS('Property','Value',...) creates a new ABOUTDIMENSIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AboutDimensions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AboutDimensions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AboutDimensions

% Last Modified by GUIDE v2.5 23-Nov-2018 14:06:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AboutDimensions_OpeningFcn, ...
                   'gui_OutputFcn',  @AboutDimensions_OutputFcn, ...
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


% --- Executes just before AboutDimensions is made visible.
function AboutDimensions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AboutDimensions (see VARARGIN)

% Choose default command line output for AboutDimensions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AboutDimensions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AboutDimensions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
