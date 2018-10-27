function PlantarFlexionSpringSim(plantarFlexionArray)   
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
    ax.XLim = [-1 1];
    ax.YLim = [-1 1];
    set(ax, 'visible', 'off')    
    
    % Create the 3 UI buttons  
    nextBtn = uibutton(fig,'Position',[440, 30, 100, 22],'Text','Next Position', ...
        'ButtonPushedFcn', @(nextBtn,event) MoveToNextGaitPositionOnClick(nextBtn,ax, plantarFlexionArray));
    
    previousBtn = uibutton(fig,'Position',[40, 30, 100, 22],'Text','Previous Position', ...
        'ButtonPushedFcn', @(previousBtn,event) MoveToPreviousGaitPositionOnClick(previousBtn,ax, plantarFlexionArray));
    
    simBtn = uibutton(fig,'Position',[460, 150, 75, 20],'Text','Run Sim', ...
        'ButtonPushedFcn', @(previousBtn,event) RunFullGaitSimOnClick(previousBtn,ax, plantarFlexionArray));
    
    DrawCurrentPosition(ax, plantarFlexionArray);
end

function MoveToNextGaitPositionOnClick(nextBtn, ax, plantarFlexionArray)
        global barIndex;
        RemoveCurrentDrawing(); 
        
        % If it is the last postion, loop to the first position of the array
        if(barIndex == length(plantarFlexionArray))
            barIndex = 1;
        else
            barIndex = barIndex +1;
        end
        DrawCurrentPosition(ax, plantarFlexionArray);
end

function MoveToPreviousGaitPositionOnClick(previousBtn, ax, plantarFlexionArray)
        global barIndex;
        RemoveCurrentDrawing();
        
        % If it is the first postion, loop to the end of the array
        if(barIndex == 1)
            barIndex = length(plantarFlexionArray);
        else
            barIndex = barIndex -1;
        end
        DrawCurrentPosition(ax, plantarFlexionArray);    
end

function RunFullGaitSimOnClick(simBtn, ax, plantarFlexionArray)
    global barIndex;
    RemoveCurrentDrawing();
    
    % Store barIndex so that it can be set back to the previous frame after
    % the loop
    previousIndex = barIndex;
    barIndex=1;
    
    for num = 1:(length(plantarFlexionArray))
       DrawCurrentPosition(ax, plantarFlexionArray);
       pause(.02);
       RemoveCurrentDrawing();
       barIndex = barIndex + 1;
    end
    
    barIndex = previousIndex;
    DrawCurrentPosition(ax, plantarFlexionArray);
end

function RemoveCurrentDrawing()
    global Link1Line Link2Line Link3Line Link4Line;
    clearpoints(Link1Line);
    clearpoints(Link2Line);
    clearpoints(Link3Line); 
    clearpoints(Link4Line); 

end

function DrawCurrentPosition(ax, plantarFlexionArray)
    global barIndex Link1Line Link2Line Link3Line Link4Line;
    global springAndCableLength;
    
    % Draw the lines for the 4 linkages
    Link1Line = animatedline(plantarFlexionArray(barIndex).Link1X, plantarFlexionArray(barIndex).Link1Y,'Parent', ax,'Color','b','LineWidth',1);
    Link2Line = animatedline(plantarFlexionArray(barIndex).Link2X, plantarFlexionArray(barIndex).Link2Y,'Parent', ax,'Color','r','LineWidth',1);
    %Link3Line = animatedline(plantarFlexionArray(barIndex).Link3X, plantarFlexionArray(barIndex).Link3Y,'Parent', ax,'Color','y','LineWidth',1);
    Link4Line = animatedline(plantarFlexionArray(barIndex).Link4X, plantarFlexionArray(barIndex).Link4Y,'Parent', ax,'Color','g','LineWidth',1);
    
    springAndCableLength.Text = ['Length: ' , num2str(plantarFlexionArray(barIndex).Length)];
end