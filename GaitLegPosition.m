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
        
        % Center of mass positions for the leg
        ThighComXVector
        ThighComYVector
        ShankComXVector
        ShankComYVector
        FootComXVector
        FootComYVector
        
        ThighComXPoint
        ThighComYPoint
        ShankComXPoint
        ShankComYPoint
        FootComXPoint
        FootComYPoint
    end
    
    % CCW in the sagital plane is positive
    methods
        function obj = GaitLegPosition(thighLength, shankLength, footLength, ...
                footAngleZ, kneeAngleZ, hipAngleZ, comPercentageMap)
            % Center of mass variables to be accessed from the map
            global pFootCOM pShankCOM pThighCOM;
            
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
            thighXComProj = x4;
            thingYComProj = y4 - (comPercentageMap(pThighCOM)*thighLength); % Use the actual, COM proportion
            
            % Knee Point
            x3 = (x3proj*cos(hipAngleZRads)) - (y3proj*sin(hipAngleZRads));
            y3 = (y3proj*cos(hipAngleZRads)) + (x3proj*sin(hipAngleZRads));
            
            % Thigh COM
            obj.ThighComXPoint = (thighXComProj*cos(hipAngleZRads)) - (thingYComProj*sin(hipAngleZRads));
            obj.ThighComYPoint = (thingYComProj*cos(hipAngleZRads)) + (thighXComProj*sin(hipAngleZRads));
            
            % Get the projected ankle and shankCom coordinates
            x2proj = x3 + (shankLength*abs(sin(hipAngleZRads)));
            shankXproj = x3 + (shankLength*comPercentageMap(pShankCOM)*abs(sin(hipAngleZRads)));   % Could use COM Map
            
            % If the hip is in extension, then subtract from x3
            if(hipAngleZ < 0)
                x2proj = x3 - (shankLength*abs(sin(hipAngleZRads)));
                shankXproj = x3 - (shankLength*comPercentageMap(pShankCOM)*abs(sin(hipAngleZRads))); % Could use COM Map
            end
            y2proj = y3 - (shankLength*abs(cos(hipAngleZRads)));
            shankYproj = y3 - (shankLength*comPercentageMap(pShankCOM)*abs(cos(hipAngleZRads))); % Could use COM Map
            
            % Change the knee to have flexsion +'ve in the CCW direction
            adjustedKneeAngleZRads = kneeAngleZRads * -1;
            
            % Find the ankle joint
            x2 = x3 + ((x2proj - x3)*cos(adjustedKneeAngleZRads)) - ((y2proj-y3)*sin(adjustedKneeAngleZRads));
            y2 = y3 + ((x2proj-x3)*sin(adjustedKneeAngleZRads)) + ((y2proj-y3)*cos(adjustedKneeAngleZRads));
            
            % Find the com position of the shank
            obj.ShankComXPoint = x3 + ((shankXproj - x3)*cos(adjustedKneeAngleZRads)) - ((shankYproj-y3)*sin(adjustedKneeAngleZRads));    % Could use COM Map
            obj.ShankComYPoint = y3 + ((shankXproj-x3)*sin(adjustedKneeAngleZRads)) + ((shankYproj-y3)*cos(adjustedKneeAngleZRads));  % Could use COM Map
            
            % Find the toe position
            x1 = x2 + footLength*cos(footAngleZRads);
            y1 = y2 + footLength*sin(footAngleZRads);
            
            % Find the COM position of the foot
            obj.FootComXPoint = x2 + footLength*comPercentageMap(pFootCOM)*cos(footAngleZRads);  % Could use COM Map
            obj.FootComYPoint = y2 + footLength*comPercentageMap(pFootCOM)*sin(footAngleZRads);  % Could use COM Map
            
            % Set the vectors of the segments
            obj.ThighPositionX = [x3 x4];
            obj.ThighPositionY = [y3 y4];
            
            obj.ShankPositionX = [x2 x3];
            obj.ShankPositionY = [y2 y3];
            
            obj.FootPositionX = [x1 x2];
            obj.FootPositionY = [y1 y2];
            
            % Set the vectors for the COM
            obj.ThighComXVector = [obj.ThighComXPoint x4];
            obj.ThighComYVector = [obj.ThighComYPoint y4];
            
            obj.ShankComXVector = [obj.ShankComXPoint x3];
            obj.ShankComYVector = [obj.ShankComYPoint y3];
            
            obj.FootComXVector = [obj.FootComXPoint x2];
            obj.FootComYVector = [obj.FootComYPoint y2];
        end
    end  
end
            