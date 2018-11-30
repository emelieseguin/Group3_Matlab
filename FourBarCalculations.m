classdef FourBarCalculations
    properties
        wL2
        wL4
        alphaL2
        alphaL4
    end
    methods
        function obj = FourBarCalculations(fourBarPosition, angularVelocityThigh, ...
            angularAccelThigh, angularVelocityShank, angularAccelShank)
        
            %% Declare variables
            % Lengths of the linkages
            L1 = fourBarPosition.L1;
            L2 = fourBarPosition.L2;
            L3 = fourBarPosition.L3;
            L4 = fourBarPosition.L4;
        
            % Define default angles
            theta1 = deg2rad(fourBarPosition.theta1);
            theta2 = deg2rad(fourBarPosition.theta2);
            thetaL3 = deg2rad(fourBarPosition.thetaL3);
            thetaL1 = deg2rad(fourBarPosition.thetaL1);
            
            % Known angular velocities - positive in the CCW direction
            wL1 =  angularVelocityShank; % shank
            wL3 =  angularVelocityThigh;  % thigh
            % Known angular accelerations
            alphaL1 = angularAccelShank; % shank
            alphaL3 = angularAccelThigh; % thigh
            
            %% Find the angular velocity
            % Create an inline function to define the 4Bar equations
            function F = velocity(omega)
                F(1) = -L2*omega(1)*sin(theta1) - L3*wL3*sin(thetaL3) - L4*omega(2)*sin(theta2) - L1*wL1*sin(thetaL1);
                F(2) = L2*omega(1)*cos(theta1) + L3*wL3*cos(thetaL3) + L4*omega(2)*cos(theta2) + L1*wL1*cos(thetaL1);
            end

            options = optimset('Display','off');
            fun = @velocity;
            omega0 = [deg2rad(fourBarPosition.solvedIterationConditions), ...
                deg2rad(fourBarPosition.solvedIterationConditions)];
            omega = fsolve(fun, omega0, options);
            
            w1 = 0;
            w2 = 0;
            
            if(length(omega)==2)
                w1 = omega(1);
                w2 = omega(2);
            else 
                disp('No solution found');
            end
            
            obj.wL2 = w1;
            obj.wL4 = w2;
            
            % Test check to make sure the values approximately equal 0
            checkAngVelEqn1 = -L2*omega(1)*sin(theta1) - L3*wL3*sin(thetaL3) - L4*omega(2)*sin(theta2) - L1*wL1*sin(thetaL1);
            checkAngVelEqn2 = L2*omega(1)*cos(theta1) + L3*wL3*cos(thetaL3) + L4*omega(2)*cos(theta2) + L1*wL1*cos(thetaL1);
              
            %% Find the angular acceleration
            function F = acceleration(alpha)
                F(1) = - L2*alpha(1)*sin(theta1) - L2*(w1.^2)*cos(theta1) - L3*alphaL3*sin(thetaL3) - L3*(wL3.^2)*cos(thetaL3) - L4*alpha(2)*sin(theta2) - L4*(w2.^2)*cos(theta2) - L1*(alphaL1)*sin(thetaL1) - L1*(wL1.^2)*cos(thetaL1);
                F(2) = L2*alpha(1)*cos(theta1) - L2*(w1.^2)*sin(theta1) + L3*alphaL3*cos(thetaL3) - L3*(wL3.^2)*sin(thetaL3) + L4*alpha(2)*cos(theta2) - L4*(w2.^2)*sin(theta2) + L1*(alphaL1)*cos(thetaL1) - L1*(wL1.^2)*sin(thetaL1);
            end
            
            options = optimset('Display','off');
            fun = @acceleration;
            alpha0 = [deg2rad(fourBarPosition.solvedIterationConditions), ...
                deg2rad(fourBarPosition.solvedIterationConditions)];
            alpha = fsolve(fun, alpha0, options);
            
            alpha1 = 0;
            alpha2 = 0;
            
            if(length(alpha)==2)
                alpha1 = alpha(1);
                alpha2 = alpha(2);
            else 
                disp('No solution found');
            end
            
            obj.alphaL2 = alpha1;
            obj.alphaL4 = alpha2;
            
            % Test check to make sure the values approximately equal 0
            checkAngAccelEqn1 = - L2*alpha(1)*sin(theta1) - L2*(w1^2)*cos(theta1) - L3*alphaL3*sin(thetaL3) - L3*(wL3^2)*cos(thetaL3) - L4*alpha(2)*sin(theta2) - L4*(w2^2)*cos(theta2) - L1*(alphaL1)*sin(thetaL1) - L1*(wL1^2)*cos(thetaL1);
            checkAngAccelEqn2 = L2*alpha(1)*cos(theta1) - L2*(w1^2)*sin(theta1) + L3*alphaL3*cos(thetaL3) - L3*(wL3^2)*sin(thetaL3) + L4*alpha(2)*cos(theta2) - L4*(w2^2)*sin(theta2) + L1*(alphaL1)*cos(thetaL1) - L1*(wL1^2)*sin(thetaL1);
        end
    end    
end