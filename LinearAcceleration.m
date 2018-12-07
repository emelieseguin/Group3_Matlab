classdef LinearAcceleration
    properties
        captureRate
        timeForGaitCycle
        
        % Linear Velocity Equations
        linearVelocityThighX
        linearVelocityThighY
        linearVelocityEq_ThighX
        linearVelocityEq_ThighY
        
        linearVelocityShankX
        linearVelocityShankY
        linearVelocityEq_ShankX
        linearVelocityEq_ShankY
        
        linearVelocityFootX
        linearVelocityFootY
        linearVelocityEq_FootX
        linearVelocityEq_FootY
        
        % Acceleration Equations
        linearAccelThighX
        linearAccelThighY
        
        linearAccelShankX
        linearAccelShankY
        
        linearAccelFootX
        linearAccelFootY
        
        % Avg Acceleration Equations
        linearAvgAccelThighX
        linearAvgAccelThighY
        
        linearAvgAccelShankX
        linearAvgAccelShankY
        
        linearAvgAccelFootX
        linearAvgAccelFootY
        
         % Values to Plot
         linearFootAccelXPlot
         linearFootAccelYPlot
    end 
    
    methods
        function obj = LinearAcceleration(positionArray, timeForGaitCycle)
            
            % Calculate the time between positions - Should be timeForGaitCycle/101
            obj.captureRate = timeForGaitCycle / length(positionArray);
            obj.timeForGaitCycle = timeForGaitCycle;
            
            % Iterate through the array to get all the velocities ---
            % patient 29
            for index = 1:(length(positionArray)-1)
                 position = positionArray(index);
                 nextPosition = positionArray(index+1);
                 % Get all velocities from the inputted data
                 obj.linearVelocityThighX(index) = obj.GetLinearVelocity(position.ThighComXPoint, nextPosition.ThighComXPoint, obj.captureRate);
                 obj.linearVelocityThighY(index) = obj.GetLinearVelocity(position.ThighComYPoint, nextPosition.ThighComYPoint, obj.captureRate);
                 
                 obj.linearVelocityShankX(index) = obj.GetLinearVelocity(position.ShankComXPoint, nextPosition.ShankComXPoint, obj.captureRate);
                 obj.linearVelocityShankY(index) = obj.GetLinearVelocity(position.ShankComYPoint, nextPosition.ShankComYPoint, obj.captureRate);
                 
                 obj.linearVelocityFootX(index) = obj.GetLinearVelocity(position.FootComXPoint, nextPosition.FootComXPoint, obj.captureRate);
                 obj.linearVelocityFootY(index) = obj.GetLinearVelocity(position.FootComYPoint, nextPosition.FootComYPoint, obj.captureRate);
            end
              
            [obj.linearVelocityEq_ThighX, obj.linearAccelThighX] = obj.GetAccelerationEquation(obj.linearVelocityThighX, timeForGaitCycle);
            [obj.linearVelocityEq_ThighY, obj.linearAccelThighY] = obj.GetAccelerationEquation(obj.linearVelocityThighY, timeForGaitCycle);
            [obj.linearVelocityEq_ShankX, obj.linearAccelShankX] = obj.GetAccelerationEquation(obj.linearVelocityShankX, timeForGaitCycle);
            [obj.linearVelocityEq_ShankY, obj.linearAccelShankY] = obj.GetAccelerationEquation(obj.linearVelocityShankY, timeForGaitCycle);
            [obj.linearVelocityEq_FootX, obj.linearAccelFootX] = obj.GetAccelerationEquation(obj.linearVelocityFootX, timeForGaitCycle);
            [obj.linearVelocityEq_FootY, obj.linearAccelFootY] = obj.GetAccelerationEquation(obj.linearVelocityFootY, timeForGaitCycle);
        
            [obj.linearAvgAccelThighX] = obj.GetAvgAcceleration(obj.linearVelocityThighX, obj.captureRate);
            [obj.linearAvgAccelThighY] = obj.GetAvgAcceleration(obj.linearVelocityThighY, obj.captureRate);
            [obj.linearAvgAccelShankX] = obj.GetAvgAcceleration(obj.linearVelocityShankX, obj.captureRate);
            [obj.linearAvgAccelShankY] = obj.GetAvgAcceleration(obj.linearVelocityShankY, obj.captureRate);
            [obj.linearAvgAccelFootX] = obj.GetAvgAcceleration(obj.linearVelocityFootX, obj.captureRate);
            [obj.linearAvgAccelFootY] = obj.GetAvgAcceleration(obj.linearVelocityFootY, obj.captureRate);
        end
        
        function velocity = GetLinearVelocity(~, value, nextValue, captureRate)
            
            % Relative Distance is the distance between the 2 vectors
            relativeDistance = nextValue - value;
            
            % Get velocity by dividing by the time between captures
            velocity = relativeDistance / captureRate;
        end
        
        function avgAcceleration = GetAvgAcceleration(~, velocityArray, captureRate)
            
            avgAcceleration = zeros(1,(length(velocityArray)-1));
            
            for index = 1:(length(velocityArray)-1)
                current = velocityArray(index);
                next = velocityArray(index+1);
                avgAcceleration(index) = ((next-current)/captureRate);
            end
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
        
        function PlotVelocityInterpolationCurves(obj)
            figure
            
            % Plot the thigh velocity for X and Y
            % Velocity X
            topLeft = subplot(3,2,1);
            thighVelocityX_XScale = 0:(length(obj.linearVelocityThighX) -1);
            xScaleTime = linspace(0, obj.timeForGaitCycle, (length(obj.linearVelocityThighX)));
            thighVelocityX_YScale = obj.linearVelocityThighX;
            
            plot(topLeft, xScaleTime, thighVelocityX_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(topLeft, obj.linearVelocityEq_ThighX, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(topLeft,'Thigh Linear Velocity X');
            
            % Velocity Y
            topRight = subplot(3,2,2);
            thighVelocityY_XScale = 0:(length(obj.linearVelocityThighY) -1);
            thighVelocityY_YScale = obj.linearVelocityThighY;
            
            plot(topRight, xScaleTime, thighVelocityY_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(topRight, obj.linearVelocityEq_ThighY, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(topRight,'Thigh Linear Velocity Y');
            
            % Plot the Shank velocity for X and Y
            % Velocity X
            middleLeft = subplot(3,2,3);
            shankVelocityX_XScale = 0:(length(obj.linearVelocityShankX) -1);
            shankVelocityX_YScale = obj.linearVelocityShankX;
            
            plot(middleLeft, xScaleTime, shankVelocityX_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(middleLeft, obj.linearVelocityEq_ShankX, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(middleLeft,'Shank Linear Velocity X');
            
            % Velocity Y
            middleRight = subplot(3,2,4);
            shankVelocityY_XScale = 0:(length(obj.linearVelocityShankY) -1);
            shankVelocityY_YScale = obj.linearVelocityShankY;
            
            plot(middleRight, xScaleTime, shankVelocityY_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(middleRight, obj.linearVelocityEq_ShankY, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(middleRight,'Shank Linear Velocity Y');
            
            % Plot the Foot velocity for X and Y
            % Velocity X
            bottomLeft = subplot(3,2,5);
            footVelocityX_XScale = 0:(length(obj.linearVelocityFootX) -1);
            footVelocityX_YScale = obj.linearVelocityFootX;
            
            plot(bottomLeft, xScaleTime, footVelocityX_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(bottomLeft, obj.linearVelocityEq_FootX, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(bottomLeft,'Foot Linear Velocity X');
            
            % Velocity Y
            middleLeft = subplot(3,2,6);
            footVelocityY_XScale = 0:(length(obj.linearVelocityFootY) -1);
            footVelocityY_YScale = obj.linearVelocityFootY;
            
            plot(middleLeft, xScaleTime, footVelocityY_YScale, 'ro', 'MarkerSize', 5);
            hold on
            fplot(middleLeft, obj.linearVelocityEq_FootY, [min(xScaleTime), max(xScaleTime)], 'b-', 'LineWidth', 2);
            title(middleLeft,'Foot Linear Velocity Y');
        end
        
        function PlotAccelerationCurves(obj)
            figure
            
            % Plot the thigh Acceleration for X and Y
            % Acceleration X
            topLeft = subplot(3,2,1);

            fplot(topLeft, obj.linearAccelThighX, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(topLeft,'Thigh Linear Acceleration X');
            
            % Acceleration Y
            topRight = subplot(3,2,2);

            fplot(topRight, obj.linearAccelThighY, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(topRight,'Thigh Linear Acceleration Y');
            
            % Plot the Shank Acceleration for X and Y
            % Acceleration X
            middleLeft = subplot(3,2,3);

            fplot(middleLeft, obj.linearAccelShankX, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(middleLeft,'Shank Linear Acceleration X');
            
            % Acceleration Y
            middleRight = subplot(3,2,4);

            fplot(middleRight, obj.linearAccelShankY, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(middleRight,'Shank Linear Acceleration Y');
            
             % Plot the foot Acceleration for X and Y
            % Acceleration X
            bottomLeft = subplot(3,2,5);

            fplot(bottomLeft, obj.linearAccelFootX, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(bottomLeft,'Foot Linear Acceleration X');
            
            % Acceleration Y
            bottomRight = subplot(3,2,6);

            fplot(bottomRight, obj.linearAccelFootY, [0, obj.timeForGaitCycle], 'b-', 'LineWidth', 2);
            title(bottomRight,'Foot Linear Acceleration Y');
        end
        
        function PlotAvgAccelerationCurves(obj)
            figure
            
            % Plot the thigh Acceleration for X and Y
            % Acceleration X
            xScale = 1:(length(obj.linearAvgAccelThighX));
            topLeft = subplot(3,2,1);

            plot(topLeft, xScale, obj.linearAvgAccelThighX, 'b-', 'LineWidth', 2);
            title(topLeft,'Thigh Linear Acceleration X');
            
            % Acceleration Y
            topRight = subplot(3,2,2);

            plot(topRight, xScale, obj.linearAvgAccelThighY, 'b-', 'LineWidth', 2);
            title(topRight,'Thigh Linear Acceleration Y');
            
            % Plot the Shank Acceleration for X and Y
            % Acceleration X
            middleLeft = subplot(3,2,3);

            plot(middleLeft, xScale, obj.linearAvgAccelShankX, 'b-', 'LineWidth', 2);
            title(middleLeft,'Shank Linear Acceleration X');
            
            % Acceleration Y
            middleRight = subplot(3,2,4);

            plot(middleRight, xScale, obj.linearAvgAccelShankY, 'b-', 'LineWidth', 2);
            title(middleRight,'Shank Linear Acceleration Y');
            
             % Plot the foot Acceleration for X and Y
            % Acceleration X
            bottomLeft = subplot(3,2,5);

            plot(bottomLeft, xScale, obj.linearAvgAccelFootX, 'b-', 'LineWidth', 2);
            title(bottomLeft,'Foot Linear Acceleration X');
            
            % Acceleration Y
            bottomRight = subplot(3,2,6);

            plot(bottomRight, xScale, obj.linearAvgAccelFootY, 'b-', 'LineWidth', 2);
            title(bottomRight,'Foot Linear Acceleration Y');
        end
    end
end