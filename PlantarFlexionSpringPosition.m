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
        
        %% Solidworks Dimensions
        lowerAttachmentDistFromCenterLine
        upperAttachmentDistFromCenterLine
        lowerAttachmentDistUpShank
        
        % Used to find moment contribution
        AppliedHeelCableForceAngle
        distanceFromAnkle2LowAttachmentX
        distanceFromAnkle2LowAttachmentY
    end
    
    methods
        function obj = PlantarFlexionSpringPosition(personHeight, position, hipAngleZ, ...
                kneeAngleZ, footAngleZ)  
            obj.upperAttachmentDistFromCenterLine = (0.09/1.78)*personHeight; % drive sim off that
            obj.lowerAttachmentDistFromCenterLine = (0.15/1.78)*personHeight; % drive sim off that
            obj.lowerAttachmentDistUpShank = (0.021894/1.78);  % 5% --- drive sim off this
            
            %% Setting up variables to be used
            shankLengthDim = (0.246*personHeight);
            thighLengthDim = personHeight*0.245;
            distanceDownShank= shankLengthDim - obj.lowerAttachmentDistUpShank;
            footAngleZRads = deg2rad(footAngleZ);  
            kneeAngleZRads = deg2rad((-1)*kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            %% Define the point down the shank where the bottom attachment is place
            lowerAttchmentProjX = 0;
            lowerAttchmentProjY = 0 - thighLengthDim - distanceDownShank;
            
            [lowerAttchmentProjX, lowerAttchmentProjY] = obj.RotatePointsAroundPoint(lowerAttchmentProjX, lowerAttchmentProjY, ...
                hipAngleZRads, 0, 0);
            [lowerAttachmentX, lowerAttachmentY] = obj.RotatePointsAroundPoint(lowerAttchmentProjX, lowerAttchmentProjY, ...
                kneeAngleZRads, position.KneeJointX, position.KneeJointY);
            
            
            %% Find placement from the ankle joint        
            x1Prime = lowerAttachmentX;
            y1Prime = lowerAttachmentY; 
                        
            lowerAttachmentSpringPosXProj = lowerAttachmentX - obj.lowerAttachmentDistFromCenterLine;
            lowerAttachmentSpringPosYProj = lowerAttachmentY;
            
            [x2Prime, y2Prime] = obj.RotatePointsAroundPoint(lowerAttachmentSpringPosXProj, lowerAttachmentSpringPosYProj, ...
            footAngleZRads, lowerAttachmentX, lowerAttachmentY);
            
            %% Find projected position from shank
            
            % x4Prime and y4Prime are the x and y of COM of shank
            x4Prime = position.ShankComXPoint;
            y4Prime = position.ShankComYPoint;
            
            % Determining the angle at which (x3Prime, y3Prime) rotates
            theta = deg2rad(kneeAngleZ-hipAngleZ);
            
            % Uses theta and the knee joint pos to properly find (x3Prime,
            % y3Prime) which is perpindicularly out from shank
            x3Prime = position.ShankComXPoint - obj.upperAttachmentDistFromCenterLine*cos(theta);
            y3Prime = position.ShankComYPoint + obj.upperAttachmentDistFromCenterLine*sin(theta);
            
            %% Find moment contribution distances            
            xDist = x3Prime - x2Prime;
            yDist = y3Prime - y2Prime;
            obj.AppliedHeelCableForceAngle = rad2deg(atan(yDist/xDist));
            
            obj.distanceFromAnkle2LowAttachmentX = x2Prime - position.AnkleJointX;
            obj.distanceFromAnkle2LowAttachmentY = position.AnkleJointY - y2Prime; 
            
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
        
         function [xRotated, yRotated] = RotatePointsAroundPoint(~, initialX, initialY, angleInRads_CCW, ...
                pointToRotateAroundX, pointToRotateAroundY)
            % Rotate X co-ordinate
            xRotated = pointToRotateAroundX + [(initialX-pointToRotateAroundX)*cos(angleInRads_CCW)- (initialY-pointToRotateAroundY)*sin(angleInRads_CCW)];
            % Rotate Y co-ordinate
            yRotated = pointToRotateAroundY + [(initialX-pointToRotateAroundX)*sin(angleInRads_CCW)+ (initialY-pointToRotateAroundY)*cos(angleInRads_CCW)];
        end
    end
end 