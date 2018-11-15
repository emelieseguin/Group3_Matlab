classdef FourBarLinkageMathDefined
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
        function obj = FourBarLinkageMathDefined(personHeight, kneeJointXPos, kneeJointYPos, ...
            thighLength, shankLength, hipAngleZ, kneeAngleZ, qAngle)
            %% Initialize variables used for calculations
            obj.IntersectPointX = 0;
            obj.IntersectPointY = 0;
            
            % Convert angles to radians
            hipAngleZRads = deg2rad(hipAngleZ);
            % Change the knee to have flexsion +'ve in the CCW direction
            kneeAngleZRads = deg2rad((-1)*kneeAngleZ);
            
            % Variables needed for calculations
            kneeAngleRelative = kneeAngleZRads - hipAngleZRads;

            % Parameterized variables to pin the 4 bar linkage
            Ltopbartohip = 0.14045*personHeight; % Percentage of height, Can change value - in m (~0.25 for 1.78m)
            Ltopbar = .061798*personHeight; % Percentage of height, Can change value - in m (~0.11 for 1.78m)
            Lbotbar = .230337*personHeight; % Percentage of height, Can change value - in m (~0.41 for 1.78m)
            
            Lbot4BarFromKnee = shankLength - Lbotbar;
            
            % Try an equal distance above and below knee joint - 4 cm
            %distanceMeters = 0.04;
            %Lbot4BarFromKnee = distanceMeters;
            %LToThighBar = thighLength - 0.04;
            
            L1 = 0.025*personHeight; % Percentage of height, Can change value - in m (~0.0445 for 1.78m)
            L3 = 0.02298*personHeight; % Percentage of height, Can change value - in m (~0.0409 for 1.78m)
            Theta2 = 27.5; %manually change value
                Theta2Rads = deg2rad(Theta2);
            %Theta3 = 90 - Theta2;
            %    Theta3Rads = deg2rad(Theta3);
            Theta4 = 19.5; %manually change value
                Theta4Rads = deg2rad(Theta4);
            %Theta5Rads = 90 - Theta4Rads + kneeAngleRelative;
    
            %% Find the position of the thigh bar link
            % Hip Position
            x4 = 0;
            y4 = 0;
            
            % Create point R1 in space
            xR1Proj = 0;
            yR1Proj = (-1*(Ltopbar+Ltopbartohip));%(-1)*LToThighBar; %
            
            % Define the middle point of the thigh bar link
            [xR1, yR1] =  obj.RotatePointsAroundPoint(xR1Proj, yR1Proj, ...
                hipAngleZRads, 0, 0);

            % Give length of thigh bar from center to C,D
            xDProj = xR1+((1/2)*L3);
            yDProj = yR1;
            
            % Find point D in space rotate by - hip, theta2
            % Theta2 is a -'ve rotation since it is in the CW direction 
            [xD, yD] = obj.RotatePointsAroundPoint(xDProj, yDProj, ...
                hipAngleZRads, xR1, yR1);
            [xD, yD] = obj.RotatePointsAroundPoint(xD, yD, ...
                 (-1)*Theta2Rads, xR1, yR1);
            
            % Find ponit C in space, flip point D by 180 degress
            [xC, yC] = obj.RotatePointsAroundPoint(xD, yD, ...
                deg2rad(180), xR1, yR1);
            
            %% Find the position of the shank bar link
            xR2Proj = 0;
            yR2Proj = 0 - thighLength - Lbot4BarFromKnee;
            
            % Define the middle point of the shank bar link
            [xR2Proj, yR2Proj] = obj.RotatePointsAroundPoint(xR2Proj, yR2Proj, ...
                hipAngleZRads, 0, 0);
            [xR2, yR2] = obj.RotatePointsAroundPoint(xR2Proj, yR2Proj, ...
                kneeAngleZRads, kneeJointXPos, kneeJointYPos);
            
            % Give length of shank bar from center to B
            xBProj = xR2+((1/3)*L1);
            yBProj = yR2;
            
            % Find point B in space rotate by - theta4, hip, knee
            [xB, yB] = obj.RotatePointsAroundPoint(xBProj, yBProj, ...
                hipAngleZRads, xR2, yR2);
            [xB, yB] = obj.RotatePointsAroundPoint(xB, yB, ...
                kneeAngleZRads, xR2, yR2);
            [xB, yB] = obj.RotatePointsAroundPoint(xB, yB, ...
                (-1)*Theta4Rads, xR2, yR2);
            
            % Give length of shank bar from center to A
            xAProj = xR2+((2/3)*L1);
            yAProj = yR2;
            
            % Find point A in space rotate by - theta4, hip, knee, flip (180)
            [xA, yA] = obj.RotatePointsAroundPoint(xAProj, yAProj, ...
                hipAngleZRads, xR2, yR2);
            [xA, yA] = obj.RotatePointsAroundPoint(xA, yA, ...
                kneeAngleZRads, xR2, yR2);
            [xA, yA] = obj.RotatePointsAroundPoint(xA, yA, ...
                (-1)*Theta4Rads, xR2, yR2);
            [xA, yA] = obj.RotatePointsAroundPoint(xA, yA, ...
                deg2rad(180), xR2, yR2);
            
            %% Create the linkages in space using math - dynamics
            L1 = 44.5/1000;
            L2 = 51.6/1000;
            L3 = 40.9/1000;
            L4 = 47.2/1000;
            femoralPitch = -27.5;
            tibialPitch = 19.5;
            qAngleRads = deg2rad(qAngle);
            
            [phi1, phi2] = obj.FindProperFourBarAngles(L1, L2, L3, L4, deg2rad(qAngle), tibialPitch, ...
                xB, yB);            
            
            % Get the stupid angle things
            
                       
            %% Create the link vectors, attaching proper points to define links
            % Create link vectors
            %obj.Link1X = [xA xB]; % Bottom Link - on shank
            %obj.Link1Y = [yA yB];
            
            link2XDisp = L2*cos(qAngleRads);
            link2YDisp = L2*sin(qAngleRads);
            
            link3XDisp = L3*cos(phi1);
            link3YDisp = L3*sin(phi1);
            
            link4XDisp = L4*cos(phi2);
            link4YDisp = L4*sin(phi2);
            
            link1XDisp = L1*cos(deg2rad(360-tibialPitch));
            link1YDisp = L1*sin(deg2rad(360-tibialPitch));
            
            xC = (xB+link2XDisp);
            yC = (yB+link2YDisp);
            obj.Link2X = [xB xC];
            obj.Link2Y = [yB yC];
            
            %obj.Link2X = [xB xC];
            %obj.Link2Y = [yB yC];
            
            xD = (xC+link3XDisp);
            yD = (yC+link3YDisp);
            obj.Link3X = [xC xD];
            obj.Link3Y = [yC yD];
            
            % Wrong phi right now, so until this fixed just connect it
            xA = xD+link4XDisp;   % - should bring back to 0
            yA = yD+link4YDisp; 
            obj.Link4X = [xD xA];
            obj.Link4Y = [yD yA];
            
            obj.Link1X = [xA xB]; % Bottom Link - on shank
            obj.Link1Y = [yA yB];
            
            % Create the link lines
            obj.Link1Line = [xA xB;yA yB];
            obj.Link2Line = [xB xC;yB yC];
            obj.Link3Line = [xC xD;yC yD];
            obj.Link4Line = [xD xA;yD yA];
            
            %distLink3 = sum(sqrt(diff(obj.Link3X).^2+diff(obj.Link3Y).^2));
            %distLink4 = sum(sqrt(diff(obj.Link4X).^2+diff(obj.Link4Y).^2));
            
            % Link 2 and link 4 are the ones that overlap, find
            % intersection
            inter = LineIntersection(obj.Link2Line, obj.Link4Line);
            if(~isempty(inter))
                obj.IntersectPointX = inter(1);
                obj.IntersectPointY = inter(2);
            end
            
            %% Tests to run to verify constant lengths
            % Test to make sure the links are always the same length
            obj.CheckLengthConsistent('Link1 ', obj.Link1X, obj.Link1Y);
            %obj.CheckLengthConsistent('Link2 ', obj.Link2X, obj.Link2Y);
            %obj.CheckLengthConsistent('Link3 ', obj.Link3X, obj.Link3Y);
            %obj.CheckLengthConsistent('Link4 ', obj.Link4X, obj.Link4Y);
            
            
            %obj.CheckLengthConsistent('Distance from knee joint to Shank Center ', ...
            %    [xR2 kneeJointXPos], [yR2 kneeJointYPos]);
            %obj.CheckLengthConsistent('Distance from knee joint to Thigh Center ', ...
            %    [xR1 kneeJointXPos], [yR1 kneeJointYPos]);
            
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
        %% Not needed for now, this would allow for proper angles on the 4 bar
        function [phi1, phi2] = FindProperFourBarAngles(~, L1, L2, L3, L4, qAngleRads, tibialPitch, ...
                xB, yB)
                phi1 = 0; phi2 = 0;
                % Create an inline function to define the 4Bar equations
                function F = root2d(phi)
                    F(1) = L2*cos(qAngleRads) + L3*cos(phi(1)) + L4*cos(phi(2)) + L1*cos(deg2rad(-tibialPitch));
                    F(2) = L2*sin(qAngleRads) + L3*sin(phi(1)) + L4*sin(phi(2)) + L1*sin(deg2rad(-tibialPitch));
                end
                
                options = optimset('Display','off');
                
            for i=1:360
                fun = @root2d;
                
                % 330 defines proper angles the majority of the time
                iterationConditions = 330;
                % First check 330 - 359 for the proper linkage position
                if(i < 30)
                    iterationConditions = iterationConditions + i;
                % Next check 330 - 0 for the proper linkage position
                else
                    iterationConditions = iterationConditions - i;
                end
                
                theta0 = [deg2rad(iterationConditions),deg2rad(iterationConditions)];
                phi = fsolve(fun, theta0, options);

                % Draw the linkages, so that the lines in space are defined
                link2XDisp = L2*cos(qAngleRads);
                link2YDisp = L2*sin(qAngleRads);

                link3XDisp = L3*cos(phi(1));
                link3YDisp = L3*sin(phi(1));

                link4XDisp = L4*cos(phi(2));
                link4YDisp = L4*sin(phi(2));

                %link1XDisp = L1*cos(deg2rad(360-tibialPitch));
                %link1YDisp = L1*sin(deg2rad(360-tibialPitch));

                xC = (xB+link2XDisp);
                yC = (yB+link2YDisp);
                
                xD = (xC+link3XDisp);
                yD = (yC+link3YDisp);
                xA = xD+link4XDisp;   % - should bring back to 0
                yA = yD+link4YDisp; 
                
                Link2= [xB xC;yB yC];
                Link4 = [xD xA;yD yA];
                
                % Link 2 and link 4 are the ones that overlap, find intersection
                inter = LineIntersection(Link2, Link4);
                if(~isempty(inter)) % probably need to validate it is greater but do this after
                    phi1 = phi(1);
                    phi2 = phi(2);
                    break;
                end 
            end
            
            % Find an issue if there is one - take this out later, just a
            % check for not %%%%
            if(phi1==0 && phi2==0)
                disp('No solution found')
            end
            
            % Test check to make sure the values approximately equal 0
            valEqn1 = L2*cos(qAngleRads) + L3*cos(phi1) + L4*cos(phi2) + L1*cos(deg2rad(360-tibialPitch));
            valEqn2 = L2*sin(qAngleRads) + L3*sin(phi1) + L4*sin(phi2) + L1*sin(deg2rad(360-tibialPitch));
            
            % Check if it is above the point
            % Check if it intersects - needs to intersect the whole time
        end
    end
end
