classdef DorsiFlexionSpringPosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
       
        Length
        % Used to find moment contribution
        AppliedToeCableForceAngle
        distanceFromAnkle2ToeCableX
        distanceFromAnkle2ToeCableY
    end
    
    methods
        function obj = DorsiFlexionSpringPosition(position, anthroDimensionMap, ...
                hipAngleZ, kneeAngleZ, ankleAngleZ, footAngleZ)
        %% Setting up the variables to be used
        r = 0.01111; %radius of the pulley wheel
        global leftShankLength thighLength;
        lThigh = anthroDimensionMap(thighLength);
        lShank = anthroDimensionMap(leftShankLength);
        hipAngleZRads = deg2rad(hipAngleZ);
        kneeAngleZRads = deg2rad(kneeAngleZ);

        %% Determining the coordinates of 4 points
        P1X =  position.ThighComXPoint + (0.05+r)*cos(hipAngleZRads);
        P1Y = position.ThighComYPoint + (0.05+r)*sin(hipAngleZRads);

        P2X = 0.9*lThigh*sin(hipAngleZRads) + (0.05+r)*cos(hipAngleZRads);
        P2Y = -0.9*lThigh*cos(hipAngleZRads) + (0.05+r)*sin(hipAngleZRads);

        if (kneeAngleZRads>hipAngleZRads)
            P3X = position.KneeJointX - 0.2*lShank*sin(kneeAngleZRads-hipAngleZRads) + (0.05+r)*cos(kneeAngleZRads-hipAngleZRads);
            P3Y = position.KneeJointY - 0.2*lShank*cos(kneeAngleZRads-hipAngleZRads) - (0.05+r)*sin(kneeAngleZRads-hipAngleZRads);
        elseif (kneeAngleZRads<hipAngleZRads)
            P3X = position.KneeJointX + 0.2*lShank*sin(hipAngleZRads-kneeAngleZRads) + (0.05+r)*cos(hipAngleZRads-kneeAngleZRads);
            P3Y = position.KneeJointY - 0.2*lShank*cos(kneeAngleZRads-hipAngleZRads) + (0.05+r)*sin(kneeAngleZRads-hipAngleZRads);
        end

        %% Foot Pulley Position -- this cannot be at the toe
        P4X = position.ToeX;
        P4Y = position.ToeY;
        
        %% Attachment of Cable
        obj.distanceFromAnkle2ToeCableX = position.ToeX - position.AnkleJointX;
        obj.distanceFromAnkle2ToeCableY =  position.AnkleJointY -  position.ToeY;
        
        % Angle that the force is applied to the toe at
        AppliedForceAngleFromXAxis = 120;
        obj.AppliedToeCableForceAngle = AppliedForceAngleFromXAxis+footAngleZ;

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
        end
    end
end