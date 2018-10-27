classdef InverseDynamics
    properties
       
    end
    methods
        function obj = InverseDynamics(anthropometricModel, positionArray, linearAccel, ...
            angularAccel, patientForces, normCopData)
            global footSegmentWeight legSegmentWeight thighSegmentWeight;
            global footLength leftShankLength thighLength;
            
            
            % Completely Use winters data in here
            
            
            
            
            
            FAnkleX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            FAnkleY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            MAnkleZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(normCopData.NormalizedCopArray_FromHeel)
            
                % Do the Inverse Dynamics of the Foot
                % Get Ground Reaction Forces
                Frx = patientForces.LGRFX(i);
                Fry = patientForces.LGRFY(i);
                Mfoot = anthropometricModel.weightMap(footSegmentWeight);
                
                AFootX = subs(linearAccel.linearAccelFootX, i);
                AFootX = double(AFootX);
                AFootY = subs(linearAccel.linearAccelFootY, i); 
                AFootY = double(AFootY);
                
                A_AngularFoot = subs(angularAccel.angularAccelFoot, i);
                A_AngularFoot = double(A_AngularFoot);
                
                FootLength = anthropometricModel.dimensionMap(footLength);
                MomentInert_Foot = ((0.690*FootLength).^2)*Mfoot;
                CopPositionX = normCopData.NormalizedCopArray_FromHeel(i)*FootLength;
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
                FAnkleX_Array(i)=FAnkleX;
                FAnkleY_Array(i)= FAnkleY;
                MAnkleZ_Array(i) = MAnkleZ;
            end
            
            % Do the inverse dynamics on the knee
            FKneeX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            FKneeY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            MKneeZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(normCopData.NormalizedCopArray_FromHeel)
            
                % Do the Inverse Dynamics of the Shank
                FAnkleX = FAnkleX_Array(i);
                FAnkleY = FAnkleY_Array(i);
                MomentAnkleZ = MAnkleZ_Array(i);
                MShank = anthropometricModel.weightMap(legSegmentWeight);
                
                AShankX = subs(linearAccel.linearAccelShankX, i);
                AShankX = double(AShankX);
                AShankY = subs(linearAccel.linearAccelShankY, i); 
                AShankY = double(AShankY);
                
                A_AngularShank = subs(angularAccel.angularAccelShank, i);
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
                component1 = MomentInert_Shank*A_AngularShank;
                component2 = FKneeX*(KneePos_Y-ComYShank);
                component3 = FKneeY*(ComXShank-KneePos_X);
                component4 = (-1)*FAnkleX*(ComYShank-AnklePos_Y);
                component5 = (-1)*FAnkleY*(AnklePos_X-ComXShank);
                component6 = (-1)*MomentAnkleZ;
                MKneeZ = MomentInert_Shank*A_AngularShank + FKneeX*(KneePos_Y-ComYShank) ...
                + FKneeY*(ComXShank-KneePos_X) - FAnkleX*(ComYShank-AnklePos_Y) ...
                - FAnkleY*(AnklePos_X-ComXShank) - MomentAnkleZ;
            
                % Store the results in arrays
                FKneeX_Array(i)=FKneeX;
                FKneeY_Array(i)= FKneeY;
                MKneeZ_Array(i) = MKneeZ;
            end
            
            % Do the inverse dynamics on the hip
            FHipX_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            FHipY_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            MHipZ_Array = zeros(1, length(normCopData.NormalizedCopArray_FromHeel));
            
            % For all frames with ground reaction force
            for i=1:length(normCopData.NormalizedCopArray_FromHeel)
            
                % Do the Inverse Dynamics of the Shank
                FKneeX = FKneeX_Array(i);
                FKneeY = FKneeY_Array(i);
                MomentKneeZ = MKneeZ_Array(i);
                MThigh = anthropometricModel.weightMap(thighSegmentWeight);
                
                AThighX = subs(linearAccel.linearAccelThighX, i);
                AThighX = double(AThighX);
                AThighY = subs(linearAccel.linearAccelThighY, i); 
                AThighY = double(AShankY);
                
                A_AngularThigh = subs(angularAccel.angularAccelThigh, i);
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
                FHipX_Array(i)=FHipX;
                FHipY_Array(i)= FHipY;
                MHipZ_Array(i) = MHipZ;
            end
            
            % Graph the ankle moment positive CW
            plot(1:65, (-1)*MAnkleZ_Array);
            plot(1:65, (-1)*MKneeZ_Array);
            plot(1:65, (-1)*MHipZ_Array);
        end
    end
end
