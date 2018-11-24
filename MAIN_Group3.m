function varargout = MAIN_Group3(varargin)
% MAIN_GROUP3 MATLAB code for MAIN_Group3.fig
%      MAIN_GROUP3, by itself, creates a new MAIN_GROUP3 or raises the existing
%      singleton*.
%
%      H = MAIN_GROUP3 returns the handle to a new MAIN_GROUP3 or the handle to
%      the existing singleton*.
%
%      MAIN_GROUP3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GROUP3.M with the given input arguments.
%
%      MAIN_GROUP3('Property','Value',...) creates a new MAIN_GROUP3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_Group3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_Group3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN_Group3

% Last Modified by GUIDE v2.5 24-Nov-2018 12:42:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_Group3_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_Group3_OutputFcn, ...
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


% --- Executes just before MAIN_Group3 is made visible.
function MAIN_Group3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN_Group3 (see VARARGIN)

% Choose default command line output for MAIN_Group3
handles.output = hObject;

set(handles.mainContent_panel, 'visible', 'on');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

axes(handles.displayImageAxis);
imshow('TempDesignImage.jpg');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN_Group3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAIN_Group3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ------------------ The Navigation Buttons ------------------------------%
% --- Executes on button press in mainButton.
function mainButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'on');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% --- Executes on button press in patientGaitButton.
function patientGaitButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'on');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% --- Executes on button press in fourBarButton.
function fourBarButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'on');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% --- Executes on button press in dorsiflexionButton.
function dorsiflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'on');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% --- Executes on button press in plantarflexionButton.
function plantarflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'on');
set(handles.inversePanel, 'visible', 'off');

% --- Executes on button press in Gait_Inverse_Button.
function Gait_Inverse_Button_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'on');



% --- Executes during object creation, after setting all properties.
function mainContent_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainContent_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function weightEditTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to weightEditTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weightEditTextBox as text
%        str2double(get(hObject,'String')) returns contents of weightEditTextBox as a double


% --- Executes during object creation, after setting all properties.
function weightEditTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightEditTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function heightEditTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to heightEditTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightEditTextBox as text
%        str2double(get(hObject,'String')) returns contents of heightEditTextBox as a double


% --- Executes during object creation, after setting all properties.
function heightEditTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightEditTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function displayImageAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayImageAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate displayImageAxis


% --- Executes on button press in MoreInfoDimensionsButton.
function MoreInfoDimensionsButton_Callback(hObject, eventdata, handles)
%% Pop up the About Dimensions figure 
%set(handles.popup, 'Value', 1);
% Now launch the BoatGUI function
run AboutDimensions.m;

% -------------------------- Run The CAD Program -------------------------%
% --- Executes on button press in RunCADButton.
function RunCADButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunCADButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
logFilePath = 'C:\MCG4322B\Group3\Log\group3_LOG.txt';
% New trial - delete the old log file
if exist(logFilePath, 'file')==2
  delete(logFilePath);
end

%% Read in the input variables from the user, check if they are numbers
readWeight = get(handles.weightEditTextBox,'String');
[numWeight, status] = str2num(readWeight);
isWeightNumber = CheckIfNumberInput(readWeight, status, logFilePath, 'weight');

readHeight = get(handles.heightEditTextBox,'String'); 
[numHeight, status] = str2num(readHeight);
isHeightNumber = CheckIfNumberInput(readHeight, status, logFilePath, 'height');

%% Check to make sure that they are in the required range
isWeightWithinBounds = false;
isHeightWithinBounds = false;
maxWeight = 100; minWeight = 40;
maxHeight = 2; minHeight = 1;

if(isWeightNumber)
    isWeightWithinBounds = CheckIfBetweenBounds(numWeight, maxWeight, minWeight, 'kg', logFilePath);
end

if(isHeightNumber)
    isHeightWithinBounds = CheckIfBetweenBounds(numHeight, maxHeight, minHeight, 'm', logFilePath);
end

%% If all of them are valid, enter the dimensions into main
if(isWeightWithinBounds && isHeightWithinBounds)
    initialLog = [  'Initial Dimensions:', newline, ...
                    '      Height: ', num2str(numHeight), 'm', newline, ...
                    '      Weight: ', num2str(numWeight), 'kg', newline];
    AppendToLog(logFilePath, initialLog);
    
    %%%%%%%% Where to call main and stuff here -- it will be validated here
    %MainToUseWithGui(numHeight, numWeight);
    SetUpThePatientGaitPanel()
    
    
    % Once the code has ran, then make the buttons visible
    set(handles.Gait_Inverse_Button,'visible','on');
    
else
    AppendToLog(logFilePath, [newline,'Please enter valid dimensions to begin the build.', newline, ...
        'Click the "More info on dimensions" button for more details on the allowed ranges of dimensions.']);
end

%% Update and read out the log once the CAD has been run
logFileText = fileread('C:\MCG4322B\Group3\Log\group3_LOG.txt');
set(handles.LogFileText, 'String', logFileText);

function boolVal = CheckIfBetweenBounds(num, maxNum, minNum, unitStr, logFilePath)
    if((num < maxNum) && (num > minNum))
        boolVal = true;
    else
        boolVal = false;
        toLog = ['ERROR: ', num2str(num), unitStr, ' is outside of the prescribed dimensions.', ...
            ' The value should be between: ', num2str(minNum), unitStr, ' and ', num2str(maxNum), unitStr, '.', newline];
        AppendToLog(logFilePath, toLog);
    end

function boolVal = CheckIfNumberInput(value, status, logFilePath, dimensionName)
    if(status == 0)
        boolVal = false;
        toLog = ['ERROR: An invalid number was inputted for the ', dimensionName, '.', ...
            ' The value of "', value, '" was entered.', newline];
        AppendToLog(logFilePath, toLog);
    else
        boolVal = true;
    end

function AppendToLog(logFilePath, stringToPut)
    logFile = fopen(logFilePath, 'a+'); % Log file to append to
        fprintf(logFile, stringToPut);
    fclose(logFile);

% --- Executes on button press in PopoutLogFileButton.
function PopoutLogFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to PopoutLogFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run DisplayLogFile.m;
