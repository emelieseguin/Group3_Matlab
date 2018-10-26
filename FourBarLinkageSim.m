function FourBarLinkageSim(fourBarArray)   
    global barIndex;
    barIndex = 1;

    % Labels on the GUI
    global intersectPoint;  
    
    % Create a UI figure window
    fig = uifigure;
    
    % Create labels on GUI
    intersectPoint = uilabel(fig, 'Position',[460, 240, 100, 20]); 

    % Create the axis to draw on - positioning is [left bottom width height]
    ax = uiaxes(fig, 'Position',[50 50 400 400], 'GridLineStyle', 'none');
    ax.XLim = [-100 100];
    ax.YLim = [-100 100];
    set(ax, 'visible', 'off')    
    
    % Create the 3 UI buttons  
    nextBtn = uibutton(fig,'Position',[440, 30, 100, 22],'Text','Next Position', ...
        'ButtonPushedFcn', @(nextBtn,event) MoveToNextGaitPositionOnClick(nextBtn,ax, fourBarArray));
    previousBtn = uibutton(fig,'Position',[40, 30, 100, 22],'Text','Previous Position', ...
        'ButtonPushedFcn', @(previousBtn,event) MoveToPreviousGaitPositionOnClick(previousBtn,ax, fourBarArray));
    
    simBtn = uibutton(fig,'Position',[460, 150, 75, 20],'Text','Run Sim', ...
        'ButtonPushedFcn', @(previousBtn,event) RunFullGaitSimOnClick(previousBtn,ax, fourBarArray));
    
    DrawCurrentPosition(ax, fourBarArray);
end

function MoveToNextGaitPositionOnClick(nextBtn, ax, fourBarArray)
        global barIndex;
        RemoveCurrentDrawing(); 
        
        % If it is the last postion, loop to the first position of the array
        if(barIndex == length(fourBarArray))
            barIndex = 1;
        else
            barIndex = barIndex +1;
        end
        DrawCurrentPosition(ax, fourBarArray);
end

function MoveToPreviousGaitPositionOnClick(previousBtn, ax, fourBarArray)
        global barIndex;
        RemoveCurrentDrawing();
        
        % If it is the first postion, loop to the end of the array
        if(barIndex == 1)
            barIndex = length(fourBarArray);
        else
            barIndex = barIndex -1;
        end
        DrawCurrentPosition(ax, fourBarArray);    
end

function RunFullGaitSimOnClick(simBtn, ax, fourBarArray)
    global barIndex;
    RemoveCurrentDrawing();
    
    % Store barIndex so that it can be set back to the previous frame after
    % the loop
    previousIndex = barIndex;
    barIndex=1;
    
    for num = 1:(length(fourBarArray))
       DrawCurrentPosition(ax, fourBarArray);
       pause(.02);
       RemoveCurrentDrawing();
       barIndex = barIndex + 1;
    end
    
    barIndex = previousIndex;
    DrawCurrentPosition(ax, fourBarArray);
end

function RemoveCurrentDrawing()
    global Link1Line Link2Line Link3Line Link4Line;
    clearpoints(Link1Line);
    clearpoints(Link2Line);
    clearpoints(Link3Line); 
    clearpoints(Link4Line); 

end

function DrawCurrentPosition(ax, fourBarArray)
    global barIndex Link1Line Link2Line Link3Line Link4Line;
    global intersectPoint;
    % Draw the lines for the 4 linkages
    Link1Line = animatedline(fourBarArray(barIndex).Link1X, fourBarArray(barIndex).Link1Y,'Parent', ax,'Color','r','LineWidth',3);
    Link2Line = animatedline(fourBarArray(barIndex).Link2X, fourBarArray(barIndex).Link2Y,'Parent', ax,'Color','r','LineWidth',3);
    Link3Line = animatedline(fourBarArray(barIndex).Link3X, fourBarArray(barIndex).Link3Y,'Parent', ax,'Color','b','LineWidth',3);
    Link4Line = animatedline(fourBarArray(barIndex).Link4X, fourBarArray(barIndex).Link4Y,'Parent', ax,'Color','b','LineWidth',3);
    
    % Add label to the GUI
    intersectPoint.Text = ['Intersection (X,Y): (' , num2str(round(fourBarArray(barIndex).IntersectPointX)), ...
        ',', num2str(round(fourBarArray(barIndex).IntersectPointY)), ')'] ;
end
    