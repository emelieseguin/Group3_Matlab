classdef InverseDynamicsWithExoskeleton
    properties
       FAnkleXExo_Array
       FAnkleYExo_Array
       MAnkleZExo_Array
       
       FKneeXExo_Array
       FKneeYExo_Array
       MKneeZExo_Array
       
       FHipXExo_Array
       FHipYExo_Array
       MHipZExo_Array
    end
    methods
        function obj = InverseDynamicsWithExoskeleton(anthropometricModel, positionArray, linearAccel, ...
            angularAccel, patientForces, normCopData, timeForGaitCycle, totalMassOfExoskelton, ...
            thighExoMass, shankExoMass, footExoMass)
            global footSegmentWeight legSegmentWeight thighSegmentWeight;
            global footLength leftShankLength thighLength;
            
            xScaleTime = linspace(0, timeForGaitCycle, (length(positionArray)));
            
            obj.FAnkleXExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FAnkleYExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MAnkleZExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Foot
                % Get Ground Reaction Forces
                Frx = (patientForces.LGRFX(i))*(anthropometricModel.weight + totalMassOfExoskelton);
                Fry = (patientForces.LGRFY(i))*(anthropometricModel.weight + totalMassOfExoskelton);
                
                % Only 65 COP positions given, so if not <65 it is 0
                if(i <= 65)
                    FootLength = anthropometricModel.dimensionMap(footLength);
                    CopPositionX = normCopData.NormalizedCopArray_FromHeel(i)*FootLength;
                else 
                    CopPositionX = 0;
                end
                
                Mfoot = anthropometricModel.weightMap(footSegmentWeight);
                
                AFootX = subs(linearAccel.linearAccelFootX, xScaleTime(i));
                AFootX = double(AFootX);
                AFootY = subs(linearAccel.linearAccelFootY, xScaleTime(i));
                AFootY = double(AFootY);
                
                A_AngularFoot = subs(angularAccel.angularAccelFoot, xScaleTime(i));
                A_AngularFoot = double(A_AngularFoot);
                
                MomentInert_Foot = ((0.690*FootLength).^2)*Mfoot;
                
                ComXFoot = positionArray(i).FootComXPoint;
                ComYFoot = positionArray(i).FootComYPoint;
                AnklePos_X = positionArray(i).AnkleJointX;
                AnklePos_Y = positionArray(i).AnkleJointY;
                %ComExoFootX = positionArray(i).FootExoComX; - since at same com
                %ComExoFootY = positionArray(i).FootExoComY;
                
                % Summation of Forces
                FAnkleX = ((Mfoot)*AFootX) - Frx;
                FAnkleY = ((Mfoot)*AFootY) - Fry + Mfoot*9.81 + footExoMass*9.81;
                
                % Summation of Moments
                MAnkleZ = (MomentInert_Foot*A_AngularFoot -Fry*(CopPositionX - ComXFoot) ...
                - Frx*(ComYFoot-0) + FAnkleY*(ComXFoot-AnklePos_X) ...
                + FAnkleX*(ComYFoot-AnklePos_Y));
                
                % Store the results in arrays
                obj.FAnkleXExo_Array(i)=FAnkleX;
                obj.FAnkleYExo_Array(i)= FAnkleY;
                obj.MAnkleZExo_Array(i) = MAnkleZ;
            end
            
            % Do the inverse dynamics on the knee
            obj.FKneeXExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FKneeYExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MKneeZExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            %% Do the thigh and shank once we know where it is
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Shank
                FAnkleX = (-1)*obj.FAnkleXExo_Array(i);
                FAnkleY = (-1)*obj.FAnkleYExo_Array(i);
                MomentAnkleZ = (-1)*obj.MAnkleZExo_Array(i);
                MShank = anthropometricModel.weightMap(legSegmentWeight);
                
                AShankX = subs(linearAccel.linearAccelShankX, xScaleTime(i));
                AShankX = double(AShankX);
                AShankY = subs(linearAccel.linearAccelShankY, xScaleTime(i)); 
                AShankY = double(AShankY);
               
                A_AngularShank = subs(angularAccel.angularAccelShank, xScaleTime(i));
                A_AngularShank = double(A_AngularShank);
                
                % Get the positions
                ShankLength = anthropometricModel.dimensionMap(leftShankLength);
                MomentInert_Shank = ((0.528*ShankLength).^2)*MShank;
                ComXShank = positionArray(i).ShankComXPoint;
                ComYShank = positionArray(i).ShankComYPoint;
                AnklePos_X = positionArray(i).AnkleJointX;
                AnklePos_Y = positionArray(i).AnkleJointY;
                KneePos_X = positionArray(i).KneeJointX;
                KneePos_Y = positionArray(i).KneeJointY;
                ComExoShankX = positionArray(i).ShankExoComX;
                %ComExoShankY = positionArray(i).ShankExoComY;
                
                % Summation of Forces
                FKneeX = MShank*AShankX - FAnkleX;
                FKneeY = MShank*AShankY - FAnkleY + MShank*9.81 + shankExoMass*9.81;
                
                % Summation of Moments
                isExoAboveTheComShank = 1; % 1 is above, -1 is below
                MKneeZ = MomentInert_Shank*A_AngularShank + FKneeX*(KneePos_Y-ComYShank) ...
                - FKneeY*(KneePos_X-ComXShank) - FAnkleX*(ComYShank-AnklePos_Y) ...
                + FAnkleY*(ComXShank-AnklePos_X) - MomentAnkleZ - (isExoAboveTheComShank)*(shankExoMass*9.81)*(ComXShank-ComExoShankX);
            
                % Store the results in arrays
                obj.FKneeXExo_Array(i)=FKneeX;
                obj.FKneeYExo_Array(i)= FKneeY;
                obj.MKneeZExo_Array(i) = MKneeZ;
            end
            
            % Do the inverse dynamics on the hip
            obj.FHipXExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FHipYExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MHipZExo_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Shank
                FKneeX = (-1)*obj.FKneeXExo_Array(i);
                FKneeY = (-1)*obj.FKneeYExo_Array(i);
                MomentKneeZ = (-1)*obj.MKneeZExo_Array(i);
                MThigh = anthropometricModel.weightMap(thighSegmentWeight);
                
                AThighX = subs(linearAccel.linearAccelThighX, xScaleTime(i));
                AThighX = double(AThighX);
                AThighY = subs(linearAccel.linearAccelThighY, xScaleTime(i)); 
                AThighY = double(AThighY);
                
                A_AngularThigh = subs(angularAccel.angularAccelThigh, xScaleTime(i));
                A_AngularThigh = double(A_AngularThigh);
                
                ThighLength = anthropometricModel.dimensionMap(thighLength);
                MomentInert_Thigh = ((0.540*ThighLength).^2)*MThigh;
                ComXThigh = positionArray(i).ThighComXPoint;
                ComYThigh = positionArray(i).ThighComYPoint;
                KneePos_X = positionArray(i).KneeJointX;
                KneePos_Y = positionArray(i).KneeJointY;
                HipPos_X = 0;
                HipPos_Y = 0;
                ComExoThighX = positionArray(i).ThighExoComX;
                %ComExoShankY = positionArray(i).ShankExoComY;
                
                
                % Summation of Forces
                FHipX = MThigh*AThighX - FKneeX;
                FHipY = MThigh*AThighY - FKneeY + MThigh*9.81 + thighExoMass*9.81;
                
                % Summation of Moments
                isExoAboveTheComThigh = 1;
                MHipZ = MomentInert_Thigh*A_AngularThigh - MomentKneeZ ...
                    + FHipY*(ComXThigh-HipPos_X) + FHipX*(HipPos_Y-ComYThigh) ...
                    - FKneeY*(KneePos_X-ComXThigh) - FKneeX*(ComYThigh-KneePos_Y) ...
                    - (isExoAboveTheComThigh)*(thighExoMass*9.81)*(ComXThigh-ComExoThighX);

                % Store the results in arrays
                obj.FHipXExo_Array(i)=FHipX;
                obj.FHipYExo_Array(i)= FHipY;
                obj.MHipZExo_Array(i) = MHipZ;
            end
        end
        
        % All graphs plotted with CW as positive -- of the inverse with
        % Exoskelton
        function PlotMomentGraphs(obj)
            figure
            % Plot the Hip moment graph
            top = subplot(3,1,1);
            plot(top, 1:length(obj.MHipZExo_Array), (-1)*obj.MHipZExo_Array, 'LineWidth',2);
            hold on
            grid on
            title('Hip Moment with Exo vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(top, 'LineWidth',1)
            legend(top, 'Hip Moment')
            axis(top, [0 length(obj.MHipZExo_Array)  (-1)*(max(obj.MHipZExo_Array)+10) (-1)*(min(obj.MHipZExo_Array)-10)])
            
            middle = subplot(3,1,2);
            % Plot the Knee moment graph
            plot(middle, 1:length(obj.MKneeZExo_Array), (-1)*obj.MKneeZExo_Array, 'LineWidth',2);
            hold on
            grid on
            title('Knee Moment with Exo vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(middle, 'LineWidth',1)
            legend(middle, 'Knee Moment')
            axis(middle, [0 length(obj.MKneeZExo_Array) (-1)*(max(obj.MKneeZExo_Array)+5) (-1)*(min(obj.MKneeZExo_Array)-5)])
            
            bottom = subplot(3,1,3);
            % Plot the Ankle moment graph
            plot(bottom, 1:length(obj.MAnkleZExo_Array), (-1)*obj.MAnkleZExo_Array, 'LineWidth',2);
            hold on
            grid on
            title('Ankle Moment with Exo vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(bottom, 'LineWidth',1)
            legend(bottom, 'Ankle Moment')
            axis(bottom, [0 length(obj.MAnkleZExo_Array) (-1)*(max(obj.MAnkleZExo_Array)+10) (-1)*(min(obj.MAnkleZExo_Array)-20)])
        end
    end
end