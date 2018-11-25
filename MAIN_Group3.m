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

% Last Modified by GUIDE v2.5 25-Nov-2018 14:46:31

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

% Turn on the correct buttons on start
set(handles.mainContent_panel, 'visible', 'on');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% Make certain buttons invisible until created from build
set(handles.fourBarButton,'visible','off');
set(handles.patientGaitButton,'visible','off');
set(handles.dorsiflexionButton,'visible','off');
set(handles.plantarflexionButton,'visible','off');
set(handles.Gait_Inverse_Button,'visible','off');

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

%% Set the labels
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
set(handles.hipAngleLabel, 'String', round(gaitPositionArray(1).HipAngleZ, 1));
set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(1).KneeAngleZ, 1));
set(handles.footAngleLabel, 'String', round(gaitPositionArray(1).FootAngleZ, 1));

%% Set the bottom graphs
% Set the graph data
patientAngles = getappdata(handles.patientGaitPanel, 'patientAngles');
% Hip Graph
plot(handles.hipAngles, 0:length(patientAngles.LHipAngleZ)-1, patientAngles.LHipAngleZ, 'LineWidth',2);
axes(handles.hipAngles);
ylabel(['Angle (', char(176), ')']);
grid on
% Knee Graph
plot(handles.kneeAngles, 0:length(patientAngles.LKneeAngleZ)-1, patientAngles.LKneeAngleZ, 'LineWidth',2);
axes(handles.kneeAngles);
grid on
% Foot Graph
plot(handles.footAngles, 0:length(patientAngles.LFootAngleZ)-1, patientAngles.LFootAngleZ, 'LineWidth',2);
axes(handles.footAngles);
grid on


% --- Executes on button press in fourBarButton.
function fourBarButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'on');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

% ------------------------------ Dorsiflexion Panel ----------------------%
% --- Executes on button press in dorsiflexionButton.
function dorsiflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'on');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');
% Show Spring and Cable Length
dorsiSpringAndCableLengthArray = getappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCableLengthArray')
plot(handles.dorsiSpringCableLengthAxes, 0:length(dorsiSpringAndCableLengthArray)-1, dorsiSpringAndCableLengthArray, 'LineWidth',2);
axes(handles.dorsiSpringCableLengthAxes);
ylabel('Length (m)');
grid on
% Show just the spring length
dorsiSpringLengthArray = getappdata(handles.dorsiflexionPanel, 'dorsiSpringLengthArray')
plot(handles.dorsiSpringExtensionAxes, 0:length(dorsiSpringLengthArray)-1, dorsiSpringLengthArray, 'LineWidth',2);
axes(handles.dorsiSpringExtensionAxes);
ylabel('Length (m)');
grid on
% Array used for the sim
dorsiSpringAndCablePosition = getappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCablePosition')




% --- Executes on button press in plantarflexionButton.
function plantarflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'on');
set(handles.inversePanel, 'visible', 'off');

%------------------------ Inverse TAB ------------------------------------%
% --- Executes on button press in Gait_Inverse_Button.
function Gait_Inverse_Button_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'on');
set(handles.basicHipMoment, 'visible', 'on');
set(handles.basicKneeMoment, 'visible', 'off');
set(handles.basicAnkleMoment, 'visible', 'off');
axes(handles.basicHipFBD);
% Show Hip FBD
imshow('BasicThighFBD.jpg', 'InitialMagnification','fit');

% Hip Moment Graph
basicHipMoments = getappdata(handles.inversePanel, 'basicHipMoments');
plot(handles.basicHipMomentGraph, 0:length(basicHipMoments)-1, basicHipMoments, 'LineWidth',2);
axes(handles.basicHipMomentGraph);
grid on

% --- Executes on button press in basicHipMomentButton.
function basicHipMomentButton_Callback(hObject, eventdata, handles)
set(handles.basicHipMoment, 'visible', 'on');
set(handles.basicKneeMoment, 'visible', 'off');
set(handles.basicAnkleMoment, 'visible', 'off');
axes(handles.basicHipFBD);
imshow('BasicThighFBD.jpg');
% Hip Moment Graph
basicHipMoments = getappdata(handles.inversePanel, 'basicHipMoments');
plot(handles.basicHipMomentGraph, 0:length(basicHipMoments)-1, basicHipMoments, 'LineWidth',2);
axes(handles.basicHipMomentGraph);
grid on


% --- Executes on button press in basicKneeMomentButton.
function basicKneeMomentButton_Callback(hObject, eventdata, handles)
set(handles.basicHipMoment, 'visible', 'off');
set(handles.basicKneeMoment, 'visible', 'on');
set(handles.basicAnkleMoment, 'visible', 'off');
axes(handles.basicKneeFBD);
imshow('BasicShankFBD.jpg');
% Knee Moment Graph
basicKneeMoments = getappdata(handles.inversePanel, 'basicKneeMoments');
plot(handles.basicKneeMomentGraph, 0:length(basicKneeMoments)-1, basicKneeMoments, 'LineWidth',2);
axes(handles.basicKneeMomentGraph);
grid on

% --- Executes on button press in basicAnkleMomentButton.
function basicAnkleMomentButton_Callback(hObject, eventdata, handles)
set(handles.basicHipMoment, 'visible', 'off');
set(handles.basicKneeMoment, 'visible', 'off');
set(handles.basicAnkleMoment, 'visible', 'on');
% Show fbd
axes(handles.basicAnkleFBD);
imshow('BasicFootFBD.jpg');

% Knee Moment Graph
basicAnkleMoments = getappdata(handles.inversePanel, 'basicAnkleMoments');
plot(handles.basicAnkleMomentGraph, 0:length(basicAnkleMoments)-1, basicAnkleMoments, 'LineWidth',2);
axes(handles.basicAnkleMomentGraph);
grid on

%------------------------------------------------------------------------

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

% Make build buttons invisible once the build is selected and not finished
set(handles.fourBarButton,'visible','off');
set(handles.patientGaitButton,'visible','off');
set(handles.dorsiflexionButton,'visible','off');
set(handles.plantarflexionButton,'visible','off');
set(handles.Gait_Inverse_Button,'visible','off');

logFilePath = 'C:\MCG4322B\Group3\Log\group3_LOG.txt';
% New trial - delete the old log file
if exist(logFilePath, 'file')==2
  delete(logFilePath);
end

%% Read in the input variables from the user, check if they are numbers
readMass = get(handles.weightEditTextBox,'String');
[numMass, status] = str2num(readMass);
isMassNumber = CheckIfNumberInput(readMass, status, logFilePath, 'weight');

readHeight = get(handles.heightEditTextBox,'String'); 
[numHeight, status] = str2num(readHeight);
isHeightNumber = CheckIfNumberInput(readHeight, status, logFilePath, 'height');

%% Check to make sure that they are in the required range
isWeightWithinBounds = false;
isHeightWithinBounds = false;
maxMass = 100; minMass = 40;
maxHeight = 2; minHeight = 1;

if(isMassNumber)
    isWeightWithinBounds = CheckIfBetweenBounds(numMass, maxMass, minMass, 'kg', logFilePath);
end

if(isHeightNumber)
    isHeightWithinBounds = CheckIfBetweenBounds(numHeight, maxHeight, minHeight, 'm', logFilePath);
end

%% If all of them are valid, enter the dimensions into main
if(isWeightWithinBounds && isHeightWithinBounds)
    initialLog = [  'Initial Dimensions:', newline, ...
                    '      Height: ', num2str(numHeight), 'm', newline, ...
                    '      Weight: ', num2str(numMass), 'kg', newline];
    AppendToLog(logFilePath, initialLog);
    
    %% Update the log window - Update user
    set(handles.LogFileText, 'String', ['Running the code to build all components, ', ...
        'this may take a minute.']);
    pause(0.01); % allow time for the update to occur
    % Store the inputted data
    setappdata(handles.mainContent_panel, 'mass', numMass)
    setappdata(handles.mainContent_panel, 'height', numHeight)
    
     %%%%%%%% Where to call main and stuff here -- it will be validated here
    %MainToUseWithGui(numHeight, numWeight);
    SetPanelVariablesFromMain(hObject, eventdata, handles);
    
    % Once the code has ran, then make the buttons visible
    set(handles.fourBarButton,'visible','on');
    set(handles.patientGaitButton,'visible','on');
    set(handles.dorsiflexionButton,'visible','on');
    set(handles.plantarflexionButton,'visible','on');
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

function SetPanelVariablesFromMain(hObject, eventdata, handles)

% Get the inputted dimensions to put to main
inputtedMass = getappdata(handles.mainContent_panel, 'mass');
inputtedHeight = getappdata(handles.mainContent_panel, 'height');

mainCalcs = MainToUseWithGui(inputtedHeight, inputtedMass);

%% Set variables for the patientGaitPanel
setappdata(handles.patientGaitPanel, 'gaitPositionArray', mainCalcs.gaitPositionArray)
setappdata(handles.patientGaitPanel, 'patientAngles', mainCalcs.patientAngles)

%% Set variables for the DorsiFlexion Panel
setappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCableLengthArray', mainCalcs.dorsiSpringAndCableLengthArray)
setappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCablePosition', mainCalcs.dorsiSpringAndCablePosition)
setappdata(handles.dorsiflexionPanel, 'dorsiSpringLengthArray', mainCalcs.dorsiSpringLengthArray)

%% Set variables for the basicInverseDynamics
setappdata(handles.inversePanel, 'basicHipMoments', mainCalcs.basicInverseDynamics.MHipZ_Array);
setappdata(handles.inversePanel, 'basicKneeMoments', mainCalcs.basicInverseDynamics.MKneeZ_Array);
setappdata(handles.inversePanel, 'basicAnkleMoments', mainCalcs.basicInverseDynamics.MAnkleZ_Array);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in basicAnkleFBDButton.
function basicAnkleFBDButton_Callback(hObject, eventdata, handles)
% hObject    handle to basicAnkleFBDButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in simDorsiSpringPrev.
function simDorsiSpringPrev_Callback(hObject, eventdata, handles)
% hObject    handle to simDorsiSpringPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in simDorsiSpringNext.
function simDorsiSpringNext_Callback(hObject, eventdata, handles)
% hObject    handle to simDorsiSpringNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in simDorsiSpringFull.
function simDorsiSpringFull_Callback(hObject, eventdata, handles)
% hObject    handle to simDorsiSpringFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function patientGaitPanel_CreateFcn(hObject, eventdata, handles)
