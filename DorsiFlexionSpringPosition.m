classdef DorsiFlexionSpringPosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
       
        Length
    end
    
    methods
        function obj = DorsiFlexionSpringPosition(personHeight,kneeJointXPos, kneeJointYPos, ...
            ankleJointX, ankleJointY, thighCOMX, thighCOMY, footCOMX, footCOMY, shankCOMX, shankCOMY, ...
            hipAngleZ, kneeAngleZ, ankleAngleZ, footAngleZ, toeX, toeY)
            
            %% Setting up the variables to be used
            r = 0.01111; %radius of the pulley wheel
            lThigh = 0.245*personHeight;
            lShank = 0.246*personHeight;
            hipAngleZRads = deg2rad(hipAngleZ);
            kneeAngleZRads = deg2rad(kneeAngleZ);
            
            %% Determining the coordinates of 4 points
            P1X = thighCOMX + (0.05+r)*cos(hipAngleZRads);
            P1Y = thighCOMY + (0.05+r)*sin(hipAngleZRads);
            
            P2X = 0.9*lThigh*sin(hipAngleZRads) + (0.05+r)*cos(hipAngleZRads);
            P2Y = -0.9*lThigh*cos(hipAngleZRads) + (0.05+r)*sin(hipAngleZRads);
            
            if (kneeAngleZRads>hipAngleZRads)
                P3X = kneeJointXPos - 0.2*lShank*sin(kneeAngleZRads-hipAngleZRads) + (0.05+r)*cos(kneeAngleZRads-hipAngleZRads);
                P3Y = kneeJointYPos - 0.2*lShank*cos(kneeAngleZRads-hipAngleZRads) - (0.05+r)*sin(kneeAngleZRads-hipAngleZRads);
            elseif (kneeAngleZRads<hipAngleZRads)
                P3X = kneeJointXPos + 0.2*lShank*sin(hipAngleZRads-kneeAngleZRads) + (0.05+r)*cos(hipAngleZRads-kneeAngleZRads);
                P3Y = kneeJointYPos - 0.2*lShank*cos(kneeAngleZRads-hipAngleZRads) + (0.05+r)*sin(kneeAngleZRads-hipAngleZRads);
            end
            
            P4X = toeX;
            P4Y = toeY;
           
            %% Determining overall length of the system
            length = sqrt(((P2X-P1X)^2)+((P2Y-P1Y)^2)) + sqrt(((P3X-P2X)^2)+((P3Y-P2Y)^2))+ ...
                + sqrt(((P4X-P3X)^2)+((P4Y-P3Y)^2));
            obj.Length = length;
            
            %% Create link vectors
            obj.Link1X = [P1X P2X];
            obj.Link1Y = [P1Y P2Y];
            obj.Link2X = [P2X P3X];
            obj.Link2Y = [P2Y P3Y];
            obj.Link3X = [P3X P4X];
            obj.Link3Y = [P3Y P4Y];
        end
    end
end