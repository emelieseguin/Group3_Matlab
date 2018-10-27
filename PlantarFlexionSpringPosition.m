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
                ankleAngleZ, footAngleZ, kneeJointXPos, kneeJointYPos)
            
            % Ankle Joint Location and Set Values at 90 degrees
            x1 = 0; % x1 position from the previous iteration
            y1 = 0; % y1 position from the previous iteration
            length = (0.246*personHeight); % currently at 100% up the shank
            distance = 0.2*length;
            
            % 3 other coordinate original locations
            x2 = x1 - distance;
            y2 = y1;
            
            x3 = x1 - distance;
            y3 = y1 + length;
            
            x4 = x1;
            y4 = y1 + length;
        
            % Convert angles of foot and ankle to radians
            footAngleZRads = deg2rad(footAngleZ);
            ankleAngleZRads = deg2rad(ankleAngleZ);
            
            % Calculate the new points based on the angles
            x1Prime = ankleJointXPos; %the next anklejointX location
            y1Prime = ankleJointYPos; %the next anklejointY location
            
            x2Prime = x1Prime - distance*cos(footAngleZRads);
            y2Prime = y1Prime - distance*sin(footAngleZRads);
            
            %x4Prime = x1Prime + length*cos(90-ankleAngleZRads);
            %y4Prime = y1Prime + length*sin(90-ankleAngleZRads);
            
            x4Prime = kneeJointXPos;
            y4Prime = kneeJointYPos;
            %y4Prime = kneeJointYPos+(0.1*kneeJointYPos);
            
            %delX4 = x4Prime - x4;
            %delY4 = y4Prime - y4;
            
            %point4Angle = atan(delY4/delX4);
            
            %x3Prime = distance*cos(point4Angle);
            %y3Prime = distance*sin(point4Angle);
            
            length = sqrt(((x4Prime-x2Prime)^2)+ ((y4Prime-y2Prime)^2));
            obj.Length = length;
            
            % Create link vectors
            obj.Link1X = [x1Prime x2Prime];
            obj.Link1Y = [y1Prime y2Prime];
            obj.Link2X = [x2Prime x4Prime];
            obj.Link2Y = [y2Prime y4Prime];
            %obj.Link3X = [x3Prime x4Prime];
            %obj.Link3Y = [y3Prime y4Prime];
            obj.Link4X = [x4Prime x1Prime];
            obj.Link4Y = [y4Prime y1Prime];
        end
    end
end