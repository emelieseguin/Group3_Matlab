classdef DorsiFlexionSpringPosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
       
        Length
        
        %% Percentages up and down the leg for the attachments       
        thighPulleyPercentDownThigh = 0.8;
        shankPullyPercentDownShank = 0.2;
        camPullyPercentDownThigh = 0.6226; % its at the center line
        radiusOfThePulley = 0.0087305;
        
        %% Distance Off Toe -- change with param
        distAboveToe = 0.065; % in [m] approximated
        percentageFromHeelToFootAttch = 0.8;
        
        
        %% Values used in solidworks
        pullyDistanceFromTheCenterLine
       
        %% Used to find moment contribution
        AppliedToeCableForceAngle
        distanceFromAnkle2ToeCableX
        distanceFromAnkle2ToeCableY
    end
    
    methods
        function obj = DorsiFlexionSpringPosition(position, patientHeight, anthroDimensionMap, ...
                hipAngleZ, kneeAngleZ, ankleAngleZ, footAngleZ)
        %% Setting up the variables to be used
        global leftShankLength thighLength footLength;
        lThigh = anthroDimensionMap(thighLength);
        lShank = anthroDimensionMap(leftShankLength);
        lFoot = anthroDimensionMap(footLength);
        hipAngleZRads = deg2rad(hipAngleZ);
        kneeAngleZRads = deg2rad(kneeAngleZ);
        footAngleZRads = deg2rad(footAngleZ);
                
        obj.pullyDistanceFromTheCenterLine = (0.06/1.78)*patientHeight;       
        
        %% Thigh Cam Attachment
        camPositionProjX = 0;
        camPositionProjY = 0 - lThigh*obj.camPullyPercentDownThigh;
        
        [P1X, P1Y] = obj.RotatePointsAroundPoint(camPositionProjX, camPositionProjY, ...
                hipAngleZRads, 0, 0);

        %% Thigh Pulley Attachment
        pulleyDistFromCenterline = obj.pullyDistanceFromTheCenterLine + obj.radiusOfThePulley; % Top is distance + pulley radius
        P2X = obj.thighPulleyPercentDownThigh*lThigh*sin(hipAngleZRads) + pulleyDistFromCenterline*cos(hipAngleZRads);
        P2Y = -obj.thighPulleyPercentDownThigh*lThigh*cos(hipAngleZRads) + pulleyDistFromCenterline*sin(hipAngleZRads);
        
        %% Shank Pulley Attachment
        pulleyDistFromCenterline = obj.pullyDistanceFromTheCenterLine - obj.radiusOfThePulley; % Top is distance - pulley radius
        if (kneeAngleZRads>hipAngleZRads)
            P3X = position.KneeJointX - obj.shankPullyPercentDownShank*lShank*sin(kneeAngleZRads-hipAngleZRads) + pulleyDistFromCenterline*cos(kneeAngleZRads-hipAngleZRads);
            P3Y = position.KneeJointY - obj.shankPullyPercentDownShank*lShank*cos(kneeAngleZRads-hipAngleZRads) - pulleyDistFromCenterline*sin(kneeAngleZRads-hipAngleZRads);
        elseif (kneeAngleZRads<hipAngleZRads)
            P3X = position.KneeJointX + obj.shankPullyPercentDownShank*lShank*sin(hipAngleZRads-kneeAngleZRads) + pulleyDistFromCenterline*cos(hipAngleZRads-kneeAngleZRads);
            P3Y = position.KneeJointY - obj.shankPullyPercentDownShank*lShank*cos(kneeAngleZRads-hipAngleZRads) + pulleyDistFromCenterline*sin(kneeAngleZRads-hipAngleZRads);
        end
        
        %% Foot Pulley Position
        toeAttachmentPosX = position.HeelX  + lFoot*obj.percentageFromHeelToFootAttch;
        toeAttachmentPosY = position.HeelY + obj.distAboveToe;
            
        [P4X, P4Y] = obj.RotatePointsAroundPoint(toeAttachmentPosX, toeAttachmentPosY, ...
                footAngleZRads, position.HeelX, position.HeelY);
        
        %% Attachment of Cable on Foot
        obj.distanceFromAnkle2ToeCableX = P4X - position.AnkleJointX;
        obj.distanceFromAnkle2ToeCableY =  position.AnkleJointY -  P4Y;
        
        % Calculate the angle of the applied force vector from horiz       
        if(P3X > P4X)
            AppliedForceAngleFromXAxis = rad2deg(atan(abs(P3Y-P4Y)/abs(P3X-P4X)));
        else
            AppliedForceAngleFromXAxis = 180 - rad2deg(atan(abs(P3Y-P4Y)/abs(P3X-P4X)));
        end
        obj.AppliedToeCableForceAngle = AppliedForceAngleFromXAxis;

        %% Determining overall length of the system
        obj.Length = sqrt(((P2X-P1X)^2)+((P2Y-P1Y)^2)) + sqrt(((P3X-P2X)^2)+((P3Y-P2Y)^2))+ ...
            + sqrt(((P4X-P3X)^2)+((P4Y-P3Y)^2));

        %% Create link vectors
        obj.Link1X = [P1X P2X];
        obj.Link1Y = [P1Y P2Y];
        obj.Link2X = [P2X P3X];
        obj.Link2Y = [P2Y P3Y];
        obj.Link3X = [P3X P4X];
        obj.Link3Y = [P3Y P4Y];
        
        %% Tests
        %obj.CheckLengthConsistent('Foot Attachment: ', [P3X P4X], [P3Y P4Y]);
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