function FullSimulation(fourBarArray, positionArray)   
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
    ax.XLim = [-0.5 1];
    ax.YLim = [-1 0.5];
    set(ax, 'visible', 'off')    
    
    % Create the 3 UI buttons  
    nextBtn = uibutton(fig,'Position',[440, 30, 100, 22],'Text','Next Position', ...
        'ButtonPushedFcn', @(nextBtn,event) MoveToNextGaitPositionOnClick(nextBtn,ax, fourBarArray, positionArray));
    previousBtn = uibutton(fig,'Position',[40, 30, 100, 22],'Text','Previous Position', ...
        'ButtonPushedFcn', @(previousBtn,event) MoveToPreviousGaitPositionOnClick(previousBtn,ax, fourBarArray, positionArray));
    
    simBtn = uibutton(fig,'Position',[460, 150, 75, 20],'Text','Run Sim', ...
        'ButtonPushedFcn', @(previousBtn,event) RunFullGaitSimOnClick(previousBtn,ax, fourBarArray, positionArray));
    
    DrawCurrentLegPosition(ax, positionArray);
    DrawCurrentFourBarPosition(ax, fourBarArray);
end

function MoveToNextGaitPositionOnClick(nextBtn, ax, fourBarArray, positionArray)
        global index;
        RemoveCurrentLegDrawing(); 
        RemoveCurrentFourBarDrawing();
        
        % If it is the last postion, loop to the first position of the array
        if(index == length(positionArray))
            index = 1;
        else
            index = index +1;
        end
        DrawCurrentLegPosition(ax, positionArray);
        DrawCurrentFourBarPosition(ax, fourBarArray);
end

function MoveToPreviousGaitPositionOnClick(previousBtn, ax, fourBarArray, positionArray)
        global index;
        RemoveCurrentLegDrawing();
        RemoveCurrentFourBarDrawing();
        
        % If it is the first postion, loop to the end of the array
        if(index == 1)
            index = length(positionArray);
        else
            index = index -1;
        end
        DrawCurrentLegPosition(ax, positionArray);   
        DrawCurrentFourBarPosition(ax, fourBarArray);
end

function RunFullGaitSimOnClick(simBtn, ax, fourBarArray, positionArray)
    global index;
    RemoveCurrentLegDrawing();
    RemoveCurrentFourBarDrawing();
    
    % Store Index so that it can be set back to the previous frame after
    % the loop
    previousIndex = index;
    index=1;
    
    for num = 1:(length(positionArray))
       DrawCurrentLegPosition(ax, positionArray);
       DrawCurrentFourBarPosition(ax, fourBarArray);
       pause(.02);
       RemoveCurrentLegDrawing();
       RemoveCurrentFourBarDrawing();
       index = index + 1;
    end
    
    index = previousIndex;
    DrawCurrentLegPosition(ax, positionArray);
    DrawCurrentFourBarPosition(ax, fourBarArray);
end

function RemoveCurrentLegDrawing()
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

function DrawCurrentLegPosition(ax, positionArray)
    global index ThighLine ShankLine AnkleToCalcLine AnkleToMetaLine CalcToToeLine ThighComPoint ShankComPoint FootComPoint;
    global hipLabel kneeLabel footLabel;
    % Draw the lines to define lower limb
    ThighLine = animatedline(positionArray(index).ThighPositionX, positionArray(index).ThighPositionY,'Parent', ax, 'Color','r','LineWidth',3);
    ShankLine = animatedline(positionArray(index).ShankPositionX, positionArray(index).ShankPositionY,'Parent', ax,'Color','r','LineWidth',3);
    AnkleToCalcLine = animatedline(positionArray(index).AnkleToCalcX, positionArray(index).AnkleToCalcY,'Parent', ax,'Color','r','LineWidth',3);
    AnkleToMetaLine = animatedline(positionArray(index).AnkleToMetaX, positionArray(index).AnkleToMetaY,'Parent', ax,'Color','r','LineWidth',3);
    CalcToToeLine = animatedline(positionArray(index).CalcToToeX, positionArray(index).CalcToToeY,'Parent', ax,'Color','r','LineWidth',3);
    
    % Draw lines for the Com Pieces
    ThighComPoint = animatedline(positionArray(index).ThighComXVector, positionArray(index).ThighComYVector,'Parent', ax,'Color','r','LineWidth',3);
    ShankComPoint = animatedline(positionArray(index).ShankComXVector, positionArray(index).ShankComYVector,'Parent', ax,'Color','r','LineWidth',3);
    %FootComPoint = animatedline(positionArray(index).FootComXVector, positionArray(index).FootComYVector,'Parent', ax,'Color','r','LineWidth',3);
    
    % Add label to the GUI
    % char(176) is degree
    hipLabel.Text = ['Hip Angle: ' , num2str(round(positionArray(index).HipAngleZ)), char(176)];
    kneeLabel.Text = ['Knee Angle: ' , num2str(round(positionArray(index).KneeAngleZ)), char(176)];
    footLabel.Text = ['Foot Angle: ' , num2str(round(positionArray(index).FootAngleZ)), char(176)];  
end

function RemoveCurrentFourBarDrawing()
    global Link1Line Link2Line Link3Line Link4Line;
    clearpoints(Link1Line);
    clearpoints(Link2Line);
    clearpoints(Link3Line); 
    clearpoints(Link4Line);
end

function DrawCurrentFourBarPosition(ax, fourBarArray)
    global index Link1Line Link2Line Link3Line Link4Line;
    %global intersectPoint;
    % Draw the lines for the 4 linkages
    Link1Line = animatedline(fourBarArray(index).Link1X, fourBarArray(index).Link1Y,'Parent', ax,'Color','b','LineWidth',2);
    Link2Line = animatedline(fourBarArray(index).Link2X, fourBarArray(index).Link2Y,'Parent', ax,'Color','g','LineWidth',2);
    Link3Line = animatedline(fourBarArray(index).Link3X, fourBarArray(index).Link3Y,'Parent', ax,'Color','b','LineWidth',2);
    Link4Line = animatedline(fourBarArray(index).Link4X, fourBarArray(index).Link4Y,'Parent', ax,'Color','g','LineWidth',2);
    
    % Add label to the GUI
    %intersectPoint.Text = ['Intersection (X,Y): (' , num2str(round(fourBarArray(index).IntersectPointX)), ...
    %    ',', num2str(round(fourBarArray(index).IntersectPointY)), ')'] ;
end