classdef AngularAcceleration
    properties
        captureRate
        
        % Angular Velocity Equations
        angularVelocityThigh
        angularVelocityEq_Thigh
        
        angularVelocityShank
        angularVelocityEq_Shank
        
        angularVelocityFoot
        angularVelocityEq_Foot
        
        % Acceleration Equations
        angularAccelThigh
        angularAccelShank
        angularAccelFoot
    end 
    
    methods
        function obj = AngularAcceleration(positionArray, cadence)
            
            % Calculate the time between positions - Should be cadence/101
            obj.captureRate = cadence / length(positionArray);
            
            % Iterate through the array to get all the velocities
            for index = 1:(length(positionArray)-1)
                position = positionArray(index);
                nextPosition = positionArray(index+1);
                % Get all velocities from the inputted data
                obj.angularVelocityThigh(index) = obj.GetAngularVelocityThigh(position, nextPosition, obj.captureRate);
                obj.angularVelocityShank(index) = obj.GetAngularVelocityKnee(position, nextPosition, obj.captureRate);
                obj.angularVelocityFoot(index) = obj.GetAngularVelocityFoot(position, nextPosition, obj.captureRate);
            end
            
            [obj.angularVelocityEq_Thigh, obj.angularAccelThigh] = obj.GetAccelerationEquation(obj.angularVelocityThigh);
            [obj.angularVelocityEq_Shank, obj.angularAccelShank] = obj.GetAccelerationEquation(obj.angularVelocityShank);
            [obj.angularVelocityEq_Foot, obj.angularAccelFoot] = obj.GetAccelerationEquation(obj.angularVelocityFoot);
        end
        
        function thighAngularVelocity = GetAngularVelocityThigh(~, position, nextPosition, captureRate)
            %+'ve angular velocity in the CCW Direction
            angleDiffernce = nextPosition.HipAngleZ - position.HipAngleZ;
            
            % Get velocity by dividing by the time between captures
            thighAngularVelocity = angleDiffernce / captureRate;
        end
        
        function kneeAngularVelocity = GetAngularVelocityKnee(~, position, nextPosition, captureRate)
             %+'ve angular velocity in the CCW Direction (usually positive CW, so times by -1)
            angleDiffernce = -1*(nextPosition.KneeAngleZ - position.KneeAngleZ);
            
            % Get velocity by dividing by the time between captures
            kneeAngularVelocity = angleDiffernce / captureRate;
        end
        
        function footAngularVelocity = GetAngularVelocityFoot(~, position, nextPosition, captureRate)
            %+'ve angular velocity in the CCW Direction
            angleDiffernce = nextPosition.FootAngleZ - position.FootAngleZ;
            
            % Get velocity by dividing by the time between captures
            footAngularVelocity = angleDiffernce / captureRate;
        end
        
        function [velocityEquation, accelEquation] = GetAccelerationEquation(~, velocityArray)
            xScale = 0:(length(velocityArray) -1);
            yScale = velocityArray;
            
            % Find the coefficients. - suppress warnings for polyfit, no difference is
            % seen with extra parameters
            warning('off');
            [coeffs] = polyfit(xScale, yScale, 20);
            warning('on');
            
            % Find and display the equation for the velocity of the segments
            velocityEquation = poly2sym(coeffs);
            
            % Take the derivative of the velocity equation to get the acceleration
            accelEquation = diff(velocityEquation);
        end
        
        function PlotVelocityInterpolationCurves(linAngAccelObj)
            figure
            
            % Plot the Thigh velocity
            topLeft = subplot(3,1,1);
            thighVelocity_XScale = 0:(length(linAngAccelObj.angularVelocityThigh) -1);
            thighVelocity_YScale = linAngAccelObj.angularVelocityThigh;
            
            plot(topLeft, thighVelocity_XScale, thighVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(topLeft, linAngAccelObj.angularVelocityEq_Thigh, [min(thighVelocity_XScale), max(thighVelocity_XScale)], 'b-', 'LineWidth', 2);
            title(topLeft,'Thigh Angular Velocity');
            
            % Plot the Shank velocity
            middleLeft = subplot(3,1,2);
            shankVelocity_XScale = 0:(length(linAngAccelObj.angularVelocityShank) -1);
            shankVelocity_YScale = linAngAccelObj.angularVelocityShank;
            
            plot(middleLeft, shankVelocity_XScale, shankVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(middleLeft, linAngAccelObj.angularVelocityEq_Shank, [min(shankVelocity_XScale), max(shankVelocity_XScale)], 'b-', 'LineWidth', 2);
            title(middleLeft,'Shank Angular Velocity');
            
            % Plot the Foot velocity
            bottomLeft = subplot(3,1,3);
            footVelocity_XScale = 0:(length(linAngAccelObj.angularVelocityFoot) -1);
            footVelocity_YScale = linAngAccelObj.angularVelocityFoot;
            
            plot(bottomLeft, footVelocity_XScale, footVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(bottomLeft, linAngAccelObj.angularVelocityEq_Foot, [min(footVelocity_XScale), max(footVelocity_XScale)], 'b-', 'LineWidth', 2);
            title(bottomLeft,'Foot Angular Velocity');
        end
        
        function PlotAccelerationCurves(obj)
            figure
            % Plot the angular Acceleration of the Thigh
            top = subplot(3,1,1);

            fplot(top, obj.angularAccelThigh, [0, 99], 'b-', 'LineWidth', 2);
            title(top,'Thigh Angular Acceleration');
            
            % Plot the angular Acceleration of the Shank
            middle = subplot(3,1,2);

            fplot(middle, obj.angularAccelShank, [0, 99], 'b-', 'LineWidth', 2);
            title(middle,'Shank Angular Acceleration');
            
            % Plot the angular Acceleration of the Foot
            bottom = subplot(3,1,3);

            fplot(bottom, obj.angularAccelFoot, [0, 99], 'b-', 'LineWidth', 2);
            title(bottom,'Foot Angular Acceleration');
        end
    end
end