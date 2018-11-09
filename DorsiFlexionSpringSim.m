function DorsiFlexionSpringSim(dorsiFlexionArray)   
    global barIndex;
    barIndex = 1;

    % Labels on the GUI
    global springAndCableLength;  
    
    % Create a UI figure window
    fig = uifigure;
    
    % Create labels on GUI
    springAndCableLength = uilabel(fig, 'Position',[460, 240, 100, 20]); 

    % Create the axis to draw on - positioning is [left bottom width height]
    ax = uiaxes(fig, 'Position',[10 10 400 400], 'GridLineStyle', 'none');
    ax.XLim = [-2 2];
    ax.YLim = [-2 2];
    set(ax, 'visible', 'off')    
    
    % Create the 3 UI buttons  
    nextBtn = uibutton(fig,'Position',[440, 30, 100, 22],'Text','Next Position', ...
        'ButtonPushedFcn', @(nextBtn,event) MoveToNextGaitPositionOnClick(nextBtn,ax, dorsiFlexionArray));
    
    previousBtn = uibutton(fig,'Position',[40, 30, 100, 22],'Text','Previous Position', ...
        'ButtonPushedFcn', @(previousBtn,event) MoveToPreviousGaitPositionOnClick(previousBtn,ax, dorsiFlexionArray));
    
    simBtn = uibutton(fig,'Position',[460, 150, 75, 20],'Text','Run Sim', ...
        'ButtonPushedFcn', @(previousBtn,event) RunFullGaitSimOnClick(previousBtn,ax, dorsiFlexionArray));
    
    DrawCurrentPosition(ax, dorsiFlexionArray);
end

function MoveToNextGaitPositionOnClick(nextBtn, ax, dorsiFlexionArray)
        global barIndex;
        RemoveCurrentDrawing(); 
        
        % If it is the last postion, loop to the first position of the array
        if(barIndex == length(dorsiFlexionArray))
            barIndex = 1;
        else
            barIndex = barIndex +1;
        end
        DrawCurrentPosition(ax, dorsiFlexionArray);
end

function MoveToPreviousGaitPositionOnClick(previousBtn, ax, dorsiFlexionArray)
        global barIndex;
        RemoveCurrentDrawing();
        
        % If it is the first postion, loop to the end of the array
        if(barIndex == 1)
            barIndex = length(dorsiFlexionArray);
        else
            barIndex = barIndex -1;
        end
        DrawCurrentPosition(ax, dorsiFlexionArray);    
end

function RunFullGaitSimOnClick(simBtn, ax, dorsiFlexionArray)
    global barIndex;
    RemoveCurrentDrawing();
    
    % Store barIndex so that it can be set back to the previous frame after
    % the loop
    previousIndex = barIndex;
    barIndex=1;
    
    for num = 1:(length(dorsiFlexionArray))
       DrawCurrentPosition(ax, dorsiFlexionArray);
       pause(.02);
       RemoveCurrentDrawing();
       barIndex = barIndex + 1;
    end
    
    barIndex = previousIndex;
    DrawCurrentPosition(ax, dorsiFlexionArray);
end

function RemoveCurrentDrawing()
    global Link1Line Link2Line Link3Line Link4Line Link5Line;
    clearpoints(Link1Line);
    clearpoints(Link2Line);
    clearpoints(Link3Line); 
    %clearpoints(Link4Line);
    %clearpoints(Link5Line);

end

function DrawCurrentPosition(ax, dorsiFlexionArray)
    global barIndex Link1Line Link2Line Link3Line Link4Line Link5Line;
    global springAndCableLength;
    
    % Draw the lines for the 4 linkages
    Link1Line = animatedline(dorsiFlexionArray(barIndex).Link1X, dorsiFlexionArray(barIndex).Link1Y,'Parent', ax,'Color','b','LineWidth',1);
    Link2Line = animatedline(dorsiFlexionArray(barIndex).Link2X, dorsiFlexionArray(barIndex).Link2Y,'Parent', ax,'Color','r','LineWidth',1);
    Link3Line = animatedline(dorsiFlexionArray(barIndex).Link3X, dorsiFlexionArray(barIndex).Link3Y,'Parent', ax,'Color','b','LineWidth',1);
    %Link4Line = animatedline(dorsiFlexionArray(barIndex).Link4X, dorsiFlexionArray(barIndex).Link4Y,'Parent', ax,'Color','r','LineWidth',1);
    %Link5Line = animatedline(dorsiFlexionArray(barIndex).Link5X, dorsiFlexionArray(barIndex).Link5Y,'Parent', ax,'Color','b','LineWidth',1);
    
    springAndCableLength.Text = ['Length: ' , num2str(dorsiFlexionArray(barIndex).Length)];
end