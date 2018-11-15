classdef FourBarLinkagePosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link4Y
        Link3X
        Link3Y
        Link4X
        
        Link1Line
        Link2Line
        Link3Line
        Link4Line
        
        IntersectPointX
        IntersectPointY
    end
    
    methods
        function obj = FourBarLinkagePosition(personHeight, kneeJointXPos, kneeJointYPos, ...
            shankLength, hipAngleZ, kneeAngleZ, counterPos)
            %% Initialize variables used for calculations
            obj.IntersectPointX = 0;
            obj.IntersectPointY = 0;
            
            % Convert angles to radians
            kneeAngleZRads = deg2rad(kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            % Variables needed for calculations
            kneeAngleRelative = kneeAngleZRads - hipAngleZRads;

            % Parameterized variables to pin the 4 bar linkage
            Ltopbartohip = 0.14045*personHeight; % Percentage of height, Can change value - in m (~0.25 for 1.78m)
            Ltopbar = .061798*personHeight; % Percentage of height, Can change value - in m (~0.11 for 1.78m)
            Lbotbar = .230337*personHeight; % Percentage of height, Can change value - in m (~0.41 for 1.78m)
            
            Lbot4BarFromKnee = shankLength - Lbotbar;
            
            L1 = 0.025*personHeight; % Percentage of height, Can change value - in m (~0.0445 for 1.78m)
            L3 = 0.02298*personHeight; % Percentage of height, Can change value - in m (~0.0409 for 1.78m)
            Theta2 = 27.5; %manually change value
                Theta2Rads = deg2rad(Theta2);
            Theta3 = 90 - Theta2;
                Theta3Rads = deg2rad(Theta3);
            Theta4 = 19.5; %manually change value
                Theta4Rads = deg2rad(Theta4);
            Theta5Rads = 90 - Theta4Rads + kneeAngleRelative;
    
            %% Find the position of the thigh bar link
            % Hip Position
            x4 = 0;
            y4 = 0;
            
            % Create point R1 in space
            xR1Proj = 0;
            yR1Proj = (-1*(Ltopbar+Ltopbartohip));
            
            xR1 = (xR1Proj*cos(hipAngleZRads)) - (yR1Proj*sin(hipAngleZRads));
            yR1 = (yR1Proj*cos(hipAngleZRads)) + (xR1Proj*sin(hipAngleZRads));
            
            %Create point D in space
                %if hipAngleZ <= theta2
            yD = yR1 - (1/2)*L3*sin(Theta2Rads - hipAngleZRads);
            if(hipAngleZ>Theta2)
                yD = yR1 + (1/2)*L3*sin(hipAngleZRads - Theta2Rads);
            end
                %if hipAngleZ >= 0
            xD = xR1 + (1/2)*L3*cos(Theta2Rads - hipAngleZRads);
            if (hipAngleZ < 0)
                xD = xR1 + (1/2)*L3*cos(Theta2Rads + hipAngleZRads);
            end
            
            % Rotate xd and yd in space to get the position of it
            %if hipAngleZ <= theta2
            yCProj = yR1 - (1/2)*L3*sin(Theta2Rads - hipAngleZRads);
            if(hipAngleZ>Theta2)
                yCProj = yR1 + (1/2)*L3*sin(hipAngleZRads - Theta2Rads);
            end
                %if hipAngleZ >= 0
            xCProj = xR1 + (1/2)*L3*cos(Theta2Rads - hipAngleZRads);
            if (hipAngleZ < 0)
                xCProj = xR1 + (1/2)*L3*cos(Theta2Rads + hipAngleZRads);
            end
            
            xC = xR1 + (xCProj-xR1)*cos(deg2rad(180)) - (yCProj-yR1)*sin(deg2rad(180));
            yC = yR1 + (xCProj-xR1)*sin(deg2rad(180)) + (yCProj-yR1)*cos(deg2rad(180));
             
            
            %% Find the position of the shank bar link
            % Create point R2 in space
            xR2proj = kneeJointXPos + (Lbot4BarFromKnee*abs(sin(hipAngleZRads)));

            % If the hip is in extension, then subtract from x3
            if(hipAngleZ < 0)
                xR2proj = kneeJointXPos - (Lbot4BarFromKnee*abs(sin(hipAngleZRads)));
            end
            y2proj = kneeJointYPos - (Lbot4BarFromKnee*abs(cos(hipAngleZRads)));
            
            % Change the knee to have flexsion +'ve in the CCW direction
            adjustedKneeAngleZRads = kneeAngleZRads * -1;
            
            % Find the ankle joint
            xR2 = kneeJointXPos + ((xR2proj - kneeJointXPos)*cos(adjustedKneeAngleZRads)) - ((y2proj-kneeJointYPos)*sin(adjustedKneeAngleZRads));
            yR2 = kneeJointYPos + ((xR2proj-kneeJointXPos)*sin(adjustedKneeAngleZRads)) + ((y2proj-kneeJointYPos)*cos(adjustedKneeAngleZRads));
            
            %Create point B in space
              yB = yR2 - (1/3)*L1*cos(Theta5Rads);
                  %if Theta5Rads >= 0 
              xB = xR2 + (1/3)*L1*sin(Theta5Rads);
              if (Theta5Rads <= 0)
                  xB = xR2 - (1/3)*L1*sin(Theta5Rads);
              end

            % Create point A in space
            % Create point A projected that is in line with point B
            yAProj = yR2 - (2/3)*L1*cos(Theta5Rads);
                 %if Theta5Rads >= 0 
            xAProj = xR2 + (2/3)*L1*sin(Theta5Rads);
            if (Theta5Rads <= 0)
                 xAProj = xR2 - (2/3)*L1*sin(Theta5Rads);
             end
            
            % Rotate Point A 180 degrees to it's proper position
            xA = xR2 + (xAProj-xR2)*cos(deg2rad(180)) - (yAProj-yR2)*sin(deg2rad(180));
            yA = yR2 + (xAProj-xR2)*sin(deg2rad(180)) + (yAProj-yR2)*cos(deg2rad(180));
            
            %% Create the link vectors, attaching proper points to define links
            % Create link vectors
            obj.Link1X = [xA xB];
            obj.Link1Y = [yA yB];
            
            obj.Link2X = [xB xC];
            obj.Link2Y = [yB yC];
            
            obj.Link3X = [xC xD];
            obj.Link3Y = [yC yD];
            
            obj.Link4X = [xD xA];
            obj.Link4Y = [yD yA];
            
            % Create the link lines
            obj.Link1Line = [xA xB;yA yB];
            obj.Link2Line = [xB xC;yB yC];
            obj.Link3Line = [xC xD;yC yD];
            obj.Link4Line = [xD xA;yD yA];
            
            distLink2 = sum(sqrt(diff(obj.Link2X).^2+diff(obj.Link2Y).^2));
            distLink4 = sum(sqrt(diff(obj.Link4X).^2+diff(obj.Link4Y).^2));
            
            disp(distLink2);
            
            % Link 2 and link 4 are the ones that overlap, find
            % intersection
            inter = LineIntersection(obj.Link2Line, obj.Link4Line);
            if(~isempty(inter))
                obj.IntersectPointX = inter(1);
                obj.IntersectPointY = inter(2);
            end
            
            %% Tests to run to verify constant lengths
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
