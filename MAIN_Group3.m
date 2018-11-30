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

% Last Modified by GUIDE v2.5 27-Nov-2018 21:19:22

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
set(handles.exoinversePanel, 'visible', 'off');

% Make certain buttons invisible until created from build
set(handles.fourBarButton,'visible','off');
set(handles.patientGaitButton,'visible','off');
set(handles.dorsiflexionButton,'visible','off');
set(handles.plantarflexionButton,'visible','off');
set(handles.Gait_Inverse_Button,'visible','off');
set(handles.ExoInverseButton,'visible','off');

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
set(handles.exoinversePanel, 'visible', 'off');

%% ------------------------ Patient Gait ---------------------------------%
% --- Executes on button press in patientGaitButton.
function patientGaitButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'on');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');

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
xlabel('Percent Gait (%)');

grid on
% Foot Graph
plot(handles.footAngles, 0:length(patientAngles.LFootAngleZ)-1, patientAngles.LFootAngleZ, 'LineWidth',2);
axes(handles.footAngles);
grid on

%% Code to set the Sim
axes(handles.basicGaitSimAxes);
cla reset; 

setappdata(handles.patientGaitPanel, 'gaitIndex', 1);
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
DrawLeg(gaitPositionArray, handles.basicGaitSimAxes, handles);

%% Set the labels
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
set(handles.hipAngleLabel, 'String', round(gaitPositionArray(1).HipAngleZ, 1));
set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(1).KneeAngleZ, 1));
set(handles.footAngleLabel, 'String', round(gaitPositionArray(1).FootAngleZ, 1));
set(handles.basicGaitPercentGaitLabel, 'String', 0);


function gaitSimNextButton_Callback(hObject, eventdata, handles)
gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');

axes(handles.basicGaitSimAxes);
cla reset;

if(gaitIndex == length(gaitPositionArray))
    setappdata(handles.patientGaitPanel, 'gaitIndex', 1);
else
    setappdata(handles.patientGaitPanel, 'gaitIndex', gaitIndex + 1);
end

DrawLeg(gaitPositionArray, handles.basicGaitSimAxes, handles);
gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
set(handles.hipAngleLabel, 'String', round(gaitPositionArray(gaitIndex).HipAngleZ, 1));
set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(gaitIndex).KneeAngleZ, 1));
set(handles.footAngleLabel, 'String', round(gaitPositionArray(gaitIndex).FootAngleZ, 1));
set(handles.basicGaitPercentGaitLabel, 'String', gaitIndex-1);


% --- Executes on button press in gaitSimPrevButton.
function gaitSimPrevButton_Callback(hObject, eventdata, handles)
gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');

axes(handles.basicGaitSimAxes);
cla reset;

if(gaitIndex == 1)
    setappdata(handles.patientGaitPanel, 'gaitIndex', length(gaitPositionArray));
else
    setappdata(handles.patientGaitPanel, 'gaitIndex', gaitIndex - 1);
end

DrawLeg(gaitPositionArray, handles.basicGaitSimAxes, handles);
gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
set(handles.hipAngleLabel, 'String', round(gaitPositionArray(gaitIndex).HipAngleZ, 1));
set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(gaitIndex).KneeAngleZ, 1));
set(handles.footAngleLabel, 'String', round(gaitPositionArray(gaitIndex).FootAngleZ, 1));
set(handles.basicGaitPercentGaitLabel, 'String', gaitIndex-1);


% --- Executes on button press in gaitSimFullButton.
function gaitSimFullButton_Callback(hObject, eventdata, handles)

gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
previousIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');

setappdata(handles.patientGaitPanel, 'gaitIndex', 1);
axes(handles.basicGaitSimAxes);
cla reset;

for num = 1:length(gaitPositionArray)
    DrawLeg(gaitPositionArray, handles.basicGaitSimAxes, handles);
    pause(.02);
        
    cla reset; 
    gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
    setappdata(handles.patientGaitPanel, 'gaitIndex', gaitIndex+1);
    
    set(handles.hipAngleLabel, 'String', round(gaitPositionArray(gaitIndex).HipAngleZ, 1));
    set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(gaitIndex).KneeAngleZ, 1));
    set(handles.footAngleLabel, 'String', round(gaitPositionArray(gaitIndex).FootAngleZ, 1));
    set(handles.basicGaitPercentGaitLabel, 'String', gaitIndex-1);
end

    setappdata(handles.patientGaitPanel, 'gaitIndex', previousIndex);
    set(handles.hipAngleLabel, 'String', round(gaitPositionArray(previousIndex).HipAngleZ, 1));
    set(handles.kneeAngleLabel, 'String', round(gaitPositionArray(previousIndex).KneeAngleZ, 1));
    set(handles.footAngleLabel, 'String', round(gaitPositionArray(previousIndex).FootAngleZ, 1));
    set(handles.basicGaitPercentGaitLabel, 'String', previousIndex-1);
    DrawLeg(gaitPositionArray, handles.basicGaitSimAxes, handles);


function DrawLeg(gaitPositionArray, axesToDrawOn, handles)
    gaitIndex = getappdata(handles.patientGaitPanel, 'gaitIndex');
    
    ThighLine = animatedline(gaitPositionArray(gaitIndex).ThighPositionX, gaitPositionArray(gaitIndex).ThighPositionY,'Parent', axesToDrawOn, 'Color','r','LineWidth',1.5);
    ShankLine = animatedline(gaitPositionArray(gaitIndex).ShankPositionX, gaitPositionArray(gaitIndex).ShankPositionY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
    AnkleToCalcLine = animatedline(gaitPositionArray(gaitIndex).AnkleToCalcX, gaitPositionArray(gaitIndex).AnkleToCalcY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
    AnkleToMetaLine = animatedline(gaitPositionArray(gaitIndex).AnkleToMetaX, gaitPositionArray(gaitIndex).AnkleToMetaY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
    CalcToToeLine = animatedline(gaitPositionArray(gaitIndex).CalcToToeX, gaitPositionArray(gaitIndex).CalcToToeY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
    
    set(axesToDrawOn,'XColor','none', 'YColor', 'none')
    axesToDrawOn.XLim = [-0.5 1];
    axesToDrawOn.YLim = [-1 0.5];
    setappdata(handles.patientGaitPanel, 'ThighLine', ThighLine)
    setappdata(handles.patientGaitPanel, 'ShankLine', ShankLine)
    setappdata(handles.patientGaitPanel, 'AnkleToCalcLine', AnkleToCalcLine)
    setappdata(handles.patientGaitPanel, 'AnkleToMetaLine', AnkleToMetaLine) 
    setappdata(handles.patientGaitPanel, 'CalcToToeLine', CalcToToeLine)
    
function DrawLegWithIndex(gaitPositionArray, axesToDrawOn, index, handles)
ThighLine = animatedline(gaitPositionArray(index).ThighPositionX, gaitPositionArray(index).ThighPositionY,'Parent', axesToDrawOn, 'Color','r','LineWidth',1.5);
ShankLine = animatedline(gaitPositionArray(index).ShankPositionX, gaitPositionArray(index).ShankPositionY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
AnkleToCalcLine = animatedline(gaitPositionArray(index).AnkleToCalcX, gaitPositionArray(index).AnkleToCalcY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
AnkleToMetaLine = animatedline(gaitPositionArray(index).AnkleToMetaX, gaitPositionArray(index).AnkleToMetaY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);
CalcToToeLine = animatedline(gaitPositionArray(index).CalcToToeX, gaitPositionArray(index).CalcToToeY,'Parent', axesToDrawOn,'Color','r','LineWidth',1.5);

set(axesToDrawOn,'XColor','none', 'YColor', 'none')
axesToDrawOn.XLim = [-0.5 1];
axesToDrawOn.YLim = [-1 0.5];
setappdata(handles.patientGaitPanel, 'ThighLine', ThighLine)
setappdata(handles.patientGaitPanel, 'ShankLine', ShankLine)
setappdata(handles.patientGaitPanel, 'AnkleToCalcLine', AnkleToCalcLine)
setappdata(handles.patientGaitPanel, 'AnkleToMetaLine', AnkleToMetaLine) 
setappdata(handles.patientGaitPanel, 'CalcToToeLine', CalcToToeLine)


%% -------------------------------- 4 Bar Panel ---------------------------%
% --- Executes on button press in fourBarButton.
function fourBarButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'on');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');
set(handles.exoinversePanel, 'visible', 'off');

%% Plot the stability graphs
axes(handles.yStabilityAxes)
cla reset; 
kneePointYArray = getappdata(handles.fourBarPanel, 'kneePointYArray');
intersectPointYArray = getappdata(handles.fourBarPanel, 'intersectPointYArray');
plot(handles.yStabilityAxes, 0:length(kneePointYArray)-1, kneePointYArray, 'LineWidth',2, 'color', 'black');
hold on
plot(handles.yStabilityAxes, 0:length(intersectPointYArray)-1, intersectPointYArray, 'LineWidth',2, 'color', 'red');
grid on
ylabel('Y Coordinate (m)');
xlabel('Percent Gait (%)');
legend('Knee Center','4Bar Intersect')

axes(handles.xStabilityAxes)
cla reset; 
kneePointXArray = getappdata(handles.fourBarPanel, 'kneePointXArray');
intersectPointXArray = getappdata(handles.fourBarPanel, 'intersectPointXArray');
plot(handles.xStabilityAxes, 0:length(kneePointXArray)-1, kneePointXArray, 'LineWidth',2, 'color', 'black');
hold on
plot(handles.xStabilityAxes, 0:length(intersectPointXArray)-1, intersectPointXArray, 'LineWidth',2, 'color', 'red');
grid on
ylabel('X Coordinate (m)');
xlabel('Percent Gait (%)');
legend('Knee Center','4Bar Intersect')

%% Code to implement sims

axes(handles.fourBarSimAxes);
cla reset; 

setappdata(handles.fourBarPanel, 'fourBarIndex', 1);
fourBarPositionArray = getappdata(handles.fourBarPanel, 'fourBarPositionArray');
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');

DrawLegWithIndex(gaitPositionArray, handles.fourBarSimAxes, 1, handles);
DrawFourBar(fourBarPositionArray, handles.fourBarSimAxes, handles);
set(handles.fourBarPercentGaitLabel, 'String', 0);


% --- Executes on button press in fourBarSimFull.
function fourBarSimFull_Callback(hObject, eventdata, handles)
    fourBarPositionArray = getappdata(handles.fourBarPanel, 'fourBarPositionArray');
    gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
    
    % Keep previous index to restore it by the end
    previousIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    setappdata(handles.fourBarPanel, 'fourBarIndex', 1);
    axes(handles.fourBarSimAxes);
    cla reset; 
    
    for num = 1:(length(fourBarPositionArray))
        DrawLegWithIndex(gaitPositionArray, handles.fourBarSimAxes, num, handles)
        DrawFourBar(fourBarPositionArray, handles.fourBarSimAxes, handles)
        pause(.02);
        
        cla reset; 
        fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
        setappdata(handles.fourBarPanel, 'fourBarIndex', fourBarIndex + 1);
        set(handles.fourBarPercentGaitLabel, 'String', fourBarIndex-1);
    end
    
    setappdata(handles.fourBarPanel, 'fourBarIndex', previousIndex);
    set(handles.fourBarPercentGaitLabel, 'String', previousIndex-1);
    DrawLegWithIndex(gaitPositionArray, handles.fourBarSimAxes, previousIndex, handles);
    DrawFourBar(fourBarPositionArray, handles.fourBarSimAxes, handles);
    

% --- Executes on button press in fourBarSimNext.
function fourBarSimNext_Callback(hObject, eventdata, handles)
    fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    fourBarPositionArray = getappdata(handles.fourBarPanel, 'fourBarPositionArray');    
    gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');

    axes(handles.fourBarSimAxes);
    cla reset; 
    %RemoveFourBarDrawing(handles);
    if(fourBarIndex == length(fourBarPositionArray))
        setappdata(handles.fourBarPanel, 'fourBarIndex', 1);
    else
        setappdata(handles.fourBarPanel, 'fourBarIndex', fourBarIndex+1);
    end
    fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    
    DrawLegWithIndex(gaitPositionArray, handles.fourBarSimAxes, fourBarIndex, handles)
    DrawFourBar(fourBarPositionArray, handles.fourBarSimAxes, handles);
    set(handles.fourBarPercentGaitLabel, 'String', fourBarIndex-1);
      

% --- Executes on button press in fourBarSimPrev.
function fourBarSimPrev_Callback(hObject, eventdata, handles)
    fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    fourBarPositionArray = getappdata(handles.fourBarPanel, 'fourBarPositionArray'); 
    gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
    
    axes(handles.fourBarSimAxes);
	cla reset; 
    %RemoveFourBarDrawing(handles);
    if(fourBarIndex == 1)
        setappdata(handles.fourBarPanel, 'fourBarIndex', length(fourBarPositionArray));
    else
        setappdata(handles.fourBarPanel, 'fourBarIndex', fourBarIndex-1);
    end
    fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    
    DrawLegWithIndex(gaitPositionArray, handles.fourBarSimAxes, fourBarIndex, handles)
    DrawFourBar(fourBarPositionArray, handles.fourBarSimAxes, handles);
    set(handles.fourBarPercentGaitLabel, 'String', fourBarIndex-1);
 

function DrawFourBar(fourBarArray, axesToDrawOn, handles)
    fourBarIndex = getappdata(handles.fourBarPanel, 'fourBarIndex');
    fourBarLine1 = animatedline(fourBarArray(fourBarIndex).Link1X, fourBarArray(fourBarIndex).Link1Y,'Parent', axesToDrawOn,'Color','b','LineWidth',1);
    fourBarLine2 = animatedline(fourBarArray(fourBarIndex).Link2X, fourBarArray(fourBarIndex).Link2Y,'Parent', axesToDrawOn,'Color','b','LineWidth',1);
    fourBarLine3 = animatedline(fourBarArray(fourBarIndex).Link3X, fourBarArray(fourBarIndex).Link3Y,'Parent', axesToDrawOn,'Color','b','LineWidth',1);
    fourBarLine4 = animatedline(fourBarArray(fourBarIndex).Link4X, fourBarArray(fourBarIndex).Link4Y,'Parent', axesToDrawOn,'Color','b','LineWidth',1);
    set(axesToDrawOn,'XColor','none', 'YColor', 'none')
    %axesToDrawOn.XLim = [-0.25 1];
    %axesToDrawOn.YLim = [-1 0.25];
    setappdata(handles.fourBarPanel, 'fourBarLine1', fourBarLine1)
    setappdata(handles.fourBarPanel, 'fourBarLine2', fourBarLine2)
    setappdata(handles.fourBarPanel, 'fourBarLine3', fourBarLine3)
    setappdata(handles.fourBarPanel, 'fourBarLine4', fourBarLine4)     
    
%function RemoveFourBarDrawing(handles)

%    fourBarLine1 = getappdata(handles.fourBarPanel, 'fourBarLine1');
%    fourBarLine2 = getappdata(handles.fourBarPanel, 'fourBarLine2');
%    fourBarLine3 = getappdata(handles.fourBarPanel, 'fourBarLine3');
%    fourBarLine4 = getappdata(handles.fourBarPanel, 'fourBarLine4');
%    clearpoints(fourBarLine1);
%    clearpoints(fourBarLine2);
%    clearpoints(fourBarLine3); 
%    clearpoints(fourBarLine4); 



%% ------------------------------ Dorsiflexion Panel ----------------------%
% --- Executes on button press in dorsiflexionButton.
function dorsiflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'on');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');
set(handles.exoinversePanel, 'visible', 'off');
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
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
dorsiSpringAndCablePosition = getappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCablePosition')

DrawLegWithIndex(gaitPositionArray, handles.plantarSpringSimAxes, 1, handles);
setappdata(handles.dorsiflexionPanel, 'dorsiIndex', 1);
set(handles.dorsiSpringExtensionLabel, 'String', round(dorsiSpringLengthArray(1), 2));



% --- Executes on button press in simDorsiSpringPrev.
function simDorsiSpringPrev_Callback(hObject, eventdata, handles)


% --- Executes on button press in simDorsiSpringNext.
function simDorsiSpringNext_Callback(hObject, eventdata, handles)


% --- Executes on button press in simDorsiSpringFull.
function simDorsiSpringFull_Callback(hObject, eventdata, handles)



%% --------------------------- Plantarflexion Panel -----------------------%
% --- Executes on button press in plantarflexionButton.
function plantarflexionButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'on');
set(handles.inversePanel, 'visible', 'off');
set(handles.exoinversePanel, 'visible', 'off');
% Show Spring and Cable Length
plantarSpringAndCableLengthArray = getappdata(handles.plantarflexionPanel, 'plantarSpringAndCableLengthArray')
plot(handles.plantarSpringCableLengthAxes, 0:length(plantarSpringAndCableLengthArray)-1, plantarSpringAndCableLengthArray, 'LineWidth',2);
axes(handles.plantarSpringCableLengthAxes);
ylabel('Length (m)');
grid on
% Show just the spring length
plantarSpringLengthArray = getappdata(handles.plantarflexionPanel, 'plantarSpringLengthArray')
plot(handles.plantarSpringExtensionAxes, 0:length(plantarSpringLengthArray)-1, plantarSpringLengthArray, 'LineWidth',2);
axes(handles.plantarSpringExtensionAxes);
ylabel('Length (m)');
grid on
% Array used for the sim
gaitPositionArray = getappdata(handles.patientGaitPanel, 'gaitPositionArray');
plantarSpringAndCablePosition = getappdata(handles.plantarflexionPanel, 'plantarSpringAndCablePosition')

DrawLegWithIndex(gaitPositionArray, handles.plantarSpringSimAxes, 1, handles);
setappdata(handles.plantarflexionPanel, 'plantarIndex', 1);
set(handles.plantarSpringExtensionLabel, 'String', round(plantarSpringLengthArray(1), 2));


% --- Executes on button press in simPlantarSpringFull.
function simPlantarSpringFull_Callback(hObject, eventdata, handles)
plantarSpringAndCablePosition = getappdata(handles.plantarflexionPanel, 'plantarSpringAndCablePosition')
plantarIndex = getappdata(handles.fourBarPanel, 'plantarIndex');


% --- Executes on button press in simPlantarSpringNext.
function simPlantarSpringNext_Callback(hObject, eventdata, handles)
plantarSpringAndCablePosition = getappdata(handles.plantarflexionPanel, 'plantarSpringAndCablePosition')
plantarIndex = getappdata(handles.fourBarPanel, 'plantarIndex');


% --- Executes on button press in simPlantarSpringPrev.
function simPlantarSpringPrev_Callback(hObject, eventdata, handles)
plantarSpringAndCablePosition = getappdata(handles.plantarflexionPanel, 'plantarSpringAndCablePosition')
    plantarIndex = getappdata(handles.fourBarPanel, 'plantarIndex');



%%------------------------ Inverse TAB ------------------------------------%
% --- Executes on button press in Gait_Inverse_Button.
function Gait_Inverse_Button_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'on');
set(handles.exoinversePanel, 'visible', 'off');
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

%% -------------------------- Exoskeleton Moments Tab ---------------------%
% --- Executes on button press in ExoInverseButton.
function ExoInverseButton_Callback(hObject, eventdata, handles)
set(handles.mainContent_panel, 'visible', 'off');
set(handles.patientGaitPanel, 'visible', 'off');
set(handles.fourBarPanel, 'visible', 'off');
set(handles.dorsiflexionPanel, 'visible', 'off');
set(handles.plantarflexionPanel, 'visible', 'off');
set(handles.inversePanel, 'visible', 'off');
set(handles.exoinversePanel, 'visible', 'on');

set(handles.exoHipMoment, 'visible', 'on');
set(handles.exoKneeMoment, 'visible', 'off');
set(handles.exoAnkleMoment, 'visible', 'off');

set(handles.hipMomentOriginalCheckBox,'value',1)
set(handles.hipMomentExoCheckBox,'value',1)
set(handles.hipMomentTorsionalSpringCheckBox,'value',0)

axes(handles.exoHipMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

% Plot Exo and Basic Moments of Hip
overallExoHipMoment = getappdata(handles.exoinversePanel, 'overallExoHipMoment');
plot(handles.exoHipMomentGraph, 0:length(overallExoHipMoment)-1, overallExoHipMoment, 'LineWidth', 2, 'color', 'black');
grid on
hold on
basicHipMoments = getappdata(handles.inversePanel, 'basicHipMoments');
plot(handles.exoHipMomentGraph, 0:length(basicHipMoments)-1, basicHipMoments, 'LineWidth', 2, 'color', 'blue');
grid on
hold on


%-------------------------- HIP ------------------------------------%
% --- Executes on button press in exoHipMomentButton.
function exoHipMomentButton_Callback(hObject, eventdata, handles)
set(handles.exoHipMoment, 'visible', 'on');
set(handles.exoKneeMoment, 'visible', 'off');
set(handles.exoAnkleMoment, 'visible', 'off');

set(handles.hipMomentOriginalCheckBox,'value',1)
set(handles.hipMomentExoCheckBox,'value',1)
set(handles.hipMomentTorsionalSpringCheckBox,'value',0)

axes(handles.exoHipMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

% Plot Exo and Basic Moments of Hip
overallExoHipMoment = getappdata(handles.exoinversePanel, 'overallExoHipMoment');
plot(handles.exoHipMomentGraph, 0:length(overallExoHipMoment)-1, overallExoHipMoment, 'LineWidth', 2, 'color', 'black');
grid on
hold on
basicHipMoments = getappdata(handles.inversePanel, 'basicHipMoments');
plot(handles.exoHipMomentGraph, 0:length(basicHipMoments)-1, basicHipMoments, 'LineWidth', 2, 'color', 'blue');
grid on
hold on

% --- Executes on button press in updateExoHipMomentGraph.
function updateExoHipMomentGraph_Callback(hObject, eventdata, handles)

hipMomentOriginalPlot = get(handles.hipMomentOriginalCheckBox, 'Value');
hipMomentExoPlot = get(handles.hipMomentExoCheckBox, 'Value');
hipSpringMomentPlot = get(handles.hipMomentTorsionalSpringCheckBox, 'Value');

axes(handles.exoHipMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

if(hipMomentOriginalPlot)
    basicHipMoments = getappdata(handles.inversePanel, 'basicHipMoments');
    plot(handles.exoHipMomentGraph, 0:length(basicHipMoments)-1, basicHipMoments, 'LineWidth', 2, 'color', 'blue');
    grid on
    hold on
end

if(hipMomentExoPlot)
    overallExoHipMoment = getappdata(handles.exoinversePanel, 'overallExoHipMoment');
    plot(handles.exoHipMomentGraph, 0:length(overallExoHipMoment)-1, overallExoHipMoment, 'LineWidth', 2, 'color', 'black');
    grid on
    hold on
end

if(hipSpringMomentPlot)
    hipContributedMoments = getappdata(handles.inversePanel, 'hipContributedMoments');
    plot(handles.exoHipMomentGraph, 0:length(hipContributedMoments)-1, hipContributedMoments, 'LineWidth', 2, 'color', 'red');
    grid on
    hold on
end

%-------------------------- KNEE ------------------------------------%
% --- Executes on button press in exoKneeMomentButton.
function exoKneeMomentButton_Callback(hObject, eventdata, handles)
set(handles.exoHipMoment, 'visible', 'off');
set(handles.exoKneeMoment, 'visible', 'on');
set(handles.exoAnkleMoment, 'visible', 'off');

set(handles.kneeMomentOriginalCheckBox,'value',1)
set(handles.kneeMomentExoCheckBox,'value',1)

axes(handles.exoKneeMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

% Plot Exo and Basic Moments of Knee
overallExoKneeMoment = getappdata(handles.exoinversePanel, 'overallExoKneeMoment');
plot(handles.exoKneeMomentGraph, 0:length(overallExoKneeMoment)-1, overallExoKneeMoment, 'LineWidth', 2, 'color', 'black');
grid on
hold on
basicKneeMoments = getappdata(handles.inversePanel, 'basicKneeMoments');
plot(handles.exoKneeMomentGraph, 0:length(basicKneeMoments)-1, basicKneeMoments, 'LineWidth', 2, 'color', 'blue');
grid on 
hold on  

% --- Executes on button press in updateExoKneeMomentGraph.
function updateExoKneeMomentGraph_Callback(hObject, eventdata, handles)
kneeMomentOriginalPlot = get(handles.kneeMomentOriginalCheckBox, 'Value');
kneeMomentExoPlot =  get(handles.kneeMomentExoCheckBox, 'Value');

axes(handles.exoKneeMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

if(kneeMomentOriginalPlot)
    basicKneeMoments = getappdata(handles.inversePanel, 'basicKneeMoments');
    plot(handles.exoKneeMomentGraph, 0:length(basicKneeMoments)-1, basicKneeMoments, 'LineWidth', 2, 'color', 'blue');
    grid on 
    hold on  
end
if(kneeMomentExoPlot)
    overallExoKneeMoment = getappdata(handles.exoinversePanel, 'overallExoKneeMoment');
    plot(handles.exoKneeMomentGraph, 0:length(overallExoKneeMoment)-1, overallExoKneeMoment, 'LineWidth', 2, 'color', 'black');
    grid on
    hold on
end


%-------------------------- ANKLE ------------------------------------%
% --- Executes on button press in exoAnkleMomentButton.
function exoAnkleMomentButton_Callback(hObject, eventdata, handles)
set(handles.exoHipMoment, 'visible', 'off');
set(handles.exoKneeMoment, 'visible', 'off');
set(handles.exoAnkleMoment, 'visible', 'on');

set(handles.ankleMomentOriginalCheckBox,'value',1)
set(handles.ankleMomentExoCheckBox,'value',1)
set(handles.ankleMomentDorsiSpringCheckBox,'value',0)
set(handles.ankleMomentPlantarSpringCheckBox,'value',0)

axes(handles.exoAnkleMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

% Plot Exo and Basic Moments of ankle
overallExoAnkleMoment = getappdata(handles.exoinversePanel, 'overallExoAnkleMoment');
plot(handles.exoAnkleMomentGraph, 0:length(overallExoAnkleMoment)-1, overallExoAnkleMoment, 'LineWidth', 2, 'color', 'black');
grid on
hold on
basicAnkleMoments = getappdata(handles.inversePanel, 'basicAnkleMoments');
plot(handles.exoAnkleMomentGraph, 0:length(basicAnkleMoments)-1, basicAnkleMoments, 'LineWidth', 2, 'color', 'blue');
grid on 
hold on


% --- Executes on button press in updateExoAnkleMomentGraph.
function updateExoAnkleMomentGraph_Callback(hObject, eventdata, handles)
ankleMomentOriginalPlot = get(handles.ankleMomentOriginalCheckBox, 'Value');
ankleMomentExoPlot =  get(handles.ankleMomentExoCheckBox, 'Value');
ankleDorsiPlot = get(handles.ankleMomentDorsiSpringCheckBox, 'Value');
anklePlantarPlot = get(handles.ankleMomentPlantarSpringCheckBox, 'Value');

axes(handles.exoAnkleMomentGraph); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.

%axes(handles.exoAnkleMomentGraph)
if(ankleMomentOriginalPlot)
    basicAnkleMoments = getappdata(handles.inversePanel, 'basicAnkleMoments');
    plot(handles.exoAnkleMomentGraph, 0:length(basicAnkleMoments)-1, basicAnkleMoments, 'LineWidth', 2, 'color', 'blue');
    grid on 
    hold on
end
if(ankleMomentExoPlot)
    overallExoAnkleMoment = getappdata(handles.exoinversePanel, 'overallExoAnkleMoment');
    plot(handles.exoAnkleMomentGraph, 0:length(overallExoAnkleMoment)-1, overallExoAnkleMoment, 'LineWidth', 2, 'color', 'black');
    %axes(handles.exoAnkleMomentGraph)
    grid on 
    hold on
end
if(ankleDorsiPlot)
    dorsiSpringContributedMoments = getappdata(handles.inversePanel, 'dorsiSpringContributedMoments');
    plot(handles.exoAnkleMomentGraph, 0:length(dorsiSpringContributedMoments)-1, dorsiSpringContributedMoments, 'LineWidth', 2, 'color', 'red');
    %axes(handles.exoAnkleMomentGraph)
    grid on 
    hold on
end
if(anklePlantarPlot)
    dorsiSpringContributedMoments = getappdata(handles.inversePanel, 'plantarSpringContributedMoments');
    plot(handles.exoAnkleMomentGraph, 0:length(dorsiSpringContributedMoments)-1, dorsiSpringContributedMoments, 'LineWidth', 2, 'color', 'green');
    grid on 
end

%ankleMomentOriginalCheckBox
%ankleMomentExoCheckBox
%ankleMomentDorsiSpringCheckBox
%ankleMomentPlantarSpringCheckBox


%basicAnkleMoments = getappdata(handles.inversePanel, 'basicAnkleMoments');
%overallExoAnkleMoment = getappdata(handles.exoinversePanel, 'overallExoAnkleMoment');
%dorsiSpringContributedMoments = getappdata(handles.inversePanel, 'dorsiSpringContributedMoments');
%dorsiSpringContributedMoments = getappdata(handles.inversePanel, 'plantarSpringContributedMoments');


%% Set variables for the basicInverseDynamics
%setappdata(handles.inversePanel, 'basicHipMoments', mainCalcs.basicInverseDynamics.MHipZ_Array);
%setappdata(handles.inversePanel, 'basicKneeMoments', mainCalcs.basicInverseDynamics.MKneeZ_Array);
%setappdata(handles.inversePanel, 'basicAnkleMoments', mainCalcs.basicInverseDynamics.MAnkleZ_Array);

%% Set variables for the exoInverseDynamics
%setappdata(handles.exoinversePanel, 'overallExoHipMoment', mainCalcs.overallExoHipMoment);
%setappdata(handles.exoinversePanel, 'overallExoKneeMoment', mainCalcs.overallExoHipMoment);
%setappdata(handles.exoinversePanel, 'overallExoAnkleMoment', mainCalcs.overallExoAnkleMoment);
%setappdata(handles.inversePanel, 'hipContributedMoments', mainCalcs.hipContributedMoments);
%setappdata(handles.inversePanel, 'dorsiSpringContributedMoments', mainCalcs.dorsiSpringContributedMoments);
%setappdata(handles.inversePanel, 'plantarSpringContributedMoments', mainCalcs.plantarSpringContributedMoments);



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
set(handles.ExoInverseButton, 'visible', 'off');

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
maxHeight = 2; minHeight = 1.5;

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
    
    %try
    SetPanelVariablesFromMain(hObject, eventdata, handles);
    
    % Once the code has ran, then make the buttons visible
    set(handles.fourBarButton,'visible','on') ;
    set(handles.patientGaitButton,'visible','on');
    set(handles.dorsiflexionButton,'visible','on');
    set(handles.plantarflexionButton,'visible','on');
    set(handles.Gait_Inverse_Button,'visible','on');
    set(handles.ExoInverseButton,'visible','on');
    
    % Update and read out the log once the CAD has been run
    logFileText = fileread('C:\MCG4322B\Group3\Log\group3_LOG.txt');
    set(handles.LogFileText, 'String', logFileText);
    %catch e
    %    set(handles.LogFileText, 'String', ['An error occured while trying to process the inputted data.', ...
    %        ' Please try another set of dimensions.', newline, 'The error was: ', e.message])
    %end
else
    AppendToLog(logFilePath, [newline,'Please enter valid dimensions to begin the build.', newline, ...
        'Click the "More info on dimensions" button for more details on the allowed ranges of dimensions.']);
end


function boolVal = CheckIfBetweenBounds(num, maxNum, minNum, unitStr, logFilePath)
    if((num <= maxNum) && (num >= minNum))
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

%% Set variabels for the 4Bar Panel
setappdata(handles.fourBarPanel, 'kneePointXArray', mainCalcs.kneePointXArray)
setappdata(handles.fourBarPanel, 'kneePointYArray', mainCalcs.kneePointYArray)
setappdata(handles.fourBarPanel, 'intersectPointXArray', mainCalcs.intersectPointXArray)
setappdata(handles.fourBarPanel, 'intersectPointYArray', mainCalcs.intersectPointYArray)
setappdata(handles.fourBarPanel, 'fourBarPositionArray', mainCalcs.fourBarPositionArray)

%% Set variables for the DorsiFlexion Panel
setappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCableLengthArray', mainCalcs.dorsiSpringAndCableLengthArray)
setappdata(handles.dorsiflexionPanel, 'dorsiSpringAndCablePosition', mainCalcs.dorsiSpringAndCablePosition)
setappdata(handles.dorsiflexionPanel, 'dorsiSpringLengthArray', mainCalcs.dorsiSpringLengthArray)

%% Set variables for the PlantarFlexion Panel
setappdata(handles.plantarflexionPanel, 'plantarSpringAndCableLengthArray', mainCalcs.plantarSpringAndCableLengthArray)
setappdata(handles.plantarflexionPanel, 'plantarSpringAndCablePosition', mainCalcs.plantarSpringAndCablePosition)
setappdata(handles.plantarflexionPanel, 'plantarSpringLengthArray', mainCalcs.plantarSpringLengthArray)

%% Set variables for the basicInverseDynamics
setappdata(handles.inversePanel, 'basicHipMoments', (-1)*mainCalcs.basicInverseDynamics.MHipZ_Array);
setappdata(handles.inversePanel, 'basicKneeMoments', (-1)*mainCalcs.basicInverseDynamics.MKneeZ_Array);
setappdata(handles.inversePanel, 'basicAnkleMoments', (-1)*mainCalcs.basicInverseDynamics.MAnkleZ_Array);

%% Set variables for the exoInverseDynamics
setappdata(handles.exoinversePanel, 'overallExoHipMoment', mainCalcs.overallExoHipMoment);
setappdata(handles.exoinversePanel, 'overallExoKneeMoment', mainCalcs.overallExoHipMoment);
setappdata(handles.exoinversePanel, 'overallExoAnkleMoment', mainCalcs.overallExoAnkleMoment);
setappdata(handles.inversePanel, 'hipContributedMoments', mainCalcs.hipContributedMoments);
setappdata(handles.inversePanel, 'dorsiSpringContributedMoments', mainCalcs.dorsiSpringContributedMoments);
setappdata(handles.inversePanel, 'plantarSpringContributedMoments', mainCalcs.plantarSpringContributedMoments);

% 
% exoInverseDynamics
%         overallExoInverseDynamics %% -- calculated this thing
%         
%         % Springs
%         hipContributedMoments
%         dorsiSpringContributedMoments
%         plantarSpringContributedMoments
%         
%         % Cams
%         dorsiTorsionContributedMoments
%         plantarTorsionContributedMoments


% --- Executes on button press in gaitSimNextButton.

% --- Executes on button press in basicAnkleFBDButton.
function basicAnkleFBDButton_Callback(hObject, eventdata, handles)
% hObject    handle to basicAnkleFBDButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function patientGaitPanel_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in hipMomentOriginalCheckBox.
function hipMomentOriginalCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to hipMomentOriginalCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hipMomentOriginalCheckBox

% --- Executes on button press in hipMomentExoCheckBox.
function hipMomentExoCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to hipMomentExoCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hipMomentExoCheckBox

% --- Executes on button press in hipMomentTorsionalSpringCheckBox.
function hipMomentTorsionalSpringCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to hipMomentTorsionalSpringCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hipMomentTorsionalSpringCheckBox

% --- Executes on button press in kneeMomentOriginalCheckBox.
function kneeMomentOriginalCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to kneeMomentOriginalCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kneeMomentOriginalCheckBox

% --- Executes on button press in kneeMomentExoCheckBox.
function kneeMomentExoCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to kneeMomentExoCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kneeMomentExoCheckBox

% --- Executes on button press in ankleMomentOriginalCheckBox.
function ankleMomentOriginalCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ankleMomentOriginalCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ankleMomentOriginalCheckBox

% --- Executes on button press in ankleMomentExoCheckBox.
function ankleMomentExoCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ankleMomentExoCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ankleMomentExoCheckBox

% --- Executes on button press in ankleMomentDorsiSpringCheckBox.
function ankleMomentDorsiSpringCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ankleMomentDorsiSpringCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ankleMomentDorsiSpringCheckBox

% --- Executes on button press in ankleMomentPlantarSpringCheckBox.
function ankleMomentPlantarSpringCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ankleMomentPlantarSpringCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ankleMomentPlantarSpringCheckBox
