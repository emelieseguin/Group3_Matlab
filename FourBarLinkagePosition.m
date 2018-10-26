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
        
        IntersectPointX
        IntersectPointY
    end
    
    methods
        function obj = FourBarLinkagePosition(personHeight, kneeJointXPos, kneeJointYPos, ...
            shankLength, hipAngleZ, kneeAngleZ)
            
            % Convert angles to radians
            kneeAngleZRads = deg2rad(kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            % Variables needed for calculations
                % If Hip Flexion and Knee Flexion
                kneeAngleRelative = hipAngleZRads - kneeAngleZRads;
                % If either (Hip Extension, Knee Flexion) 
                if((hipAngleZRads < 0 && kneeAngleZRads > 0))
                    kneeAngleRelative = hipAngleZRads + kneeAngleZRads;
                end
            Ltopbar = 26; %manually change value - in CM
            Lbotbar = 22; %manually change value - in CM
            L1 = 4.45; %manually change value - in CM
            L3 = 4.09; %manually change value - in CM
            Theta2 = 27.5; %manually change value
                Theta2Rads = deg2rad(Theta2);
            Theta3 = 90 - Theta2;
                Theta3Rads = deg2rad(Theta3);
            Theta4 = 19.5; %manually change value
                Theta4Rads = deg2rad(Theta4);
            Theta5Rads = 90 - Theta4Rads - kneeAngleRelative;
    
            % Hip Position
            x4 = 0;
            y4 = 0;
            
            % Create point R1 in space
            xR1 = Ltopbar*sin(hipAngleZRads);         % If hipAngleZ > 0
            if(hipAngleZ < 0)
                xR1 = -1*Ltopbar*sin(hipAngleZRads);
            end
            yR1 = -1*Ltopbar*cos(hipAngleZRads);
            
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
            
            %Create point C in space
                %if hipAngleZ <= theta2
            yC = yR1 + (1/2)*L3*sin(Theta2Rads - hipAngleZRads);
            if(hipAngleZ>Theta2)
                yC = yR1 - (1/2)*L3*sin(hipAngleZRads - Theta2Rads);
            end
                %if hipAngleZ < 0 
            xC = xR1 - (1/2)*L3*cos(Theta2Rads + hipAngleZRads);
            if(hipAngleZ > 0)
                %if hipAngleZ <= theta2
                xC = xR1 - (1/2)*L3*cos(Theta2Rads - hipAngleZRads);
                if(hipAngleZ>Theta2)
                    xC = xR1 - (1/2)*L3*cos(hipAngleZRads - Theta2Rads);
                end
            end
            
            %Create point R2 in space
            xR2 = kneeJointXPos - (shankLength - Lbotbar)*sin(kneeAngleZRads);
            yR2 = kneeJointYPos - (shankLength - Lbotbar)*cos(kneeAngleZRads);
            
            %Create point B in space
            yB = yR2 - (1/3)*L1*cos(Theta5Rads);
                %if Theta5Rads >= 0 
            xB = xR2 + (1/3)*L1*sin(Theta5Rads);
            if (Theta5Rads <= 0)
                xB = xR2 - (1/3)*L1*sin(Theta5Rads);
            end
                        
            %Create point A in space
            yA = yR2 + (2/3)*L1*cos(Theta5Rads);
                %if Theta5Rads >= 0 
            xA = xR2 - (2/3)*L1*sin(Theta5Rads);
            if (Theta5Rads <= 0)
                xA = xR2 + (2/3)*L1*sin(Theta5Rads);
            end
            
            % Create link vectors
            obj.Link1X = [xA xB];
            obj.Link1Y = [yA yB];
            obj.Link2X = [xB xC];
            obj.Link2Y = [yB yC];
            obj.Link3X = [xC xD];
            obj.Link3Y = [yC yD];
            obj.Link4X = [xD xA];
            obj.Link4Y = [yD yA];
        end
    end
end
