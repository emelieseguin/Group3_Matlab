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
        overallExoHipMoment %% -- calculate these things
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

                linkagePosition = FourBarLinkageMathDefined_FromGait(personHeight, position.KneeJointX, position.KneeJointY, ...
                    model.dimensionMap(thighLength), model.dimensionMap(rightShankLength), hip, knee, position.ThighLine, position.ShankLine);
                %linkagePosition = FourBarLinkagePosition(personHeight, position.KneeJointX, position.KneeJointY, ...
                %    model.dimensionMap(rightShankLength), hip, knee, item);
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
            
            % Used in the thing
            main.gaitPositionArray = positionArray;

            %% Test Stuff - not used currently - shows range of motion for 4Bar
            % Test for the range of motion of the 4 bar
            %fourBarTest = [];
            %qAngle =  90; %127.71; %- proper one;
            %while(qAngle < (180-19.5))
            %    test = FourBarLinkageMathDefined(personHeight, position.KneeJointX, position.KneeJointY, ...
            %        model.dimensionMap(thighLength), model.dimensionMap(rightShankLength), hip, knee, qAngle);
            %    fourBarTest = [fourBarTest test];
            %    qAngle = qAngle + 1;
            %end

            %% Plotting Graphs for Spring Length - wrt to height
            % Plot the plantarflexion and dorsiflexion spring
            main.PlotDorsiSpringLength(dorsiSpringAndCableLengthArray);
            main.PlotPlantarSpringLength(plantarSpringAndCableLengthArray);

            % Plot the shank spring
            % main.PlotShankSpringLength(springLengthArray);	 

            %% Spring Calcs -- note, need mCable to automate, method to find string lengths within the functions 
            % Hip torsional spring
            hipTorsionSpring = HipTorsionSpring(personHeight, patient29Angles.LHipAngleZ);

            %% Extension spring for Plantarflexion
            plantarSpring = PlantarSpringCalcs(personHeight, plantarSpringAndCableLengthArray);
            plantarSpringLengthArray = [];  %% make sure this is right - dim is wrong right now - previous version correct
            for i=1:length(plantarFlexionArray)
                planatarPosition = plantarFlexionArray(i);
                springLength = planatarPosition.Length + plantarSpring.totalLengthUnstrechedSpring - plantarSpring.neutralLengthValue;
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

            dorsiSpringLengthArray = []; %% make sure this is right - dim is wrong right now - previous version right
            for i=1:length(dorsiFlexionArray)
                dorsiPosition = dorsiFlexionArray(i);
                springLength = dorsiPosition.Length + dorsiSpring.totalLengthUnstrechedSpring - dorsiSpring.neutralLengthValue;
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

            %% Plotting the 4Bar 
            % Plot the Intersection of the 4 bar linkage with respect to the knee joint position
             %main.Plot4BarLinkageWRTKneeJoint(kneePointXArray, kneePointYArray, ...
             %  intersectPointXArray, intersectPointYArray);
             
            main.kneePointXArray = kneePointXArray;
            main.kneePointYArray = kneePointYArray;
            main.intersectPointXArray = intersectPointXArray;
            main.intersectPointYArray = intersectPointYArray;
            main.fourBarPositionArray = fourBarArray;
             
             %main.Plot4BarLinkageDistanceChange(distanceChangeOfTopLink, distanceChangeOfBottomLink, ...
             %   topLinkXMovement, topLinkYMovement);

            %% Shaft Analysis Things
            % Calculates mass of each component based on anthropometric model
            exoskeletonMasses = Exoskeleton_Mass_Anthropometric(personHeight);

            % Calculates shaft dimensions based on anthropometric model
            hipShaft = Shaft_Length_Anthropometric(personHeight, hipTorsionSpring.shaftDiameter, ...
            hipTorsionSpring.wireDiameterSpring, hipTorsionSpring.lengthSupportLeg, hipTorsionSpring.lengthHipSpring);

            % Build the shear force bending moment diagrams with the correct forces
            % Currently returns the right components.. However the gui shows the forces in kN which is wrong...
            % Scale for the bending moment is also wrong, should be .12 not 1.2
            [ShearF, BendM] = ShearForceBendingMoment('Prob 200', ...
                        [hipShaft.zShaftLength,hipShaft.supportDist1], ...
                        {'CF',hipShaft.Fg1,hipShaft.casingDist1}, ...
                        {'CF',hipShaft.Fg2,hipShaft.retainingRingDist1}, ...
                        {'CF',hipShaft.Fy2,hipShaft.supportDist1}, ...
                        {'CF',hipShaft.Fg3,hipShaft.keyDist}, ...
                        {'CF',hipShaft.Fg4,hipShaft.springDist}, ...
                        {'CF',hipShaft.Fg5,hipShaft.comOfShaftDist}, ...
                        {'CF',hipShaft.Fg6,hipShaft.bearingDist}, ...
                        {'CF',hipShaft.Fg7,hipShaft.exoLegDist}, ...
                        {'CF',hipShaft.Fg8,hipShaft.retainingRingDist2}, ...
                        {'CF',hipShaft.Fg9, hipShaft.casingDist2});
            %ShearForceBendingMoment('Prob 200',[0.153,0.005,0.148],{'CF',-1.8161,0.005},{'CF',-0.0139,0.0165},{'CF',-0.0237,0.023},{'CF',0.8626905882,0.023},{'CF',-0.5863,0.0525},{'CF',-1.4834,0.0759},{'CF',4.895709412,0.0825},{'CF',-0.0189,0.0915},{'CF',-1.8161,0.148});
            %disp(['Max Shear Force: ', num2str(max(ShearF)), 'N,   Min Shear Force: ',  num2str(min(ShearF)), 'N']);
            %disp(['Max Bending Moment Force: ', num2str(max(BendM)), 'N*m,   Min Bending Moment Force: ',  num2str(min(BendM)), 'N*m']);

            % Shaft shoulder Analysis
            ShoulderCalcs(personHeight, main.GetAbsMaxValueFromArray(BendM), hipTorsionSpring.maxTorsionFromSpring,...
                hipTorsionSpring.shaftDiameter, hipShaft);
            
            %% Print the value for all of the components
            FinalPartsCombined(personHeight, hipShaft, dorsiPosition, plantarFlexionArray(1), ...
            plantarTorsionSpring, dorsiTorsionSpring);
            %footMechanism(personHeight);

            %% Others Calcs - Bolts, Bearings, whatever else
            
            
            %% Run Simulations - for different components
            %FourBarLinkageSim(fourBarArray);
            %GaitSimulation(positionArray);
            %FullSimulation(fourBarArray, positionArray);
            %PlantarFlexionSpringSim(plantarFlexionArray);
            %DorsiFlexionSpringSim(dorsiFlexionArray);
            %FullSimulationPart2(plantarFlexionArray, positionArray, dorsiFlexionArray);

            %% Calc the linear and angular accelerations 
            patient29_HeelStrike = 0;
            patient29_ToeOff = patient29Forces.ToeOffPercentage;
            timeForGaitCycle = 1.48478;
            linearAccel = LinearAcceleration(positionArray, timeForGaitCycle);
            angularAccel = AngularAcceleration(positionArray, timeForGaitCycle);
            normCopData = NormalizeCopData(patient29CopData_Left, ...
                patient29_HeelStrike, patient29_ToeOff, patient29FootLengthInMm);

            % Plot the Linear Velocity and Acceleration
                %linearAccel.PlotVelocityInterpolationCurves();
                %linearAccel.PlotAccelerationCurves();
                %linearAccel.PlotAvgAccelerationCurves();

            % Plot the Angular Velocity and Accelerations
                %angularAccel.PlotVelocityInterpolationCurves();
                %angularAccel.PlotAccelerationCurves();
                %angularAccel.PlotAvgAccelerationCurves();
            
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
            %% Inverse Dynamics
            inverseDynamics = InverseDynamics(model, positionArray, linearAccel, ...
                angularAccel, patient29Forces, normCopData, timeForGaitCycle);    
            %inverseDynamics.PlotMomentGraphs();
            
            main.basicInverseDynamics = inverseDynamics;

            %% With Dynamics with the exoskeleton - need volume calcs
             totalMassOfExoskelton = 10; % in kg
             thighExoMass = 4; % in kg
             shankExoMass = 3.5;
             footExoMass = 2.5;
             inverseDynamicsExo = InverseDynamicsWithExoskeleton(model, positionArray, linearAccel, ...
                 angularAccel, patient29Forces, normCopData, timeForGaitCycle, totalMassOfExoskelton, ...
                 thighExoMass, shankExoMass, footExoMass);
             %inverseDynamicsExo.PlotMomentGraphs();

            %% Moment Contribution
             hipContributedMoments = zeros(1, length(positionArray));
             dorsiSpringContributedMoments = zeros(1, length(positionArray));
             plantarSpringContributedMoments = zeros(1, length(positionArray));
 
             dorsiTorsionContributedMoments = zeros(1, length(positionArray));
             plantarTorsionContributedMoments = zeros(1, length(positionArray));
 
             for i=(1:(length(positionArray)))
                 % Hip Torsion Spring Moment
                 momentAdded = hipTorsionSpring.GetMomentContribution(positionArray(i).HipAngleZ, i);
                 hipContributedMoments(i) = momentAdded;
  
                 % Dorsiflexion Spring Moment
                 [maxDorsiLength, maxValueIndex] = max(dorsiSpringAndCableLengthArray);
                 dorsiSpringContributedMoments(i) = dorsiSpring.GetMomentContribution(dorsiSpringAndCableLengthArray(i), ...
                  dorsiFlexionArray(i), maxDorsiLength, maxValueIndex, i);
 
                 % Plantar Spring Moment
                 [maxPlantarLength, maxValueIndex] = max(plantarSpringAndCableLengthArray);
                 plantarSpringContributedMoments(i) = plantarSpring.GetMomentContribution(plantarSpringAndCableLengthArray(i), ...
                     plantarFlexionArray(i), maxPlantarLength, maxValueIndex, i);
 
                 % Cam contributed to gait moments
                 dorsiTorsionContributedMoments(i) = dorsiTorsionSpring.GetMomentContribution(dorsiFlexionArray(i));
                 plantarTorsionContributedMoments(i) = plantarTorsionSpring.GetMomentContribution(plantarFlexionArray(i));
             end
             
            % Exoskeleton
            main.exoInverseDynamics = inverseDynamicsExo;
            main.overallExoHipMoment = (-1)*inverseDynamicsExo.MHipZExo_Array + hipContributedMoments;
            main.overallExoKneeMoment = (-1)*inverseDynamicsExo.MKneeZExo_Array;
            main.overallExoAnkleMoment = (-1)*inverseDynamicsExo.MAnkleZExo_Array + dorsiSpringContributedMoments + plantarSpringContributedMoments + dorsiTorsionContributedMoments + plantarTorsionContributedMoments;
            
            % Springs
            main.hipContributedMoments = hipContributedMoments;
            main.dorsiSpringContributedMoments = dorsiSpringContributedMoments;
            main.plantarSpringContributedMoments = plantarSpringContributedMoments;

            % Cams
            main.dorsiTorsionContributedMoments = dorsiTorsionContributedMoments;
            main.plantarTorsionContributedMoments = plantarTorsionContributedMoments;

            %% Moments on the Cams from picking up slack
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
                 % - actually the moment on the cam itself, not on the ankle
                 dorsiTorsionCamMoments(i) = dorsiTorsionSpring.GetMomentOnCam(currentDorsiSpringLength, previousDorsiSpringLength, ...
                     dorsiSpring.extensionCableLength, dorsiSpring.lengthUnstrechedSpring, dorsiSpring.R1, i);
 
                 % Plantartorsion Spring
                 % ---- actually the moment on the cam itself, not on the ankle
                 plantarTorsionCamMoments(i) = plantarTorsionSpring.GetMomentOnCam(currentPlantarSpringLength, previousPlantarSpringLength, ...
                     plantarSpring.extensionCableLength, plantarSpring.lengthUnstrechedSpring, plantarSpring.R1, plantarSpringLengthArray(1), i);
             end

            %% Plotting Moments
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
    
    methods(Static)
        function PlotTotalMoments(hipMoment, hipExoMoment, hipExoContributionMoment, ...
    kneeMoment, kneeExoMoment, ankleMoment, ankleExoMoment, dorsiSpringContributionMoment, ...
    dorsiCamContributionMoment, plantarSpringContributionMoment, plantarCamContributionMoment)

    figure
    % Plot the plantarflexion cable and spring length graph
    top = subplot(3,1,1);
    plot(top, 1:length(hipMoment), (-1)*hipMoment, 'LineWidth',1);
    hold on
    grid on
    plot(top, 1:length(hipExoMoment), (-1)*hipExoMoment, 'LineWidth',1);
    hold on
    plot(top, 1:length(hipExoContributionMoment), hipExoContributionMoment, 'LineWidth',1);
    title('All Hip Moment');
    ylabel('Moment (Nm)')
    xlabel('Gait Cycle (%)') 
    set(top, 'LineWidth',1)
    legend(top, 'Reg Hip', 'Exo Hip', 'Cont Hip')
    %axis(top, [0 length(hipMomentArray) (min(hipMomentArray)-1) (max(hipMomentArray)+1)]);
    
     % Plot the plantarflexion cable and spring length graph
    middle = subplot(3,1,2);
    plot(middle, 1:length(kneeMoment), (-1)*kneeMoment, 'LineWidth', 1);
    hold on
    grid on
    plot(middle, 1:length(kneeExoMoment), (-1)*kneeExoMoment, 'LineWidth', 1);
    title('All Knee Moments');
    ylabel('Moment (Nm)')
    xlabel('Gait Cycle (%)') 
    set(middle, 'LineWidth',1)
    legend(middle, 'Reg Knee', 'Exo Knee')
    %axis(middle, [0 length(dorsiMomentArray) (min(dorsiMomentArray)-1) (max(dorsiMomentArray)+1)]);
     
    % Plot the plantarflexion cable and spring length graph
    top = subplot(3,1,3);
    plot(top, 1:length(ankleMoment), (-1)*ankleMoment, 'LineWidth', 1);
    hold on
    grid on
    plot(top, 1:length(ankleExoMoment), (-1)*ankleExoMoment, 'LineWidth', 1);
    hold on
    plot(top, 1:length(dorsiSpringContributionMoment), dorsiSpringContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 1:length(dorsiCamContributionMoment), dorsiCamContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 1:length(plantarSpringContributionMoment), plantarSpringContributionMoment, 'LineWidth', 1);
    hold on
    plot(top, 1:length(plantarCamContributionMoment), plantarCamContributionMoment, 'LineWidth', 1);
    
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
        plot(top, 1:length(dorsiTorsionMoments), dorsiTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment on Dorsi Torsion Cam');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        %axis(top, [0 length(dorsiTorsionMoments) (min(dorsiTorsionMoments)-1) (max(dorsiTorsionMoments)+1)]);

        % Plot the plantarTorsionMoments cable and spring length graph
        top = subplot(2,1,2);
        plot(top, 1:length(plantarTorsionMoments), plantarTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment On Plantarflexion Cam');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        %axis(top, [0 length(dorsiTorsionMoments) (min(dorsiTorsionMoments)-1) (max(dorsiTorsionMoments)+1)]);
    end

    function PlotMomentContribution(hipMomentArray, dorsiMomentArray, plantarMomentArray, ...
        dorsiTorsionMoments, plantarTorsionMoments)
        figure
    %     % Plot the plantarflexion cable and spring length graph
    %     top = subplot(4,1,1);
    %     plot(top, 1:length(hipMomentArray), hipMomentArray, 'LineWidth',2);
    %     hold on
    %     grid on
    %     title('Moment Contribution Hip Spring over Gait Cycle');
    %     ylabel('Moment (Nm)')
    %     xlabel('Gait Cycle (%)') 
    %     set(top, 'LineWidth',1)
    %     %legend(top, 'Spring and Cable Length')
    %     %axis(top, [0 length(hipMomentArray) (min(hipMomentArray)-1) (max(hipMomentArray)+1)]);
    %     
    %     % Plot the plantarflexion cable and spring length graph
    %     middle = subplot(4,1,2);
    %     plot(middle, 1:length(dorsiMomentArray), dorsiMomentArray, 'LineWidth',2);
    %     hold on
    %     grid on
    %     title('Moment Contribution Dorsi Spring over Gait Cycle');
    %     ylabel('Moment (Nm)')
    %     xlabel('Gait Cycle (%)') 
    %     set(middle, 'LineWidth',1)
    %     %legend(top, 'Spring and Cable Length')
    %     axis(middle, [0 length(dorsiMomentArray) (min(dorsiMomentArray)-1) (max(dorsiMomentArray)+1)]);
    %     
    %     % Plot the plantarflexion cable and spring length graph
    %     top = subplot(4,1,3);
    %     plot(top, 1:length(plantarMomentArray), plantarMomentArray, 'LineWidth',2);
    %     hold on
    %     grid on
    %     title('Moment Contribution Plantar Spring over Gait Cycle');
    %     ylabel('Moment (Nm)')
    %     xlabel('Gait Cycle (%)') 
    %     set(top, 'LineWidth',1)
    %     %legend(top, 'Spring and Cable Length')
    %     axis(top, [0 length(plantarMomentArray) (min(plantarMomentArray)-1) (max(plantarMomentArray)+1)]);
    %     

        % Plot the dorsiTorsionMoments cable and spring length graph
        top = subplot(2,1,1);
        plot(top, 1:length(dorsiTorsionMoments), dorsiTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Dorsi Torsion Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        %axis(top, [0 length(dorsiTorsionMoments) (min(dorsiTorsionMoments)-1) (max(dorsiTorsionMoments)+1)]);

        % Plot the plantarTorsionMoments cable and spring length graph
        top = subplot(2,1,2);
        plot(top, 1:length(plantarTorsionMoments), plantarTorsionMoments, 'LineWidth',2);
        hold on
        grid on
        title('Moment Contribution Plantar Torsion Spring over Gait Cycle');
        ylabel('Moment (Nm)')
        xlabel('Gait Cycle (%)') 
        set(top, 'LineWidth',1)
        %legend(top, 'Spring and Cable Length')
        %axis(top, [0 length(dorsiTorsionMoments) (min(dorsiTorsionMoments)-1) (max(dorsiTorsionMoments)+1)]);    
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

    %% Various Plots
    %PlotPatientGaitAngles(patient29Angles);
    %PlotPatientGaitForces(patient29Forces);

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
        % Graph number 1
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
            plot(top, 1:length(angularVelocityLink2), angularVelocityLink2, 'LineWidth',2);
            hold on
            grid on
            plot(top, 1:length(angularVelocityLink4), angularVelocityLink4, 'LineWidth',2);
            title('Angular Velocity of the Crossing Links');
            ylabel('Angular Velocity (rad/s)')
            xlabel('Gait Cycle (%)') 
            set(top, 'LineWidth',1)
            legend(top, 'Link 2','Link 4')
            %axis(top, [0 100 min()])

            bottom = subplot(2,1,2);
            plot(bottom, 1:length(angularAccelLink2), angularAccelLink2, 'LineWidth',2);
            hold on
            grid on
            plot(bottom, 1:length(angularAccelLink4), angularAccelLink4, 'LineWidth',2);
            title('Angular Acceleration of the Crossing Links');
            xlabel('Gait Cycle (%)') 
            ylabel('Angular Acceleration (rad/s^2)') 
            set(bottom, 'LineWidth',1)
            legend(bottom, 'Link 2','Link 4')
            %axis(bottom, [0 100 -0.45 -0.3]) 
    end

    end
end





