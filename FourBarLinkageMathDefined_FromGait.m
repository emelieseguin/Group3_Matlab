classdef FourBarLinkageMathDefined_FromGait
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
        TopBarLinkageDistanceChange
        BottomBarLinkageDistanceChange
        
        % Iteration condition that solved the 4 bar
        solvedIterationConditions
        
        % 4Bar dimensions
        L1
        L2
        L3
        L4
        
        % Solved Angles
        theta1
        theta2
        thetaL3
        thetaL1
        
        % Top Bar Displacement
        TopBarMovementX
        TopBarMovementY
    end
    
    methods
        function obj = FourBarLinkageMathDefined_FromGait(personHeight, kneeJointXPos, kneeJointYPos, ...
            thighLength, shankLength, hipAngleZ, kneeAngleZ, thighLine, shankLine)
            %% Initialize variables used for calculations
            obj.IntersectPointX = 0;
            obj.IntersectPointY = 0;
            
            % Convert angles to radians
            hipAngleZRads = deg2rad(hipAngleZ);
            % Change the knee to have flexsion +'ve in the CCW direction
            kneeAngleZRads = deg2rad((-1)*kneeAngleZ);
            
            % Variables needed for calculations
            kneeAngleRelative = (-1)*kneeAngleZRads - hipAngleZRads;        
            Lbot4BarFromKnee = (0.01110937/1.78)*personHeight;
            
           
            Theta4 = 19.5; 
            Theta4Rads = deg2rad(Theta4);
            
            %% Dimensions of the four-bar linkage
            L1 = ((44.5/1000)/1.78)*personHeight;
            obj.L1 = L1;
            L2 = ((51.6/1000)/1.78)*personHeight;
            obj.L2 = L2;
            L3 = ((40.9/1000)/1.78)*personHeight;
            obj.L3 = L3;
            L4 = ((47.2/1000)/1.78)*personHeight;
            obj.L4 = L4;
            % Constant values
            femoralPitch = 27.5;
            tibialPitch = 19.5;
            tibialPitchRads = deg2rad(tibialPitch);
            
            %% Find the position of Pin 3 on the shank bar link
            xR2Proj = 0;
            yR2Proj = 0 - thighLength - Lbot4BarFromKnee;
            
            % Define the middle point of the shank bar link
            [xR2Proj, yR2Proj] = obj.RotatePointsAroundPoint(xR2Proj, yR2Proj, ...
                hipAngleZRads, 0, 0);
            [xR2, yR2] = obj.RotatePointsAroundPoint(xR2Proj, yR2Proj, ...
                kneeAngleZRads, kneeJointXPos, kneeJointYPos);
            
            % Give length of shank bar from center to B
            xBProj = xR2+((0.01000034/1.78)*personHeight);
            yBProj = yR2;
            
            % Find point B in space rotate by - theta4, hip, knee
            [xB, yB] = obj.RotatePointsAroundPoint(xBProj, yBProj, ...
                hipAngleZRads, xR2, yR2);
            [xB, yB] = obj.RotatePointsAroundPoint(xB, yB, ...
                kneeAngleZRads, xR2, yR2);
            [xB, yB] = obj.RotatePointsAroundPoint(xB, yB, ...
                (-1)*tibialPitchRads, xR2, yR2);
            
            %% Create the linkages in space using dynamics
            
            Link3AngleFromHorz = hipAngleZRads - deg2rad(femoralPitch);
            Link1AngleFromHorz = -kneeAngleRelative - deg2rad(tibialPitch);
            obj.thetaL3 = rad2deg(Link3AngleFromHorz);
            obj.thetaL1 = rad2deg(Link1AngleFromHorz);
            
            % Iterate through and solve for the proper conditions
            [theta1, theta2, obj.solvedIterationConditions] = obj.FindProperFourBarAngles(L1, L2, L3, L4, ...
                xB, yB, Link1AngleFromHorz, Link3AngleFromHorz);            
            
            % The angles solved for in degrees
            obj.theta1 = rad2deg(theta1);
            obj.theta2 = rad2deg(theta2);
                       
            %% Create the link vectors, attaching proper points to define links
            
            link2XDisp = L2*cos(theta1);
            link2YDisp = L2*sin(theta1);

            link3XDisp = L3*cos(Link3AngleFromHorz);
            link3YDisp = L3*sin(Link3AngleFromHorz);

            link4XDisp = L4*cos(theta2);
            link4YDisp = L4*sin(theta2);
            
            link1XDisp = L1*cos(Link1AngleFromHorz);
            link1YDisp = L1*sin(Link1AngleFromHorz);
            
            xC = (xB+link2XDisp);
            yC = (yB+link2YDisp);
            obj.Link2X = [xB xC];
            obj.Link2Y = [yB yC];
            
            xD = (xC+link3XDisp);
            yD = (yC+link3YDisp);
            obj.Link3X = [xC xD];
            obj.Link3Y = [yC yD];

            xA = xD+link4XDisp;   
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
            
            % Link 2 and link 4 are the ones that overlap, find
            % intersection
            inter = LineIntersection(obj.Link2Line, obj.Link4Line);
            if(~isempty(inter))
                obj.IntersectPointX = inter(1);
                obj.IntersectPointY = inter(2);
            end
            
            %% See how much the linkages translate with respect to the middle of the leg
            % Top Linkage
            topIntersection = LineIntersection(thighLine, obj.Link3Line);
            
            obj.TopBarLinkageDistanceChange = sum(sqrt(diff([topIntersection(1), xD]).^2+diff([topIntersection(2) yD]).^2));
            obj.TopBarMovementX = topIntersection(1) - xD;
            obj.TopBarMovementY = topIntersection(2) - yD;
            
            bottomIntersection = LineIntersection(shankLine, obj.Link1Line);
            obj.BottomBarLinkageDistanceChange = sum(sqrt(diff([bottomIntersection(1), xB]).^2+diff([bottomIntersection(2) yB]).^2));
            
            %% Log dimensions of 4bar ??
            
            %% Tests to run to verify constant lengths
            % Test to make sure the links are always the same length
            %obj.CheckLengthConsistent('Link1 ', obj.Link1X, obj.Link1Y);
            %obj.CheckLengthConsistent('Link2 ', obj.Link2X, obj.Link2Y);
            %obj.CheckLengthConsistent('Link3 ', obj.Link3X, obj.Link3Y);
            %obj.CheckLengthConsistent('Link4 ', obj.Link4X, obj.Link4Y);
            
            
            %obj.CheckLengthConsistent('Distance from knee joint to Shank Center ', ...
            %    [xR2 kneeJointXPos], [yR2 kneeJointYPos]);
            %obj.CheckLengthConsistent('Distance from knee joint to Thigh Center ', ...
            %    [xR1 kneeJointXPos], [yR1 kneeJointYPos]);
            
            % 4 Bar position length check
            %obj.CheckLengthConsistent('Middle of Shank to Point B: ', [bottomIntersection(1), xB], ...
            %     [bottomIntersection(2) yB]);
            %obj.CheckLengthConsistent('Middle of Thigh to Point D: ', [topIntersection(1), xD], ...
            %    [topIntersection(2) yD]);
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
        %% Find proper angles for the 4 bar
        function [theta1, theta2, solvedIterationConditions] = FindProperFourBarAngles(~, L1, L2, L3, L4, ...
                xB, yB, Link1AngleFromHorz, Link3AngleFromHorz)
                
                % Define default angles
                theta1 = 0; theta2 = 0;
                
                % Create an inline function to define the 4Bar equations
                function F = root2d(theta)
                    F(1) = L2*cos(theta(1)) + L3*cos(Link3AngleFromHorz) + L4*cos(theta(2)) + L1*cos(Link1AngleFromHorz);
                    F(2) = L2*sin(theta(1)) + L3*sin(Link3AngleFromHorz) + L4*sin(theta(2)) + L1*sin(Link1AngleFromHorz);
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
                theta = fsolve(fun, theta0, options);

                % Draw the linkages, so that the lines in space are defined
                link2XDisp = L2*cos(theta(1));
                link2YDisp = L2*sin(theta(1));

                link3XDisp = L3*cos(Link3AngleFromHorz);
                link3YDisp = L3*sin(Link3AngleFromHorz);

                link4XDisp = L4*cos(theta(2));
                link4YDisp = L4*sin(theta(2));

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
                if(~isempty(inter) && (yD > yB)) % Check that it intersects and that it is above
                    theta1 = theta(1);
                    theta2 = theta(2);
                    solvedIterationConditions = iterationConditions;
                    break;
                end 
            end
            
            % Test check to make sure the values approximately equal 0
            valEqn1 = L2*cos(theta(1)) + L3*cos(Link3AngleFromHorz) + L4*cos(theta(2)) + L1*cos(deg2rad(Link1AngleFromHorz));
            valEqn2 = L2*sin(theta(1)) + L3*sin(Link3AngleFromHorz) + L4*sin(theta(2)) + L1*sin(deg2rad(Link1AngleFromHorz));
        end
    end
end
