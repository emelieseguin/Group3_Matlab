classdef GaitLegPosition
    properties
        %% Anatomical Points
        % Vector positions for each segment of the leg
        ThighPositionX
        ThighPositionY
        ShankPositionX
        ShankPositionY        
        
        % Distances Used for inverse Dynamics
        % Distance from the Ankle to the Calcaneous
        AnkleToCalcX
        AnkleToCalcY
        % Distance from the Ankle to the Meta
        AnkleToMetaX
        AnkleToMetaY
        % Distance from the Calcaneous to the Toes
        CalcToToeX
        CalcToToeY
        
        % Angles to be displayed in the gui
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
        
        % Lower body joints in space
        HipJointX
        HipJointY
        KneeJointX
        KneeJointY
        AnkleJointX
        AnkleJointY
        % Positions of the Foot in space
        HeelX
        HeelY
        ToeX
        ToeY
        
        % Lines for the Thigh and Shank
        ThighLine
        ShankLine
        
        %% Exoskeleton Points
        ThighExoComX
        ThighExoComY
        
        ShankExoComX
        ShankExoComY
        
        FootExoComX
        FootExoComY        
    end
    
    % CCW in the sagital plane is positive
    methods
        function obj = GaitLegPosition(model, footAngleZ, kneeAngleZ, hipAngleZ)
            % Center of mass variables to be accessed from the map
            global pFootCOMx pFootCOMy pShankCOM pThighCOM;
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
            % Change the knee to have flexsion +'ve in the CCW direction
            kneeAngleZRads = deg2rad((-1)*kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            %% Position of the Hip Segment %%
            obj.HipJointX = 0;
            obj.HipJointY = 0;
            
            % Create projected points to rotate
            x3proj = obj.HipJointX;
            y3proj = obj.HipJointY - thighLengthDim;
            thighXComProj = obj.HipJointX;
            thighYComProj = obj.HipJointY - (model.comPercentageMap(pThighCOM)*thighLengthDim);
            
            % Find the Knee and Thigh COM Points in space
            [obj.KneeJointX, obj.KneeJointY] = obj.RotatePointsAroundPoint(x3proj, y3proj, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            [obj.ThighComXPoint, obj.ThighComYPoint] = obj.RotatePointsAroundPoint(thighXComProj, thighYComProj, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            
            %% Acting COM of the Exoskeleton on the Thigh
            percetageDownThighOfCom = 0.4;
            thighExoComProjX =  obj.HipJointX;
            thighExoComProjY =  obj.HipJointY - thighLengthDim*percetageDownThighOfCom;
            
            [obj.ThighExoComX, obj.ThighExoComY] = obj.RotatePointsAroundPoint(thighExoComProjX, thighExoComProjY, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            
            %% Position of the Ankle Segment %%
            x2proj = obj.HipJointX;
            y2proj = obj.HipJointY - thighLengthDim - shankLengthDim;
            shankXproj = obj.HipJointX;
            shankYproj = obj.HipJointY - thighLengthDim - (model.comPercentageMap(pShankCOM)*shankLengthDim);
            
            % Rotate to find Ankle point (hip rotation, then knee rotation)
            [x2proj, y2proj] = obj.RotatePointsAroundPoint(x2proj, y2proj, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            [obj.AnkleJointX, obj.AnkleJointY] = obj.RotatePointsAroundPoint(x2proj, y2proj, ...
                kneeAngleZRads, obj.KneeJointX, obj.KneeJointY);
            
            % Rotate to find shank COM point (hip rotation, then knee rotation)
            [shankXproj, shankYproj] = obj.RotatePointsAroundPoint(shankXproj, shankYproj, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            [obj.ShankComXPoint, obj.ShankComYPoint] = obj.RotatePointsAroundPoint(shankXproj, shankYproj, ...
                kneeAngleZRads, obj.KneeJointX, obj.KneeJointY);
            
            %% Acting COM of the Exoskeleton on the Shank
            percetageDownShankOfCom = 0.35;
            shankExoComProjX = obj.HipJointX;
            shankExoComProjY = obj.HipJointY - thighLengthDim - (percetageDownShankOfCom*shankLengthDim);
            
            [shankExoComProjX, shankExoComProjY] = obj.RotatePointsAroundPoint(shankExoComProjX, shankExoComProjY, ...
                hipAngleZRads, obj.HipJointX, obj.HipJointY);
            [obj.ShankExoComX, obj.ShankExoComY] = obj.RotatePointsAroundPoint(shankExoComProjX, shankExoComProjY, ...
                kneeAngleZRads, obj.KneeJointX, obj.KneeJointY);
            
            %% Position of the Foot Segment %%
            % Find the position of the calcaneous relative to the ankle
            dCalcToAnkle = footHeightDim/(sin(model.TalocalcanealAngleRad));
            calcXProj1 = obj.AnkleJointX;
            calcYProj1 = obj.AnkleJointY - dCalcToAnkle;
            
            % Rotatation angle, for anatomical position
            rotationAngle = deg2rad(-49);
            
            % Find the Position of the Heel - (rotate to anatomical position, rotate with foot angle)
            [calcXProj2, calcYProj2] = obj.RotatePointsAroundPoint(calcXProj1, calcYProj1, ...
                rotationAngle, obj.AnkleJointX, obj.AnkleJointY);
            [obj.HeelX, obj.HeelY] = obj.RotatePointsAroundPoint(calcXProj2, calcYProj2, ...
                footAngleZRads, obj.AnkleJointX, obj.AnkleJointY);

            % Find 5th Metatarsal Point
            metaXProj = obj.HeelX  + (footLengthDim-toeLengthDim);
            metaYProj = obj.HeelY ;
            
            [metaX, metaY] = obj.RotatePointsAroundPoint(metaXProj, metaYProj, ...
                footAngleZRads, obj.HeelX, obj.HeelY);

            % Find the Toe Position
            toeXProj = obj.HeelX + footLengthDim;
            toeYProj = obj.HeelY;
            
            [obj.ToeX, obj.ToeY] = obj.RotatePointsAroundPoint(toeXProj, toeYProj, ...
                footAngleZRads, obj.HeelX, obj.HeelY);
            
            % Find the COM of the foot in X
            footComXProj = obj.HeelX + footLengthDim*model.comPercentageMap(pFootCOMx);
            footComYProj = obj.HeelY + footHeightDim*model.comPercentageMap(pFootCOMy);
            
            [obj.FootComXPoint, obj.FootComYPoint] = obj.RotatePointsAroundPoint(footComXProj, footComYProj, ...
                footAngleZRads, obj.HeelX, obj.HeelY);
            
            %% Acting COM of the Exoskeleton on the Foot
            obj.FootExoComX = obj.FootComXPoint;
            obj.FootExoComY = obj.FootComYPoint;
            
            %% Create Vectors %%
            % Set the vectors of the segments
            obj.ThighPositionX = [obj.KneeJointX obj.HipJointX];
            obj.ThighPositionY = [obj.KneeJointY obj.HipJointY];
            
            obj.ShankPositionX = [obj.AnkleJointX obj.KneeJointX];
            obj.ShankPositionY = [obj.AnkleJointY obj.KneeJointY];
            
            % Distance from the Ankle to the Calcaneous
            obj.AnkleToCalcX = [obj.AnkleJointX obj.HeelX];
            obj.AnkleToCalcY = [obj.AnkleJointY obj.HeelY];
            
            % Distance from the Ankle to the 5th Metatarsal
            obj.AnkleToMetaX = [obj.AnkleJointX metaX];
            obj.AnkleToMetaY = [obj.AnkleJointY metaY];
            
            % Distance from the Calcaneous to the Toes
            obj.CalcToToeX = [obj.HeelX obj.ToeX];
            obj.CalcToToeY = [obj.HeelY obj.ToeY];
            
            % Set the vectors for the COM
            obj.ThighComXVector = [obj.ThighComXPoint obj.HipJointX];
            obj.ThighComYVector = [obj.ThighComYPoint obj.HipJointY];
            
            obj.ShankComXVector = [obj.ShankComXPoint obj.KneeJointX];
            obj.ShankComYVector = [obj.ShankComYPoint obj.KneeJointY];
            
            obj.FootComXVector = [obj.FootComXPoint obj.HeelX];
            obj.FootComYVector = [obj.FootComYPoint obj.HeelY];
            
            % Create lines for the thigh and shank
            obj.ThighLine = [obj.HipJointX obj.KneeJointX;obj.HipJointY obj.KneeJointY];
            obj.ShankLine = [obj.KneeJointX obj.AnkleJointX;obj.KneeJointY obj.AnkleJointY];
            %% Tests to Run %%
            % Checks that can be ran to ensure the thing and shank stay the
            % same dimensions
            % obj.CheckLengthConsistent('Shank', obj.ShankPositionX , obj.ShankPositionY);
            % obj.CheckLengthConsistent('Thigh', obj.ThighPositionX , obj.ThighPositionY);
        end
         
    end
    
    methods 
        function [xRotated, yRotated] = RotatePointsAroundPoint(~, initialX, initialY, angleInRads_CCW, ...
                pointToRotateAroundX, pointToRotateAroundY)
            % Rotate X co-ordinate
            xRotated = pointToRotateAroundX + [(initialX-pointToRotateAroundX)*cos(angleInRads_CCW)- (initialY-pointToRotateAroundY)*sin(angleInRads_CCW)];
            % Rotate Y co-ordinate
            yRotated = pointToRotateAroundY + [(initialX-pointToRotateAroundX)*sin(angleInRads_CCW)+ (initialY-pointToRotateAroundY)*cos(angleInRads_CCW)];
        end
        
        function CheckLengthConsistent(~, variableName, LineX, LineY)
            length = sum(sqrt(diff(LineX).^2+diff(LineY).^2));
            disp([variableName, num2str(length)])
        end
    end
    
end        