classdef GaitLegPosition
    properties
        % Vector positions for each segment of the leg
        ThighPositionX
        ThighPositionY
        ShankPositionX
        ShankPositionY
        FootPositionX
        FootPositionY
        
        FootAngleZ
        KneeAngleZ
        HipAngleZ
    end
    
    % CCW in the sagital plane is positive
    methods
        function obj = GaitLegPosition(thighLength, shankLength, footLength, ...
                footAngleZ, kneeAngleZ, hipAngleZ)
            
            % Store the angles for the joints
            obj.FootAngleZ = footAngleZ;
            obj.KneeAngleZ = kneeAngleZ;
            obj.HipAngleZ = hipAngleZ;
            
            % Convert angles to radians
            footAngleZRads = deg2rad(footAngleZ);
            kneeAngleZRads = deg2rad(kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            x4 = 0;
            y4 = 0;
            x3proj = x4;
            y3proj = y4 - thighLength;
            
            % Knee Point
            x3 = (x3proj*cos(hipAngleZRads)) - (y3proj*sin(hipAngleZRads));
            y3 = (y3proj*cos(hipAngleZRads)) + (x3proj*sin(hipAngleZRads));
            
            % Get the projected ankle coordinates
            x2proj = x3 + (shankLength*abs(sin(hipAngleZRads))); 
            % If the hip is in extension, then subtract from x3
            if(hipAngleZ < 0)
                x2proj = x3 - (shankLength*abs(sin(hipAngleZRads)));
            end
            y2proj = y3 - (shankLength*abs(cos(hipAngleZRads)));
            
            % Change the knee to have flexsion +'ve in the CCW direction
            adjustedKneeAngleZRads = kneeAngleZRads * -1;
            
            % Find the ankle joint
            x2 = x3 + ((x2proj - x3)*cos(adjustedKneeAngleZRads)) - ((y2proj-y3)*sin(adjustedKneeAngleZRads));
            y2 = y3 + ((x2proj-x3)*sin(adjustedKneeAngleZRads)) + ((y2proj-y3)*cos(adjustedKneeAngleZRads));
            
            % Find the toe position
            x1 = x2 + footLength*cos(footAngleZRads);
            y1 = y2 + footLength*sin(footAngleZRads);
            
            obj.ThighPositionX = [x3 x4];
            obj.ThighPositionY = [y3 y4];
            
            obj.ShankPositionX = [x2 x3];
            obj.ShankPositionY = [y2 y3];
            
            obj.FootPositionX = [x1 x2];
            obj.FootPositionY = [y1 y2];
        end
    end  
end          
            