classdef GaitLegPosition
    properties
        % Vector positions for each segment of the leg
        ThighPositionX
        ThighPositionY
        ShankPositionX
        ShankPositionY
        
        % Distance from the Ankle to the Calcaneous
        AnkleToCalcX
        AnkleToCalcY
        % Distance from the Ankle to the Meta
        AnkleToMetaX
        AnkleToMetaY
        % Distance from the Calcaneous to the 5th MetaTarsal
        CalcToMetaX
        CalcToMetaY
        % Distance from the Calcaneous to the Toes
        CalcToToeX
        CalcToToeY
        
        FootPositionX  % Prob won't be used
        FootPositionY  % Prob won't be used
        
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
        function obj = GaitLegPosition(model, footAngleZ, kneeAngleZ, hipAngleZ)
            % Center of mass variables to be accessed from the map
            global pFootCOMx pShankCOM pThighCOM;
            global leftShankLength thighLength footLength footHeight toeLength;
            
            % Get the Dimensions of body segments
            thighLengthDim = model.dimensionMap(thighLength);
            shankLengthDim = model.dimensionMap(leftShankLength);
            footLengthDim = model.dimensionMap(footLength);
            footHeightDim =  model.dimensionMap(footHeight);
            toeLengthDim =  model.dimensionMap(toeLength);
            
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
            y3proj = y4 - thighLengthDim;
            thighXComProj = x4;
            thingYComProj = y4 - (model.comPercentageMap(pThighCOM)*thighLengthDim); % Use the actual, COM proportion
            
            % Knee Point
            x3 = (x3proj*cos(hipAngleZRads)) - (y3proj*sin(hipAngleZRads));
            y3 = (y3proj*cos(hipAngleZRads)) + (x3proj*sin(hipAngleZRads));
            
            % Thigh COM
            obj.ThighComXPoint = (thighXComProj*cos(hipAngleZRads)) - (thingYComProj*sin(hipAngleZRads));
            obj.ThighComYPoint = (thingYComProj*cos(hipAngleZRads)) + (thighXComProj*sin(hipAngleZRads));
            
            % Get the projected ankle and shankCom coordinates
            x2proj = x3 + (shankLengthDim*abs(sin(hipAngleZRads)));
            shankXproj = x3 + (shankLengthDim*model.comPercentageMap(pShankCOM)*abs(sin(hipAngleZRads)));   % Could use COM Map
            
            % If the hip is in extension, then subtract from x3
            if(hipAngleZ < 0)
                x2proj = x3 - (shankLengthDim*abs(sin(hipAngleZRads)));
                shankXproj = x3 - (shankLengthDim*model.comPercentageMap(pShankCOM)*abs(sin(hipAngleZRads))); % Could use COM Map
            end
            y2proj = y3 - (shankLengthDim*abs(cos(hipAngleZRads)));
            shankYproj = y3 - (shankLengthDim*model.comPercentageMap(pShankCOM)*abs(cos(hipAngleZRads))); % Could use COM Map
            
            % Change the knee to have flexsion +'ve in the CCW direction
            adjustedKneeAngleZRads = kneeAngleZRads * -1;
            
            % Find the ankle joint
            x2 = x3 + ((x2proj - x3)*cos(adjustedKneeAngleZRads)) - ((y2proj-y3)*sin(adjustedKneeAngleZRads));
            y2 = y3 + ((x2proj-x3)*sin(adjustedKneeAngleZRads)) + ((y2proj-y3)*cos(adjustedKneeAngleZRads));
            
            % Find the com position of the shank
            obj.ShankComXPoint = x3 + ((shankXproj - x3)*cos(adjustedKneeAngleZRads)) - ((shankYproj-y3)*sin(adjustedKneeAngleZRads));    % Could use COM Map
            obj.ShankComYPoint = y3 + ((shankXproj-x3)*sin(adjustedKneeAngleZRads)) + ((shankYproj-y3)*cos(adjustedKneeAngleZRads));  % Could use COM Map
            
            
            %%% Changes of the actual toe!!!!
            %calcXProj = x2-
            %calcX = x2 + (())
            
            % Find the toe position
            x1 = x2 + footLengthDim*cos(footAngleZRads);
            y1 = y2 + footLengthDim*sin(footAngleZRads);
            
            % Find the COM position of the foot
            obj.FootComXPoint = x2 + footLengthDim*model.comPercentageMap(pFootCOMx)*cos(footAngleZRads);  % Could use COM Map
            obj.FootComYPoint = y2 + footLengthDim*model.comPercentageMap(pFootCOMx)*sin(footAngleZRads);  % Could use COM Map
            
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
            