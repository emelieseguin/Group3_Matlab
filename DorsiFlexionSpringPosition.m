classdef DorsiFlexionSpringPosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
        Link4X
        Link4Y
        Link5X
        Link5Y
       
        Length
    end
    
    methods
        function obj = DorsiFlexionSpringPosition(personHeight,kneeJointXPos, kneeJointYPos, ...
            ankleJointX, ankleJointY, thighCOMX, thighCOMY, footCOMX, footCOMY, shankCOMX, shankCOMY, ...
            hipAngleZ, kneeAngleZ, ankleAngleZ, footAngleZ, toeX, toeY)
            
            % Some initially set variables
            r = 0.01111;
            lThigh = 0.245*personHeight;
            lShank = 0.246*personHeight;
            lFoot = 0.152*personHeight;
            
            % Setting up and converting angles of foot and ankle to radians
            hipAngleZRads = deg2rad(hipAngleZ);
            kneeAngleZRads = deg2rad(kneeAngleZ);
            ankleAngleZRads = deg2rad(ankleAngleZ);
            footAngleZRads = deg2rad(footAngleZ);
           
            if footAngleZ>=0
               theta1 = deg2rad(90-(ankleAngleZ-footAngleZ));
               theta2 = deg2rad(90)-theta1;
            elseif footAngleZ<0
               theta1 = deg2rad(90-(abs(footAngleZ))-ankleAngleZ);
               theta2 = deg2rad(90)-theta1;
            end
            
            % Setting up the coordinates of all 6 points
            P1X = thighCOMX + (0.05+r)*cos(hipAngleZRads);
            P1Y = thighCOMY + (0.05+r)*sin(hipAngleZRads);
            
            P2X = 0.9*lThigh*sin(hipAngleZRads) + (0.05+r)*cos(hipAngleZRads);
            P2Y = -0.9*lThigh*cos(hipAngleZRads) + (0.05+r)*sin(hipAngleZRads);
      
            P3X = ankleJointX + 0.8*lShank*cos(theta1) + (0.05+r)*cos(theta2);
            P3Y = ankleJointY + 0.8*lShank*sin(theta1) - (0.05+r)*sin(theta2);
            
            P4X = ankleJointX + 0.125*lFoot*cos(footAngleZRads) + 0.05*cos((pi/2)-footAngleZRads) + r*cos((pi/2)-footAngleZRads);
            P4Y = ankleJointY - 0.05*sin((pi/2)-footAngleZRads) - r*sin((pi/2)-footAngleZRads);
            
            P5X = ankleJointX + 0.75*lFoot*cos(footAngleZRads) - (0.05+r)*cos((pi/2)-footAngleZRads);
            P5Y = ankleJointY + 0.9*lFoot*sin(footAngleZRads) + (0.05+r)*sin((pi/2)-footAngleZRads);
            
            P6X = toeX;
            P6Y = toeY;
            
            % Determining the length of all 6 coordinates
            length = sqrt(((P2X-P1X)^2)+((P2Y-P1Y)^2)) + sqrt(((P3X-P2X)^2)+((P3Y-P2Y)^2))+...
                sqrt(((P4X-P3X)^2)+((P4Y-P3Y)^2)) + sqrt(((P5X-P4X)^2)+((P5Y-P4Y)^2)) + ...
                sqrt(((P6X-P5X)^2)+((P6Y-P5Y)^2));
            
            obj.Length = length;
            
            % Create link vectors
            obj.Link1X = [P1X P2X];
            obj.Link1Y = [P1Y P2Y];
            obj.Link2X = [P2X P3X];
            obj.Link2Y = [P2Y P3Y];
            obj.Link3X = [P3X P4X];
            obj.Link3Y = [P3Y P4Y];
            obj.Link4X = [P4X P5X];
            obj.Link4Y = [P4Y P5Y];
            obj.Link5X = [P5X P6X];
            obj.Link5Y = [P5Y P6Y];
        end
    end
end