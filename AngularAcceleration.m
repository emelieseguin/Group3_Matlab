classdef AngularAcceleration
    properties
        captureRate
        timeForGaitCycle
        
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
        
        % Calculate the Average Angular Velocity Equations
        avgAngularAccelThigh
        avgAngularAccelShank
        avgAngularAccelFoot
    end 
    
    methods
        function obj = AngularAcceleration(positionArray, timeForGaitCycle)
            
            % Calculate the time between positions - Should be timeForGaitCycle/101
            obj.captureRate = timeForGaitCycle / length(positionArray);
            obj.timeForGaitCycle = timeForGaitCycle;
            % Iterate through the array to get all the velocities -
            % patient 29
            for index = 1:(length(positionArray)-1)
                position = positionArray(index);
                nextPosition = positionArray(index+1);
                % Get all velocities from the inputted data
                obj.angularVelocityThigh(index) = obj.GetAngularVelocityThigh(position, nextPosition, obj.captureRate);
                obj.angularVelocityShank(index) = obj.GetAngularVelocityKnee(position, nextPosition, obj.captureRate);
                obj.angularVelocityFoot(index) = obj.GetAngularVelocityFoot(position, nextPosition, obj.captureRate);
            end
            
            [obj.angularVelocityEq_Thigh, obj.angularAccelThigh] = obj.GetAccelerationEquation(obj.angularVelocityThigh, timeForGaitCycle);
            [obj.angularVelocityEq_Shank, obj.angularAccelShank] = obj.GetAccelerationEquation(obj.angularVelocityShank, timeForGaitCycle);
            [obj.angularVelocityEq_Foot, obj.angularAccelFoot] = obj.GetAccelerationEquation(obj.angularVelocityFoot, timeForGaitCycle);
            
            [obj.avgAngularAccelThigh] = obj.GetAvgAccelerationEquation(obj.angularVelocityThigh, obj.captureRate);
            [obj.avgAngularAccelShank] = obj.GetAvgAccelerationEquation(obj.angularVelocityShank, obj.captureRate);
            [obj.avgAngularAccelFoot] = obj.GetAvgAccelerationEquation(obj.angularVelocityFoot, obj.captureRate);
        end
        
        function thighAngularVelocity = GetAngularVelocityThigh(~, position, nextPosition, captureRate)
            %+'ve angular velocity in the CCW Direction
            angleDifference = deg2rad(nextPosition.HipAngleZ) - deg2rad(position.HipAngleZ);
            
            % Get velocity by dividing by the time between captures
            thighAngularVelocity = angleDifference / captureRate;
        end
        
        function kneeAngularVelocity = GetAngularVelocityKnee(~, position, nextPosition, captureRate)
             %+'ve angular velocity in the CCW Direction (positive CW for knee rotation, so times by -1)
            angleDifference = -1*(deg2rad(nextPosition.KneeAngleZ) - deg2rad(position.KneeAngleZ));
            
            % Get velocity by dividing by the time between captures
            kneeAngularVelocity = angleDifference / captureRate;
        end
        
        function footAngularVelocity = GetAngularVelocityFoot(~, position, nextPosition, captureRate)
            %+'ve angular velocity in the CCW Direction
            angleDifference = deg2rad(nextPosition.FootAngleZ) - deg2rad(position.FootAngleZ);
            
            % Get velocity by dividing by the time between captures
            footAngularVelocity = angleDifference / captureRate;
        end
        
        function [velocityEquation, accelEquation] = GetAccelerationEquation(~, velocityArray, timeForGaitCycle)
            xScaleTime = linspace(0, timeForGaitCycle, (length(velocityArray)));
            yScale = velocityArray;
            
            % Find the coefficients. - suppress warnings for polyfit, no difference is
            % seen with extra parameters
            warning('off');
            [coeffs] = polyfit(xScaleTime, yScale, 20);
            warning('on');
            
            % Find and display the equation for the velocity of the segments
            velocityEquation = poly2sym(coeffs);
            
            % Take the derivative of the velocity equation to get the acceleration
            accelEquation = diff(velocityEquation);
        end
        
        % Get the average acceleration
        function accelEquation = GetAvgAccelerationEquation(~, velocityArray, captureRate)
            
            accelEquation = zeros(1,(length(velocityArray)-1));
            
            for index = 1:(length(velocityArray)-1)
                current = velocityArray(index);
                next = velocityArray(index+1);
                accelEquation(index) = ((next-current)/captureRate);
            end
        end
        
        function PlotVelocityInterpolationCurves(linAngAccelObj)
            figure
            % Plot the Thigh velocity
            topLeft = subplot(3,1,1);
            thighVelocity_XScale = 1:(length(linAngAccelObj.angularVelocityThigh));
            xScaleTime = linspace(0, linAngAccelObj.timeForGaitCycle, (length(linAngAccelObj.angularVelocityThigh)));
            thighVelocity_YScale = linAngAccelObj.angularVelocityThigh;
            
            %plot(topLeft, thighVelocity_XScale, thighVelocity_YScale, 'ro', 'MarkerSize', 5);
            plot(topLeft, xScaleTime, thighVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            %fplot(topLeft, linAngAccelObj.angularVelocityEq_Thigh, [min(thighVelocity_XScale), max(thighVelocity_XScale)], 'b-', 'LineWidth', 2);
            fplot(topLeft, linAngAccelObj.angularVelocityEq_Thigh, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(topLeft,'Thigh Angular Velocity');
            
            % Plot the Shank velocity
            middleLeft = subplot(3,1,2);
            shankVelocity_XScale = 1:(length(linAngAccelObj.angularVelocityShank));
            shankVelocity_YScale = linAngAccelObj.angularVelocityShank;
            
            %plot(middleLeft, shankVelocity_XScale, shankVelocity_YScale, 'ro', 'MarkerSize', 5);
            plot(middleLeft, xScaleTime, shankVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            %fplot(middleLeft, linAngAccelObj.angularVelocityEq_Shank, [min(shankVelocity_XScale), max(shankVelocity_XScale)], 'b-', 'LineWidth', 2);
            fplot(middleLeft, linAngAccelObj.angularVelocityEq_Shank, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(middleLeft,'Shank Angular Velocity');
            
            % Plot the Foot velocity
            bottomLeft = subplot(3,1,3);
            %footVelocity_XScale = 1:(length(linAngAccelObj.angularVelocityFoot));
            footVelocity_YScale = linAngAccelObj.angularVelocityFoot;
            
            %plot(bottomLeft, footVelocity_XScale, footVelocity_YScale, 'ro', 'MarkerSize', 5);
            plot(bottomLeft, xScaleTime, footVelocity_YScale, 'ro', 'MarkerSize', 5);
            hold on
            %fplot(bottomLeft, linAngAccelObj.angularVelocityEq_Foot, [min(footVelocity_XScale), max(footVelocity_XScale)], 'b-', 'LineWidth', 2);
            fplot(bottomLeft, linAngAccelObj.angularVelocityEq_Foot, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(bottomLeft,'Foot Angular Velocity');
        end
        
        function PlotAccelerationCurves(obj)
            figure
            % Plot the angular Acceleration of the Thigh
            top = subplot(3,1,1);

            fplot(top, obj.angularAccelThigh, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(top,'Thigh Angular Acceleration');
            
            % Plot the angular Acceleration of the Shank
            middle = subplot(3,1,2);

            fplot(middle, obj.angularAccelShank, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(middle,'Shank Angular Acceleration');
            
            % Plot the angular Acceleration of the Foot
            bottom = subplot(3,1,3);

            fplot(bottom, obj.angularAccelFoot, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(bottom,'Foot Angular Acceleration');
            xlabel('% Gait Cycle') 
            ylabel('Degrees/s^2') 
        end
        
        
        function PlotAvgAccelerationCurves(obj)
            figure
            
            xScale = 1:(length(obj.avgAngularAccelThigh));
            % Plot the angular Acceleration of the Thigh
            top = subplot(3,1,1);

            plot(top, xScale,obj.avgAngularAccelThigh, 'b-', 'LineWidth', 2);
            title(top,'Thigh Angular Acceleration');
            
            % Plot the angular Acceleration of the Shank
            middle = subplot(3,1,2);

            plot(middle, xScale, obj.avgAngularAccelShank, 'b-', 'LineWidth', 2);
            title(middle,'Shank Angular Acceleration');
            
            % Plot the angular Acceleration of the Foot
            bottom = subplot(3,1,3);

            plot(bottom, xScale, obj.avgAngularAccelFoot, 'b-', 'LineWidth', 2);
            title(bottom,'Foot Angular Acceleration');
            xlabel('% Gait Cycle') 
            ylabel('Degrees/s^2') 
        end
    end
end