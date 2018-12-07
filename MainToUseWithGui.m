classdef MainToUseWithGui
    properties
        %% Properties used for 
        gaitPositionArray  % may need to put ankle angle in here too
        patientAngles
        
        %% Basic Moments
        basicInverseDynamics
        
        %% 4Bar 
        kneePointXArray
        kneePointYArray
        intersectPointXArray
        intersectPointYArray
        fourBarPositionArray
        
        %% Dorsiflexion Spring
        dorsiSpringAndCableLengthArray
        dorsiSpringAndCablePosition
        dorsiSpringLengthArray
        
        %% Plantarflexion Spring
        plantarSpringAndCableLengthArray
        plantarSpringAndCablePosition
        plantarSpringLengthArray
        
        %% Exoskeleton Moments
        exoInverseDynamics
        overallExoHipMoment
        overallExoKneeMoment
        overallExoAnkleMoment
        
        % Springs
        hipContributedMoments
        dorsiSpringContributedMoments
        plantarSpringContributedMoments
        
        % Cams
        dorsiTorsionContributedMoments
        plantarTorsionContributedMoments
    end
    methods
        function main = MainToUseWithGui(personHeight, personMass)
            global thighLength rightShankLength;
            global logFilePath;
            logFilePath = 'C:\MCG4322B\Group3\Log\group3_LOG.txt';
            %% Initialize databases to use throughout the code
            SetAnthropometricNames(); % Run this to initialize all global naming variables

            % Build the anthropomtric model
            model = AnthropometricModel(personHeight, personMass);

            patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
            patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
            patient29CopData_Left = 'Patient29_ForcePlateData_LeftFoot.csv';
            patient29FootLengthInMm = 295;  % Approximated foot length
            timeForGaitCycle = 1.48478;

            % Create objects to store the gait information (angles, forces) of patient 29
            patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
            patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
            main.patientAngles = patient29Angles;
            %PlotPatientGaitAngles(patient29Angles);

            %% Create arrays over the gait cycle
            positionArray = [];
            fourBarArray = [];
            kneePointXArray = zeros(1,101);
            kneePointYArray = zeros(1,101);
            intersectPointXArray = zeros(1,101);
            intersectPointYArray = zeros(1,101);
            plantarFlexionArray = [];
            plantarSpringAndCableLengthArray = [];
            dorsiFlexionArray = [];
            dorsiSpringAndCableLengthArray = [];
            distanceChangeOfTopLink = zeros(1,101);
            distanceChangeOfBottomLink = zeros(1,101);
            topLinkXMovement = zeros(1,101);
            topLinkYMovement = zeros(1,101);
            for item = 1:(length(patient29Angles.LFootAngleZ))

                % Get the angles from the object
                foot = patient29Angles.LFootAngleZ(item);
                knee = patient29Angles.LKneeAngleZ(item);
                hip = patient29Angles.LHipAngleZ(item);
                ankle = patient29Angles.LAnkleAngleZ(item);

                % Create the position of the leg, add it to the array
                position = GaitLegPosition(model, foot, knee, hip);
                positionArray = [positionArray position];
                
                kneePointXArray(item) = position.KneeJointX;
                kneePointYArray(item) = position.KneeJointY;
                
                % Create the position of the 4bar, with respect to the leg
                linkagePosition = FourBarLinkageMathDefined_FromGait(personHeight, position.KneeJointX, position.KneeJointY, ...
                    model.dimensionMap(thighLength), model.dimensionMap(rightShankLength), hip, knee, position.ThighLine, position.ShankLine);
                fourBarArray = [fourBarArray linkagePosition];

                intersectPointXArray(item) = linkagePosition.IntersectPointX;
                intersectPointYArray(item) = linkagePosition.IntersectPointY;

                plantarPosition = PlantarFlexionSpringPosition(personHeight, position, hip, knee, foot);
                
                plantarFlexionArray = [plantarFlexionArray plantarPosition];
                plantarSpringAndCableLengthArray = [plantarSpringAndCableLengthArray plantarPosition.Length];

                distanceChangeOfTopLink(item) = linkagePosition.TopBarLinkageDistanceChange;
                distanceChangeOfBottomLink(item) = linkagePosition.BottomBarLinkageDistanceChange;
                topLinkXMovement(item) = linkagePosition.TopBarMovementX;
                topLinkYMovement(item) = linkagePosition.TopBarMovementY;

                %% Build dorsispring arrays
                dorsiPosition = DorsiFlexionSpringPosition(position, personHeight, model.dimensionMap,...
                    hip, knee, ankle, foot);
                dorsiFlexionArray = [dorsiFlexionArray dorsiPosition];
                dorsiSpringAndCableLengthArray = [dorsiSpringAndCableLengthArray dorsiPosition.Length];
            end
            
            % Store the gait positioning array on Main
            main.gaitPositionArray = positionArray; 

            %% Spring Calcs
            % Hip torsional spring
            hipTorsionSpring = HipTorsionSpring(personHeight, patient29Angles.LHipAngleZ);

            %% Extension spring for Plantarflexion
            plantarSpring = PlantarSpringCalcs(personHeight, plantarSpringAndCableLengthArray);
            plantarSpringLengthArray = [];
            for i=1:length(plantarFlexionArray)
                planatarPosition = plantarFlexionArray(i);
                springLength = planatarPosition.Length - plantarSpring.extensionCableLength;
                if(springLength < plantarSpring.totalLengthUnstrechedSpring) % Assume cam will pick up the slack
                    springLength = plantarSpring.totalLengthUnstrechedSpring;
                end
                plantarSpringLengthArray = [plantarSpringLengthArray springLength];
            end
            main.plantarSpringAndCableLengthArray = plantarSpringAndCableLengthArray;
            main.plantarSpringLengthArray = plantarSpringLengthArray;
            main.plantarSpringAndCablePosition = plantarFlexionArray;

            %% Torsional spring for the Platarflexion Cam
            diamPlantarCable = 0.005;
            densityPlantarCable =  7850;
            mPlantarCable = (pi*(diamPlantarCable.^2)/4)*plantarSpring.extensionCableLength*densityPlantarCable;
            mPlantarPull = plantarSpring.weightExtensionSpring + mPlantarCable;
            plantarTorsionSpring = PlantarTorsionSpring(personHeight, mPlantarPull, plantarSpringAndCableLengthArray);          

            %% Extension spring for Dorsiflexion
            dorsiSpring = DorsiSpringCalcs(personHeight, dorsiSpringAndCableLengthArray);

            dorsiSpringLengthArray = [];
            for i=1:length(dorsiFlexionArray)
                dorsiPosition = dorsiFlexionArray(i);
                springLength = dorsiPosition.Length  - dorsiSpring.extensionCableLength;
                if(springLength < dorsiSpring.totalLengthUnstrechedSpring) % Assume cam will pick up the slack
                    springLength = dorsiSpring.totalLengthUnstrechedSpring;
                end
                dorsiSpringLengthArray = [dorsiSpringLengthArray springLength];
            end
            main.dorsiSpringAndCableLengthArray = dorsiSpringAndCableLengthArray;
            main.dorsiSpringLengthArray = dorsiSpringLengthArray;
            main.dorsiSpringAndCablePosition = dorsiFlexionArray;
            
            %% Torsional spring for the Dorsiflexion Cam
            diamDorsiCable = 0.005;
            densityDorsiCable =  7850;
            mDorsiCable = (pi*(diamDorsiCable.^2)/4)*dorsiSpring.extensionCableLength*densityDorsiCable;
            mDorsiPull = dorsiSpring.weightExtensionSpring + mDorsiCable;
            dorsiTorsionSpring = DorsiTorsionSpring(personHeight, mDorsiPull, dorsiSpringAndCableLengthArray);

            %% Store 4bar variables into properties
            main.kneePointXArray = kneePointXArray;
            main.kneePointYArray = kneePointYArray;
            main.intersectPointXArray = intersectPointXArray;
            main.intersectPointYArray = intersectPointYArray;
            main.fourBarPositionArray = fourBarArray;

            %% Create the Hip Shaft
            % Calculates shaft dimensions based on anthropometric model
            hipShaft = Shaft_Length_Anthropometric(personHeight, hipTorsionSpring.shaftDiameter, ...
            hipTorsionSpring.wireDiameterSpring, hipTorsionSpring.lengthSupportLeg, hipTorsionSpring.lengthHipSpring);

            
            %% Print the value for all of the components
            finalParts = FinalPartsCombined(personHeight, hipShaft, dorsiPosition, plantarFlexionArray(1), ...
            plantarTorsionSpring, dorsiTorsionSpring, plantarSpring, dorsiSpring);
            finalParts = finalParts.SetAllMassesOfComponents(); 

            %% Calc the linear and angular accelerations 
            patient29_HeelStrike = 0;
            patient29_ToeOff = patient29Forces.ToeOffPercentage;
            linearAccel = LinearAcceleration(positionArray, timeForGaitCycle);
            angularAccel = AngularAcceleration(positionArray, timeForGaitCycle);
            normCopData = NormalizeCopData(patient29CopData_Left, ...
                patient29_HeelStrike, patient29_ToeOff, patient29FootLengthInMm);        

            %% Inverse Dynamics without the exoskeleton weight
            inverseDynamics = InverseDynamics(model, positionArray, linearAccel, ...
                angularAccel, patient29Forces, normCopData, timeForGaitCycle);    
            main.basicInverseDynamics = inverseDynamics;

            %% Inverse Dynamics redone with the exoskeleton weight
            % Get the approx total weight acting on each of the components
             totalMassOfExoskelton = finalParts.totalMassOfExoskeleton; % in kg
             thighExoMass = finalParts.thighExoMass + hipTorsionSpring.weightHipTorsionSpring; % in kg
             shankExoMass = finalParts.shankExoMass + plantarSpring.weightExtensionSpring + ...
                 dorsiSpring.weightExtensionSpring + plantarTorsionSpring.weightPlantarTorsionSpring + ...
                 dorsiTorsionSpring.weightDorsiTorsionSpring + mPlantarCable + mDorsiCable;
             footExoMass = finalParts.footExoMass;
             
             inverseDynamicsExo = InverseDynamicsWithExoskeleton(model, positionArray, linearAccel, ...
                 angularAccel, patient29Forces, normCopData, timeForGaitCycle, totalMassOfExoskelton, ...
                 thighExoMass, shankExoMass, footExoMass);             
             
            %% Moment Contribution from exoskeleton throughout Gait
             hipContributedMoments = zeros(1, length(positionArray));
             dorsiSpringContributedMoments = zeros(1, length(positionArray));
             plantarSpringContributedMoments = zeros(1, length(positionArray));
 
             dorsiTorsionContributedMoments = zeros(1, length(positionArray));
             plantarTorsionContributedMoments = zeros(1, length(positionArray));
 
             for i=(1:(length(positionArray)))
                 % Hip Torsion Spring Moment
                 momentAdded = hipTorsionSpring.GetMomentContribution(positionArray(i).HipAngleZ, i);
                 hipContributedMoments(i) = momentAdded;
  
                 % Find the acting Dorsiflexion Spring Moment
                 [maxDorsiLength, maxValueIndex] = max(dorsiSpringAndCableLengthArray);
                 dorsiSpringContributedMoments(i) = dorsiSpring.GetMomentContribution(dorsiSpringAndCableLengthArray(i), ...
                  dorsiFlexionArray(i), maxDorsiLength, maxValueIndex, i);
 
                 % Find the acting Plantar Spring Moment
                 [maxPlantarLength, maxValueIndex] = max(plantarSpringAndCableLengthArray);
                 plantarSpringContributedMoments(i) = plantarSpring.GetMomentContribution(plantarSpringAndCableLengthArray(i), ...
                     plantarFlexionArray(i), maxPlantarLength, maxValueIndex, i);
 
                 % Cam contributed to gait moments
                 dorsiTorsionContributedMoments(i) = dorsiTorsionSpring.GetMomentContribution(dorsiFlexionArray(i));
                 plantarTorsionContributedMoments(i) = plantarTorsionSpring.GetMomentContribution(plantarFlexionArray(i));
             end
             
            % Store the arrays for joint moments with the exoskeleton acting 
            main.exoInverseDynamics = inverseDynamicsExo;
            main.overallExoHipMoment = (-1)*inverseDynamicsExo.MHipZExo_Array + hipContributedMoments;
            main.overallExoKneeMoment = (-1)*inverseDynamicsExo.MKneeZExo_Array;
            main.overallExoAnkleMoment = (-1)*inverseDynamicsExo.MAnkleZExo_Array + dorsiSpringContributedMoments + plantarSpringContributedMoments + dorsiTorsionContributedMoments + plantarTorsionContributedMoments;
            
            % Store the contributed moments from the springs
            main.hipContributedMoments = hipContributedMoments;
            main.dorsiSpringContributedMoments = dorsiSpringContributedMoments;
            main.plantarSpringContributedMoments = plantarSpringContributedMoments;

            % Store the contributed moments from the cams
            main.dorsiTorsionContributedMoments = dorsiTorsionContributedMoments;
            main.plantarTorsionContributedMoments = plantarTorsionContributedMoments;

            %% Calculate the Moments on the Cams themselves from picking up slack throughout Gait
             dorsiTorsionCamMoments = zeros(1, length(positionArray));
             plantarTorsionCamMoments = zeros(1, length(positionArray));
             for i=(1:(length(positionArray)))
                 % Find the cable lengths
                 if(i==1) % Start 1, Previous 101
                     currentDorsiSpringLength = dorsiSpringAndCableLengthArray(i);
                     previousDorsiSpringLength = dorsiSpringAndCableLengthArray(length(positionArray));
 
                     currentPlantarSpringLength = plantarSpringAndCableLengthArray(i);%plantarSpringLengthArray(i);
                     previousPlantarSpringLength = plantarSpringAndCableLengthArray(length(positionArray));%plantarSpringLengthArray(length(positionArray));
                 else % Start i, Previous i - 1
                     currentDorsiSpringLength = dorsiSpringAndCableLengthArray(i);
                     previousDorsiSpringLength = dorsiSpringAndCableLengthArray(i-1);
 
                     currentPlantarSpringLength = plantarSpringAndCableLengthArray(i);%plantarSpringLengthArray(i);
                     previousPlantarSpringLength = plantarSpringAndCableLengthArray(i-1);%plantarSpringLengthArray(i-1);
                 end
 
                 % Dorsitorsion spring
                 dorsiTorsionCamMoments(i) = dorsiTorsionSpring.GetMomentOnCam(currentDorsiSpringLength, previousDorsiSpringLength, ...
                     dorsiSpring.extensionCableLength, dorsiSpring.lengthUnstrechedSpring, dorsiSpring.R1, i);
 
                 % Plantartorsion Spring
                 plantarTorsionCamMoments(i) = plantarTorsionSpring.GetMomentOnCam(currentPlantarSpringLength, previousPlantarSpringLength, ...
                     plantarSpring.extensionCableLength, plantarSpring.lengthUnstrechedSpring, plantarSpring.R1, plantarSpringLengthArray(1), i);
             end
             
            %% Calculate the Shear Force Bending Moments and Safety Factor on the Shafts
            % Build the shear force bending moment diagrams with the correct forces
            warning('off'); % Suppress warning about nested global variables 
            
            % Need weight from below from final Parts
            % Calc Fy2 here
            % Hip spring from the actual mass
            g = 9.81; % N/kg
            MassOfComponentsOfAttachedExoLeg = finalParts.mLegComponents + plantarSpring.weightExtensionSpring + ...
                 dorsiSpring.weightExtensionSpring + plantarTorsionSpring.weightPlantarTorsionSpring + ...
                 dorsiTorsionSpring.weightDorsiTorsionSpring + mPlantarCable + mDorsiCable;
            Fy2 = (hipShaft.mRetainingRing1*g) + (hipShaft.mShaftKeyHip*g) + ...
                (hipTorsionSpring.weightHipTorsionSpring*g) + (hipShaft.weightShaft*g) + ...
                (MassOfComponentsOfAttachedExoLeg*g) + (hipShaft.mRetainingRing2*g);
            
            [ShearF, BendM] = ShearForceBendingMoment('Prob 200', ...
                        [hipShaft.zShaftLength,hipShaft.supportDist1], ...
                        {'CF',((-1)*hipShaft.mRetainingRing1*g),hipShaft.retainingRingDist1}, ...
                        {'CF',Fy2,hipShaft.supportDist1}, ...
                        {'CF',((-1)*hipShaft.mShaftKeyHip*g),hipShaft.keyDist}, ...
                        {'CF',((-1)*hipTorsionSpring.weightHipTorsionSpring*g),hipShaft.springDist}, ...
                        {'CF',((-1)*hipShaft.weightShaft*g),hipShaft.comOfShaftDist}, ...
                        {'CF',((-1)*MassOfComponentsOfAttachedExoLeg*g),hipShaft.exoLegDist}, ...
                        {'CF',((-1)*hipShaft.mRetainingRing2*g),hipShaft.retainingRingDist2});
                    
                  
            %disp(['Max Shear Force: ', num2str(max(ShearF)), 'N,   Min Shear Force: ',  num2str(min(ShearF)), 'N']);
            %disp(['Max Bending Moment Force: ', num2str(max(BendM)), 'N*m,   Min Bending Moment Force: ',  num2str(min(BendM)), 'N*m']);
            warning('on');
            
            % Shaft shoulder Analysis
            ShoulderCalcs(personHeight, main.GetAbsMaxValueFromArray(BendM), hipTorsionSpring.maxTorsionFromSpring,...
                hipTorsionSpring.shaftDiameter, hipShaft);
            
            %% Others Calcs - Bolts, Bearings
            HipShaftBearingCalcs(Fy2, max(angularAccel.angularVelocityThigh), personHeight);
            %HipJointBearingCalcs(reactionForceFromSheldon, angularAccel.angularVelocityThigh, patientHeight);
            %DorsiflexionCamBearingCalcs(reactionForceFromSheldon, patientHeight);
            %PlantarflexionCamBearingCalcs(reactionForceFromSheldon, patientHeight, timeForGaitCycle);
            
            BoltCalcs(finalParts.hipBoltsLeftMass, finalParts.hipBoltsRightMass, ...
                finalParts.thighBoltsLeftMass, finalParts.thighBoltsLeftMass, ...
                finalParts.shankBoltsLeftMass, finalParts.shankBoltsLeftMass); 
            
%% ---------------- Additional plotting and calculations not stored within GUI --------------------------------------------
            %% Plotting Graphs for Spring Length - wrt to height
            % Plot the plantarflexion and dorsiflexion spring
            %main.PlotDorsiSpringLength(dorsiSpringAndCableLengthArray);
            %main.PlotPlantarSpringLength(plantarSpringAndCableLengthArray);

            % Plot the shank spring
            % main.PlotShankSpringLength(springLengthArray);	
            
             %% Plotting the 4Bar 
            % Plot the Intersection of the 4 bar linkage with respect to the knee joint position
            % main.Plot4BarLinkageWRTKneeJoint(kneePointXArray, kneePointYArray, ...
            %  intersectPointXArray, intersectPointYArray);
            % Plot the translation of the 4bar linkage withr respect to the
            % centerline of the leg
            % main.Plot4BarLinkageDistanceChange(distanceChangeOfTopLink, distanceChangeOfBottomLink, ...
            %   topLinkXMovement, topLinkYMovement);
            
            %% Calculate the Angular Velocity and Acceleration of the 4Bar
%                 angularVelocityLink2 = zeros(1,100);
%                 angularVelocityLink4 = zeros(1,100);
%                 angularAccelLink2 = zeros(1,100);
%                 angularAccelLink4 = zeros(1,100);
%            
%              for i=(1:(length(fourBarArray)-1)) % Only minus one since using average velocity currently
%                  xScaleTime = linspace(0, timeForGaitCycle, (length(positionArray)));
%                  % Thigh angular
%                  angVelThigh = angularAccel.angularVelocityThigh(i);
%                  angAccelThigh = subs(angularAccel.angularAccelThigh, xScaleTime(i));
%                  angAccelThigh = double(angAccelThigh);
%                  % Shank angular
%                  angVelShank = angularAccel.angularVelocityShank(i);
%                  angAccelShank =  subs(angularAccel.angularAccelShank, xScaleTime(i));
%                  angAccelShank = double(angAccelShank);                
%  
%                  % Do Calcs
%                  fourBarCalcs = FourBarCalculations(fourBarArray(i), angVelThigh, angAccelThigh, ...
%                  angVelShank, angAccelShank);
%                 angularVelocityLink2(i) = fourBarCalcs.wL2;
%                 angularVelocityLink4(i) = fourBarCalcs.wL4;
%                 
%                 angularAccelLink2(i) = fourBarCalcs.alphaL2;
%                 angularAccelLink4(i) = fourBarCalcs.alphaL4;
%              end
% 
%              main.plot4BarVelocityAcceleration(angularVelocityLink2, angularVelocityLink4, ...
%                  angularAccelLink2, angularAccelLink4);
            
            %% Plot the Linear Velocity and Acceleration
            %linearAccel.PlotVelocityInterpolationCurves();
            %linearAccel.PlotAccelerationCurves();
            %linearAccel.PlotAvgAccelerationCurves();

            %% Plot the Angular Velocity and Accelerations
            %angularAccel.PlotVelocityInterpolationCurves();
            %angularAccel.PlotAccelerationCurves();
            %angularAccel.PlotAvgAccelerationCurves();
                
            %% Plot the inverse dynamics without the weight of the exoskeleton    
            %inverseDynamics.PlotMomentGraphs();
            
            %% Plot the Shear Force Bending Moment diagrams for the hip shaft
            %main.PlotShearForceBendingMoment(ShearF, BendM, hipShaft.zShaftLength);  
            
            %%  Plot the inverse dynamics with the weight of the exoskeleton
            %inverseDynamicsExo.PlotMomentGraphs();

            %% Plotting Moments including the exoskeleton weight 
            %main.PlotMomentContribution(hipContributedMoments, dorsiSpringContributedMoments, plantarSpringContributedMoments, ...
            %    dorsiTorsionContributedMoments, plantarTorsionContributedMoments);
            %main.PlotCamMoments(dorsiTorsionCamMoments, plantarTorsionCamMoments);

            %% Total Moments
            %main.PlotTotalMoments(inverseDynamics.MHipZ_Array, inverseDynamicsExo.MHipZExo_Array, hipContributedMoments, ...
            %    inverseDynamics.MKneeZ_Array, inverseDynamicsExo.MKneeZExo_Array, ...
            %    inverseDynamics.MAnkleZ_Array, inverseDynamicsExo.MAnkleZExo_Array, ...
            %    dorsiSpringContributedMoments, dorsiTorsionContributedMoments, ...
            %    plantarSpringContributedMoments, plantarTorsionContributedMoments);
        end
    end
    
    %% Various Plots not shown in the GUI - but used in the report
    % Commented for sake of runtime and cleanliness
    
    methods(Static)
        function PlotShearForceBendingMoment(ShearF, BendM, ShaftLength)
            xAxisShear = linspace(0,ShaftLength,length(ShearF));
            xAxisBendingMoment = linspace(0,ShaftLength,length(BendM)); 
            
            figure
            % Plot the shear force diagram on the hip shaft
            top = subplot(2,1,1);
            plot(top, xAxisShear, ShearF, 'LineWidth',2);
            title('Shear Force Diagram');
            ylabel('Shear Force (N)')
            xlabel('Length (m)') 
            set(top, 'LineWidth',1)
            grid on
            axis(top, [0 ShaftLength (min(ShearF)-1) (max(ShearF)+2)]);

            % Plot the bending moment on the hip shaft
            middle = subplot(2,1,2);
            plot(middle, xAxisBendingMoment, BendM, 'LineWidth', 2);
            title('Bending Moment Diagram');
            ylabel('Moment (Nm)')
            xlabel('Gait Cycle (%)') 
            set(middle, 'LineWidth',1)
            grid on
            axis(middle, [0 ShaftLength (min(BendM)-0.1) (max(BendM)+0.1)]);
        end
        
        function PlotTotalMoments(hipMoment, hipExoMoment, hipExoContributionMoment, ...
    kneeMoment, kneeExoMoment, ankleMoment, ankleExoMoment, dorsiSpringContributionMoment, ...
    dorsiCamContributionMoment, plantarSpringContributionMoment, plantarCamContributionMoment)

    figure
    % Plot the plantarflexion cable and spring length graph
    top = subplot(3,1,1);
    plot(top, 0:length(hipMoment)-1, (-1)*hipMoment, 'LineWidth',1);
    hold on
    grid on
    plot(top, 0:length(hipExoMoment)-1, (-1)*hipExoMoment, 'LineWidth',1);
    hold on
    plot(top, 1:length(hipExoContributionMoment), hipExoContributionMoment, 'LineWidth',1);
    title('All Hip Moment');
    ylabel('Moment (Nm)')
    xlabel('Gait Cycle (%)') 
    set(top, 'LineWidth',1)
    legend(top, 'Reg Hip', 'Exo Hip', 'Cont Hip')
    
     % Plot the plantarflexion cable and spring length graph
    middle = subplot(3,1,2);
    plot(middle, 0:length(kneeMoment)-1, (-1)*kneeMoment, 'LineWidth', 1);
    hold on
    grid on
    plot(middle, 0:length(kneeExoMoment)-1, (-1)*kneeExoMoment, 'LineWidth', 1);
    title('All Knee Moments');
    ylabel('Moment (Nm)')
    xlabel('Gait Cycle (%)') 
    set(middle, 'LineWidth',1)
    legend(middle, 'Reg Knee', 'Exo Knee')
     
    % Plot the plantarflexion cable and spring length graph
    top = subplot(3,1,3);
    plot(top, 0:length(ankleMoment)-1, (-1)*ankleMoment, 'LineWidth', 1);
    hold on
    grid on
    plot(top, 0:length(ankleExoMoment)-1, (-1)*ankleExoMoment, 'LineWidth', 1);
    hold on
    plot(top, 0:length(dorsiSpringContributionMoment)-1, dorsiSpringContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 0:length(dorsiCamContributionMoment)-1, dorsiCamContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 0:length(plantarSpringContributionMoment)-1, plantarSpringContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 0:length(plantarCamContributionMoment)-1, plantarCamContributionMoment, 'LineWidth', 1);
    
    title('Moment Contribution Plantar Spring over Gait Cycle');
    ylabel('Moment (Nm)')
    xlabel('Gait Cycle (%)') 
    set(top, 'LineWidth',1)
    legend(top, 'Reg Ankle', 'Exo Ankle', 'Dorsi Spring', 'Dorsi Cam', ...
         'Plant Spring', 'Plan Cam')
    %axis(top, [0 length(plantarMomentArray) (min(plantarMomentArray)-1) (max(plantarMomentArray)+1)]);
end

    function PlotCamMoments(dorsiTorsionMoments, plantarTorsionMoments)
        figure
        % Plot the dorsiTorsionMoments cable and spring length graph
        top = subplot(2,1,1);
        plot(top, 0:length(dorsiTorsionMoments)-1, dorsiTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment on Dorsiflexion Cam');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)

        % Plot the plantarTorsionMoments cable and spring length graph
        top = subplot(2,1,2);
        plot(top, 0:length(plantarTorsionMoments)-1, plantarTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment On Plantarflexion Cam');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
    end

    function PlotMomentContribution(hipMomentArray, dorsiMomentArray, plantarMomentArray, ...
        dorsiTorsionMoments, plantarTorsionMoments)
        figure
        % Plot the hip torsion spring moment applied
        top = subplot(5,1,1);
        plot(top, 0:length(hipMomentArray)-1, hipMomentArray, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Hip Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        
        % Plot the dorsiflexion extension spring moment applied
        middle = subplot(5,1,2);
        plot(middle, 0:length(dorsiMomentArray)-1, dorsiMomentArray, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Dorsi Extension Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(middle, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        axis(middle, [0 length(dorsiMomentArray) (min(dorsiMomentArray)-1) (max(dorsiMomentArray)+1)]);
        
        % Plot the plantarflexion extension spring moment applied
        top = subplot(5,1,3);
        plot(top, 0:length(plantarMomentArray)-1, plantarMomentArray, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Plantar Extension Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        axis(top, [0 length(plantarMomentArray) (min(plantarMomentArray)-1) (max(plantarMomentArray)+1)]);
        
        % Plot the dorsiTorsionMoments cable and spring length graph
        top = subplot(5,1,4);
        plot(top, 0:length(dorsiTorsionMoments)-1, dorsiTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Dorsi Torsion Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)

        % Plot the plantarTorsionMoments cable and spring length graph
        top = subplot(5,1,5);
        plot(top, 0:length(plantarTorsionMoments)-1, plantarTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Plantar Torsion Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)  
    end

    function maxValue = GetAbsMaxValueFromArray(array)
        mag1 = abs(max(array));
        mag2 = abs(min(array));
        if(mag1 > mag2)
            maxValue = max(array);
        else
            maxValue = min(array);
        end
    end

    function Plot4BarLinkageDistanceChange(topLinkageDistanceChangeArray, bottomLinkageDistanceChangeArray, ...
    topLinkXMovement, topLinkYMovement)
        figure
        % Plot the translation distance change of the top link
        top = subplot(2,1,1);
        plot(top, 1:length(topLinkageDistanceChangeArray), topLinkageDistanceChangeArray, 'LineWidth',2);
        hold on
        plot(top, 1:length(bottomLinkageDistanceChangeArray), bottomLinkageDistanceChangeArray, 'LineWidth',2);
        grid on
        title('Translation Magnitude of Pins from Centerlines');
        ylabel('Length (m)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        legend(top, 'Thigh Bar', 'Shank Bar')
        axis(top, [0 length(topLinkageDistanceChangeArray) (min(bottomLinkageDistanceChangeArray)-0.005) (max(topLinkageDistanceChangeArray)+0.005)])


        bottom = subplot(2,1,2);
        plot(bottom, 1:length(topLinkXMovement), topLinkXMovement, 'LineWidth',2);
        hold on
        plot(bottom, 1:length(topLinkYMovement), topLinkYMovement, 'LineWidth',2);
        grid on
        title('Distance from Thigh Centerline to Pin');
        ylabel('Length (m)')
        xlabel('Gait Cycle (%)') 
        set(bottom, 'LineWidth',1)
        legend(bottom, 'X Distance', 'Y Distance')
        axis(bottom, [0 length(topLinkXMovement) (min(topLinkXMovement)-0.005) (max(topLinkYMovement)+0.005)])
    end

    function PlotPlantarSpringLength(springLengthArray)
        %figure 

        %plot(1:length(springLengthArray), springLengthArray);

        figure
        % Plot the plantarflexion cable and spring length graph
        top = subplot(1,1,1);
        plot(top, 0:length(springLengthArray)-1, springLengthArray, 'LineWidth',2);
        hold on
        grid on
        title('Plantarflexion Spring and Cable Length vs. Percent Gait Cycle');
        ylabel('Length (m)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        legend(top, 'Spring and Cable Length')
        axis(top, [0 length(springLengthArray) (min(springLengthArray)-0.01) (max(springLengthArray)+0.01)]);
    end

    function PlotDorsiSpringLength(dorsiSpringLengthArray)
        figure
        % Plot the Hip moment graph
        top = subplot(1,1,1);
        plot(top, 0:length(dorsiSpringLengthArray)-1, dorsiSpringLengthArray, 'LineWidth',2);
        hold on
        grid on
        title('Dorsiflexion Spring and Cable Length vs. Percent Gait Cycle');
        ylabel('Length (m)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        legend(top, 'Spring and Cable Length')
        axis(top, [0 length(dorsiSpringLengthArray)  (min(dorsiSpringLengthArray)-0.02) (max(dorsiSpringLengthArray)+0.02)])
    end

    function Plot4BarLinkageWRTKneeJoint(kneePointXArray, kneePointYArray, ...
        intersectPointXArray, intersectPointYArray)

        figure
        top = subplot(2,1,1);
        plot(top, 1:length(kneePointXArray), kneePointXArray, 'LineWidth',2);
        hold on
        grid on
        plot(top, 1:length(intersectPointXArray), intersectPointXArray, 'LineWidth',2);
        title('Position of the Knee and Linkage Intersection - X Plane');
        ylabel('X Coordinates (m)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        legend(top, 'Knee Center','Linkage Intersection')
        axis(top, [0 100 min(intersectPointXArray)-0.02 max(kneePointXArray)+0.02])

        bottom = subplot(2,1,2);
        plot(bottom, 1:length(kneePointYArray), kneePointYArray, 'LineWidth',2);
        hold on
        grid on
        plot(bottom, 1:length(intersectPointYArray), intersectPointYArray, 'LineWidth',2);
        title('Position of the Knee and Linkage Intersection - Y Plane');
        xlabel('Gait Cycle (%)') 
        ylabel('Y Coordinates (m)') 
        set(bottom, 'LineWidth',1)
        legend(bottom, 'Knee Center','Linkage Intersection')
        axis(bottom, [0 100 (min(kneePointYArray)-0.02) max(intersectPointYArray)+0.02])
    end

    function Plot4BarLinkageOverRangeOfMotion(intersectPointXArray, intersectPointYArray)

        figure
        top = subplot(2,1,1);
        grid on
        plot(top, 1:length(intersectPointXArray), intersectPointXArray, 'LineWidth',2);
        title('Position of the Knee and Linkage Intersection');
        ylabel('X Coordinates (m)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        legend(top, 'Knee Center','Linkage Intersection')

        axis(top, [0 100 -0.2 0.3])

        bottom = subplot(2,1,2);
        grid on
        plot(bottom, 1:length(intersectPointYArray), intersectPointYArray, 'LineWidth',2);
        title('Position of the Knee and Linkage Intersection');
        xlabel('Gait Cycle (%)') 
        ylabel('Y Coordinates (m)') 
        set(bottom, 'LineWidth',1)

        legend(bottom, 'Knee Center','Linkage Intersection')
        axis(bottom, [0 100 -0.45 -0.3])
    end

    function PlotPatientGaitAngles(patientAngles)
        figure
        % Graph number 1
        top = subplot(4,1,1);
        plot(top, patientAngles.Time, patientAngles.LHipAngleZ);
        title(top,'Left Hip Angle Z');
        %topLeft.FontSize = 14;

        middle = subplot(4,1,2);
        plot(middle, patientAngles.Time, patientAngles.LKneeAngleZ);
        title(middle,'Left Knee Angle Z');
        grid(middle,'on');

        middleBottom = subplot(4,1,3);
        plot(middleBottom, patientAngles.Time, patientAngles.LAnkleAngleZ);
        title(middleBottom,'Left Ankle Angle Z');
        grid(middleBottom,'on');

        bottom = subplot(4,1,4);
        plot(bottom, patientAngles.Time, patientAngles.LFootAngleZ);
        title(bottom,'Left Foot Angle Z');
        grid(bottom,'on');
    end

    function PlotPatientGaitForces(patientForces)
        figure
        topLeft = subplot(3,1,1);
        plot(topLeft, patientForces.Time, patientForces.LGRFX);
        title(topLeft,'Ground Reaction Force X');
        %topLeft.FontSize = 14;

        topModel = subplot(3,1,2);
        plot(topModel, patientForces.Time, patientForces.LGRFY);
        title(topModel,'Ground Reaction Force Y');
        grid(topModel,'on');

        topModel = subplot(3,1,3);
        scatter(topModel, patientForces.Time, patientForces.LGRFZ);
        title(topModel,'Ground Reaction Force Z');
        grid(topModel,'on');
    end
    
    function plot4BarVelocityAcceleration(angularVelocityLink2, angularVelocityLink4, ...
                 angularAccelLink2, angularAccelLink4)
            figure
            top = subplot(2,1,1);
            plot(top, 0:length(angularVelocityLink2)-1, angularVelocityLink2, 'LineWidth',2);
            hold on
            grid on
            plot(top, 0:length(angularVelocityLink4)-1, angularVelocityLink4, 'LineWidth',2);
            title('Angular Velocity of the Crossing Links');
            ylabel('Angular Velocity (rad/s)')
            xlabel('Gait Cycle (%)') 
            set(top, 'LineWidth',1)
            legend(top, 'Link 2','Link 4')

            bottom = subplot(2,1,2);
            plot(bottom, 0:length(angularAccelLink2)-1, angularAccelLink2, 'LineWidth',2);
            hold on
            grid on
            plot(bottom, 0:length(angularAccelLink4)-1, angularAccelLink4, 'LineWidth',2);
            title('Angular Acceleration of the Crossing Links');
            xlabel('Gait Cycle (%)') 
            ylabel('Angular Acceleration (rad/s^2)') 
            set(bottom, 'LineWidth',1)
            legend(bottom, 'Link 2','Link 4')
    end

    end
end