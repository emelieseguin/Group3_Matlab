classdef PlantarFlexionSpringPosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
        Link4X
        Link4Y
        
        Length
    end
    
    methods
        function obj = PlantarFlexionSpringPosition(personHeight, ankleJointXPos, ankleJointYPos, ...
                ankleAngleZ, footAngleZ, kneeJointXPos, kneeJointYPos, kneeAngleZ, hipAngleZ)
            
            % Above will need to be changed in order to receive the radius
            % of the calf, and take away ankleAngleZ from the variables
            % received
            
            %% Setting up variables to be used
            length = (0.246*personHeight); % currently at 100% up the shank
            distance = 0.4*length;
            rCalf = 0.4*distance; % will be deleted when function receives calf radius
            footAngleZRads = deg2rad(footAngleZ);
            
            %% Determining the coordinates of the 4 points
            % x1Prime and y1Prime is the position of the ankle joint
            x1Prime = ankleJointXPos; %the next anklejointX location
            y1Prime = ankleJointYPos; %the next anklejointY location
            
            % x2Prime and y2Prime is a set distance from the ankle joint
            % and relies on the foot angle with the ground to determine the
            % lower spring attachment site
            x2Prime = x1Prime - distance*cos(footAngleZRads);
            y2Prime = y1Prime - distance*sin(footAngleZRads);
            
            % x4Prime and y4Prime are the x and y of the knee joint and
            % will be used to find the upper spring attachment site
            x4Prime = kneeJointXPos;
            y4Prime = kneeJointYPos;
            
            % Determining the angle at which (x3Prime, y3Prime) rotates
            theta = deg2rad(kneeAngleZ-hipAngleZ);
            
            % Uses theta and the knee joint pos to properly find (x3Prime,
            % y3Prime) which is perpindicularly out from shank
            x3Prime = kneeJointXPos - rCalf*cos(theta);
            y3Prime = kneeJointYPos + rCalf*sin(theta);
            
            %% Calculating the overall length of the system
            length = sqrt(((x3Prime-x2Prime)^2)+ ((y3Prime-y2Prime)^2));
            obj.Length = length;
            
            %% Create link vectors
            obj.Link1X = [x1Prime x2Prime];
            obj.Link1Y = [y1Prime y2Prime];
            obj.Link2X = [x2Prime x3Prime];
            obj.Link2Y = [y2Prime y3Prime];
            obj.Link3X = [x3Prime x4Prime];
            obj.Link3Y = [y3Prime y4Prime];
            obj.Link4X = [x4Prime x1Prime];
            obj.Link4Y = [y4Prime y1Prime];
        end
    end
end 