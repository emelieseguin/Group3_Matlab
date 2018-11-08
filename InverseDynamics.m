classdef InverseDynamics
    properties
       FAnkleX_Array
       FAnkleY_Array
       MAnkleZ_Array
       
       FKneeX_Array
       FKneeY_Array
       MKneeZ_Array
       
       FHipX_Array
       FHipY_Array
       MHipZ_Array
    end
    methods
        function obj = InverseDynamics(anthropometricModel, positionArray, linearAccel, ...
            angularAccel, patientForces, normCopData, timeForGaitCycle)
            global footSegmentWeight legSegmentWeight thighSegmentWeight;
            global footLength leftShankLength thighLength;
            
            ExamplePatientWeight = 80; % Weight in Kg
            xScaleTime = linspace(0, timeForGaitCycle, (length(positionArray)));
            
            obj.FAnkleX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FAnkleY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MAnkleZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Foot
                % Get Ground Reaction Forces
                Frx = (patientForces.LGRFX(i))*ExamplePatientWeight;
                Fry = (patientForces.LGRFY(i))*ExamplePatientWeight;
                
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
                
                % Summation of Forces
                FAnkleX = ((Mfoot)*AFootX) - Frx;
                FAnkleY = ((Mfoot)*AFootY) - Fry + Mfoot*9.81;
                
                % Summation of Moments
                MAnkleZ = (MomentInert_Foot*A_AngularFoot -Fry*(CopPositionX - ComXFoot) ...
                - Frx*(ComYFoot-0) + FAnkleY*(ComXFoot-AnklePos_X) ...
                + FAnkleX*(ComYFoot-AnklePos_Y));
                
                % Store the results in arrays
                obj.FAnkleX_Array(i)=FAnkleX;
                obj.FAnkleY_Array(i)= FAnkleY;
                obj.MAnkleZ_Array(i) = MAnkleZ;
            end
            
            % Do the inverse dynamics on the knee
            obj.FKneeX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FKneeY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MKneeZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Shank
                FAnkleX = (-1)*obj.FAnkleX_Array(i);
                FAnkleY = (-1)*obj.FAnkleY_Array(i);
                MomentAnkleZ = (-1)*obj.MAnkleZ_Array(i);
                MShank = anthropometricModel.weightMap(legSegmentWeight);
                
                AShankX = subs(linearAccel.linearAccelShankX, xScaleTime(i));
                AShankX = double(AShankX);
                AShankY = subs(linearAccel.linearAccelShankY, xScaleTime(i)); 
                AShankY = double(AShankY);
               
                A_AngularShank = subs(angularAccel.angularAccelShank, xScaleTime(i));
                A_AngularShank = double(A_AngularShank);
                
                ShankLength = anthropometricModel.dimensionMap(leftShankLength);
                MomentInert_Shank = ((0.528*ShankLength).^2)*MShank;
                ComXShank = positionArray(i).ShankComXPoint;
                ComYShank = positionArray(i).ShankComYPoint;
                AnklePos_X = positionArray(i).AnkleJointX;
                AnklePos_Y = positionArray(i).AnkleJointY;
                KneePos_X = positionArray(i).KneeJointX;
                KneePos_Y = positionArray(i).KneeJointY;
                
                % Summation of Forces
                FKneeX = MShank*AShankX - FAnkleX;
                FKneeY = MShank*AShankY - FAnkleY + MShank*9.81;
                
                % Summation of Moments
                MKneeZ = MomentInert_Shank*A_AngularShank + FKneeX*(KneePos_Y-ComYShank) ...
                - FKneeY*(KneePos_X-ComXShank) - FAnkleX*(ComYShank-AnklePos_Y) ...
                + FAnkleY*(ComXShank-AnklePos_X) - MomentAnkleZ;
            
                % Store the results in arrays
                obj.FKneeX_Array(i)=FKneeX;
                obj.FKneeY_Array(i)= FKneeY;
                obj.MKneeZ_Array(i) = MKneeZ;
            end
            
            % Do the inverse dynamics on the hip
            obj.FHipX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.FHipY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            obj.MHipZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(positionArray)
            
                % Do the Inverse Dynamics of the Shank
                FKneeX = (-1)*obj.FKneeX_Array(i);
                FKneeY = (-1)*obj.FKneeY_Array(i);
                MomentKneeZ = (-1)*obj.MKneeZ_Array(i);
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
                
                % Summation of Forces
                FHipX = MThigh*AThighX - FKneeX;
                FHipY = MThigh*AThighY - FKneeY + MThigh*9.81;
                
                % Summation of Moments
                MHipZ = MomentInert_Thigh*A_AngularThigh - MomentKneeZ ...
                    + FHipY*(ComXThigh-HipPos_X) + FHipX*(HipPos_Y-ComYThigh) ...
                    - FKneeY*(KneePos_X-ComXThigh) - FKneeX*(ComYThigh-KneePos_Y);
            
                % Store the results in arrays
                obj.FHipX_Array(i)=FHipX;
                obj.FHipY_Array(i)= FHipY;
                obj.MHipZ_Array(i) = MHipZ;
            end
        end
        
        % All graphs plotted with CW as positive
        function PlotMomentGraphs(obj)
            figure
            % Plot the Hip moment graph
            top = subplot(3,1,1);
            plot(top, 1:length(obj.MHipZ_Array), (-1)*obj.MHipZ_Array, 'LineWidth',2);
            hold on
            grid on
            title('Hip Moment vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(top, 'LineWidth',1)
            legend(top, 'Hip Moment')
            axis(top, [0 length(obj.MHipZ_Array)  (-1)*(max(obj.MHipZ_Array)+10) (-1)*(min(obj.MHipZ_Array)-10)])
            
            middle = subplot(3,1,2);
            % Plot the Knee moment graph
            plot(middle, 1:length(obj.MKneeZ_Array), (-1)*obj.MKneeZ_Array, 'LineWidth',2);
            hold on
            grid on
            title('Knee Moment vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(middle, 'LineWidth',1)
            legend(middle, 'Knee Moment')
            axis(middle, [0 length(obj.MKneeZ_Array) (-1)*(max(obj.MKneeZ_Array)+5) (-1)*(min(obj.MKneeZ_Array)-5)])
            
            bottom = subplot(3,1,3);
            % Plot the Ankle moment graph
            plot(bottom, 1:length(obj.MAnkleZ_Array), (-1)*obj.MAnkleZ_Array, 'LineWidth',2);
            hold on
            grid on
            title('Ankle Moment vs. Percent Gait Cycle');
            ylabel('Moment (N*m)')
            xlabel('Gait Cycle (%)') 
            set(bottom, 'LineWidth',1)
            legend(bottom, 'Ankle Moment')
            axis(bottom, [0 length(obj.MAnkleZ_Array) (-1)*(max(obj.MAnkleZ_Array)+10) (-1)*(min(obj.MAnkleZ_Array)-20)])
        end
    end
end
