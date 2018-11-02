function GaitSimulation(positionArray)   
    global index;
    index = 1;

    % Labels on the GUI
    global hipLabel kneeLabel footLabel;  
    
    % Create a UI figure window
    fig = uifigure;
    
    % Create labels on GUI
    hipLabel = uilabel(fig, 'Position',[460, 240, 100, 20]); 
    kneeLabel = uilabel(fig, 'Position',[460, 215, 100, 20]);
    footLabel = uilabel(fig, 'Position',[460, 190, 100, 20]);

    % Create the axis to draw on - positioning is [left bottom width height]
    ax = uiaxes(fig, 'Position',[50 50 400 400], 'GridLineStyle', 'none');
    ax.XLim = [-1 1];
    ax.YLim = [-1 1];
    set(ax, 'visible', 'off')    
    
    % Create the 3 UI buttons  
    nextBtn = uibutton(fig,'Position',[440, 30, 100, 22],'Text','Next Position', ...
        'ButtonPushedFcn', @(nextBtn,event) MoveToNextGaitPositionOnClick(nextBtn,ax, positionArray));
    previousBtn = uibutton(fig,'Position',[40, 30, 100, 22],'Text','Previous Position', ...
        'ButtonPushedFcn', @(previousBtn,event) MoveToPreviousGaitPositionOnClick(previousBtn,ax, positionArray));
    
    simBtn = uibutton(fig,'Position',[460, 150, 75, 20],'Text','Run Sim', ...
        'ButtonPushedFcn', @(previousBtn,event) RunFullGaitSimOnClick(previousBtn,ax, positionArray));
    
    DrawCurrentPosition(ax, positionArray);
end

function MoveToNextGaitPositionOnClick(nextBtn, ax, positionArray)
        global index;
        RemoveCurrentDrawing(); 
        
        % If it is the last postion, loop to the first position of the array
        if(index == length(positionArray))
            index = 1;
        else
            index = index +1;
        end
        DrawCurrentPosition(ax, positionArray);
end

function MoveToPreviousGaitPositionOnClick(previousBtn, ax, positionArray)
        global index;
        RemoveCurrentDrawing();
        
        % If it is the first postion, loop to the end of the array
        if(index == 1)
            index = length(positionArray);
        else
            index = index -1;
        end
        DrawCurrentPosition(ax, positionArray);    
end

function RunFullGaitSimOnClick(simBtn, ax, positionArray)
    global index;
    RemoveCurrentDrawing();
    
    % Store Index so that it can be set back to the previous frame after
    % the loop
    previousIndex = index;
    index=1;
    
    for num = 1:(length(positionArray))
       DrawCurrentPosition(ax, positionArray);
       pause(.01);
       RemoveCurrentDrawing();
       index = index + 1;
    end
    
    index = previousIndex;
    DrawCurrentPosition(ax, positionArray);
end

function RemoveCurrentDrawing()
    global ThighLine ShankLine AnkleToCalcLine AnkleToMetaLine CalcToToeLine ThighComPoint ShankComPoint FootComPoint;
    clearpoints(ThighLine);
    clearpoints(ShankLine);
    clearpoints(AnkleToCalcLine); 
    clearpoints(AnkleToMetaLine); 
    clearpoints(CalcToToeLine);
    
    clearpoints(ThighComPoint); 
    clearpoints(ShankComPoint); 
    %clearpoints(FootComPoint); 
end

function DrawCurrentPosition(ax, positionArray)
    global index ThighLine ShankLine AnkleToCalcLine AnkleToMetaLine CalcToToeLine ThighComPoint ShankComPoint FootComPoint;
    global hipLabel kneeLabel footLabel;
    % Draw the lines to define lower limb
    ThighLine = animatedline(positionArray(index).ThighPositionX, positionArray(index).ThighPositionY,'Parent', ax, 'Color','r','LineWidth',3);
    ShankLine = animatedline(positionArray(index).ShankPositionX, positionArray(index).ShankPositionY,'Parent', ax,'Color','r','LineWidth',3);
    AnkleToCalcLine = animatedline(positionArray(index).AnkleToCalcX, positionArray(index).AnkleToCalcY,'Parent', ax,'Color','r','LineWidth',3);
    AnkleToMetaLine = animatedline(positionArray(index).AnkleToMetaX, positionArray(index).AnkleToMetaY,'Parent', ax,'Color','r','LineWidth',3);
    CalcToToeLine = animatedline(positionArray(index).CalcToToeX, positionArray(index).CalcToToeY,'Parent', ax,'Color','r','LineWidth',3);
    
    % Draw lines for the Com Pieces
    ThighComPoint = animatedline(positionArray(index).ThighComXVector, positionArray(index).ThighComYVector,'Parent', ax,'Color','b','LineWidth',3);
    ShankComPoint = animatedline(positionArray(index).ShankComXVector, positionArray(index).ShankComYVector,'Parent', ax,'Color','b','LineWidth',3);
    %FootComPoint = animatedline(positionArray(index).FootComXVector, positionArray(index).FootComYVector,'Parent', ax,'Color','b','LineWidth',3);
    
    % Add label to the GUI
    % char(176) is degree
    hipLabel.Text = ['Hip Angle: ' , num2str(round(positionArray(index).HipAngleZ)), char(176)];
    kneeLabel.Text = ['Knee Angle: ' , num2str(round(positionArray(index).KneeAngleZ)), char(176)];
    footLabel.Text = ['Foot Angle: ' , num2str(round(positionArray(index).FootAngleZ)), char(176)];  
end