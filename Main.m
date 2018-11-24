function Main()
    global thighLength rightShankLength;
    %% Initialize databases to use throughout the code
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    % Build the anthropomtric model
    personHeight = 2; % in m
    model = AnthropometricModel(personHeight, 50.0);

    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    patient29CopData_Left = 'Patient29_ForcePlateData_LeftFoot.csv';
    patient29FootLengthInMm = 295;  % Approximated foot length
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
    
    %PlotPatientGaitAngles(patient29Angles);
        
    %% Create arrays over the gait cycle
    positionArray = [];
    fourBarArray = [];
    kneePointXArray = zeros(1,101);
    kneePointYArray = zeros(1,101);
    intersectPointXArray = zeros(1,101);
    intersectPointYArray = zeros(1,101);
    plantarFlexionArray = [];
    plantarSpringLengthArray = [];
    dorsiFlexionArray = [];
    dorsiSpringLengthArray = [];
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
     
        plantarPosition = PlantarFlexionSpringPosition(personHeight, position.AnkleJointX, position.AnkleJointY, ...
             ankle, foot, position.ShankComXPoint, position.ShankComYPoint, knee, hip);
        plantarFlexionArray = [plantarFlexionArray plantarPosition];
        plantarSpringLengthArray = [plantarSpringLengthArray plantarPosition.Length];
        
        distanceChangeOfTopLink(item) = linkagePosition.TopBarLinkageDistanceChange;
        distanceChangeOfBottomLink(item) = linkagePosition.BottomBarLinkageDistanceChange;
        topLinkXMovement(item) = linkagePosition.TopBarMovementX;
        topLinkYMovement(item) = linkagePosition.TopBarMovementY;
         
        dorsiPosition = DorsiFlexionSpringPosition(position, model.dimensionMap,...
            hip, knee, ankle, foot);
        dorsiFlexionArray = [dorsiFlexionArray dorsiPosition];
        dorsiSpringLengthArray = [dorsiSpringLengthArray dorsiPosition.Length];
    end
    
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
    PlotDorsiSpringLength(dorsiSpringLengthArray);
    PlotPlantarSpringLength(plantarSpringLengthArray);
    
    % Plot the shank spring
    % PlotShankSpringLength(springLengthArray);	 
    
    %% Spring Calcs -- note, need mCable to automate, method to find string lengths within the functions 
    % Hip torsional spring
    hipTorsionSpring = HipTorsionSpring(personHeight, patient29Angles.LHipAngleZ);
    
    % Extension spring for Plantarflexion
    plantarSpring = PlantarSpringCalcs(personHeight, plantarSpringLengthArray);
    
    % Torsional spring for the Platarflexion Cam
    diamPlantarCable = 0.005;
    densityPlantarCable =  7850;
    mPlantarCable = (pi*(diamPlantarCable.^2)/4)*plantarSpring.extensionCableLength*densityPlantarCable;
    mPlantarPull = plantarSpring.weightExtensionSpring + mPlantarCable;
    plantarTorsionSpring = PlantarTorsionSpring(personHeight, mPlantarPull, plantarSpringLengthArray);
    
    % Extension spring for Dorsiflexion
    dorsiSpring = DorsiSpringCalcs(personHeight, dorsiSpringLengthArray);
    
    % Torsional spring for the Dorsiflexion Cam
    diamDorsiCable = 0.005;
    densityDorsiCable =  7850;
    mDorsiCable = (pi*(diamDorsiCable.^2)/4)*dorsiSpring.extensionCableLength*densityDorsiCable;
    mDorsiPull = dorsiSpring.weightExtensionSpring + mDorsiCable;
    dorsiTorsionSpring = DorsiTorsionSpring(personHeight, mDorsiPull, dorsiSpringLengthArray);
    
    %% Plotting the 4Bar 
    % Plot the Intersection of the 4 bar linkage with respect to the knee joint position
    % Plot4BarLinkageWRTKneeJoint(kneePointXArray, kneePointYArray, ...
    %   intersectPointXArray, intersectPointYArray);
    % PlotTopBarLinkageChangeDistance(distanceChangeOfTopLink, distanceChangeOfBottomLink, ...
    %    topLinkXMovement, topLinkYMovement);
    
    %% Shaft Analysis Things
    % Calculates mass of each component based on anthropometric model
    exoskeletonMasses = Exoskeleton_Mass_Anthropometric(personHeight);
    
    % Calculates shaft dimensions based on anthropometric model
    shaft = Shaft_Length_Anthropometric(personHeight, hipTorsionSpring.shaftDiameter, ...
    hipTorsionSpring.wireDiameterSpring, hipTorsionSpring.lengthSupportLeg, hipTorsionSpring.lengthHipSpring);
    
    % Build the shear force bending moment diagrams with the correct forces
    % Currently returns the right components.. However the gui shows the forces in kN which is wrong...
    % Scale for the bending moment is also wrong, should be .12 not 1.2
    [ShearF, BendM] = ShearForceBendingMoment('Prob 200', ...
                [shaft.zShaftLength,shaft.supportDist1], ...
                {'CF',shaft.Fg1,shaft.casingDist1}, ...
                {'CF',shaft.Fg2,shaft.retainingRingDist1}, ...
                {'CF',shaft.Fy2,shaft.supportDist1}, ...
                {'CF',shaft.Fg3,shaft.keyDist}, ...
                {'CF',shaft.Fg4,shaft.springDist}, ...
                {'CF',shaft.Fg5,shaft.comOfShaftDist}, ...
                {'CF',shaft.Fg6,shaft.bearingDist}, ...
                {'CF',shaft.Fg7,shaft.exoLegDist}, ...
                {'CF',shaft.Fg8,shaft.retainingRingDist2}, ...
                {'CF',shaft.Fg9, shaft.casingDist2});
    %ShearForceBendingMoment('Prob 200',[0.153,0.005,0.148],{'CF',-1.8161,0.005},{'CF',-0.0139,0.0165},{'CF',-0.0237,0.023},{'CF',0.8626905882,0.023},{'CF',-0.5863,0.0525},{'CF',-1.4834,0.0759},{'CF',4.895709412,0.0825},{'CF',-0.0189,0.0915},{'CF',-1.8161,0.148});
    disp(['Max Shear Force: ', num2str(max(ShearF)), 'N,   Min Shear Force: ',  num2str(min(ShearF)), 'N']);
    disp(['Max Bending Moment Force: ', num2str(max(BendM)), 'N*m,   Min Bending Moment Force: ',  num2str(min(BendM)), 'N*m']);
    
    % Shaft shoulder Analysis
    ShoulderCalcs(personHeight, GetAbsMaxValueFromArray(BendM), hipTorsionSpring.maxTorsionFromSpring,...
        hipTorsionSpring.shaftDiameter, shaft);
    
    %% Others Calcs - Bolts, Bearings, Whatever else
    
    
    
    %% Run Simulations - for different components
    %FourBarLinkageSim(fourBarArray);
    %GaitSimulation(positionArray);
    %FullSimulation(fourBarArray, positionArray);
    %PlantarFlexionSpringSim(plantarFlexionArray);
    %DorsiFlexionSpringSim(dorsiFlexionArray);
    FullSimulationPart2(plantarFlexionArray, positionArray, dorsiFlexionArray);
    
    
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
        
    %% Calculate the Velocity and Acceleration of the 4Bar
    for i=(1:(length(fourBarArray)-1)) % Only minus one since using average velocity currently
        xScaleTime = linspace(0, timeForGaitCycle, (length(positionArray)));
        % Thigh angular
        angVelThigh = angularAccel.angularVelocityThigh(i);
        angAccelThigh = subs(angularAccel.angularAccelThigh, xScaleTime(i));
        angAccelThigh = double(angAccelThigh);
        % Shank angular
        angVelShank = angularAccel.angularVelocityShank(i);
        angAccelShank =  subs(angularAccel.angularAccelShank, xScaleTime(i));
        angAccelShank = double(angAccelShank);                

        % Do Calcs
        FourBarCalculations(fourBarArray(i), angVelThigh, angAccelThigh, ...
        angVelShank, angAccelShank);
        
    end
    
    %% Inverse Dynamics
    inverseDynamics = InverseDynamics(model, positionArray, linearAccel, ...
        angularAccel, patient29Forces, normCopData, timeForGaitCycle);
    inverseDynamics.PlotMomentGraphs();
    
    %% Moment Contribution
    hipContributedMoments = zeros(1, length(positionArray));
    kneeContributedMoments = zeros(1, length(positionArray));
    ankleContributedMoments = zeros(1, length(positionArray));
    
    dorsiTorsionContributedMoments = zeros(1, length(positionArray));
    plantarTorsionContributedMoments = zeros(1, length(positionArray));
    
    for i=(1:(length(positionArray)))
        % Hip Torsion Spring Moment
        momentAdded = hipTorsionSpring.GetMomentContribution(positionArray(i).HipAngleZ, i);
        hipContributedMoments(i) = (momentAdded);
        
        % Dorsiflexion Spring Moment
        [maxDorsiLength, maxValueIndex] = max(dorsiSpringLengthArray);
        kneeContributedMoments(i) = dorsiSpring.GetMomentContribution(dorsiSpringLengthArray(i), ...
         dorsiFlexionArray(i), maxDorsiLength, maxValueIndex, i);
     
        % Plantar Spring Moment
        [maxPlantarLength, maxValueIndex] = max(plantarSpringLengthArray);
        ankleContributedMoments(i) = plantarSpring.GetMomentContribution(plantarSpringLengthArray(i), ...
            plantarFlexionArray(i), maxPlantarLength, maxValueIndex, i);
        
        % Cam contributed to gait moments
        dorsiTorsionContributedMoments(i) = dorsiTorsionSpring.GetMomentContribution(dorsiFlexionArray(i));
        plantarTorsionContributedMoments(i) = plantarTorsionSpring.GetMomentContribution(plantarFlexionArray(i));
    end
    
    %% Moments on the Cams from picking up slack
    dorsiTorsionCamMoments = zeros(1, length(positionArray));
    plantarTorsionCamMoments = zeros(1, length(positionArray));
    for i=(1:(length(positionArray)))
        % Find the cable lengths
        if(i==1) % Start 1, Previous 101
            currentDorsiSpringLength = dorsiSpringLengthArray(i);
            previousDorsiSpringLength = dorsiSpringLengthArray(length(positionArray));
            
            currentPlantarSpringLength = plantarSpringLengthArray(i);
            previousPlantarSpringLength = plantarSpringLengthArray(length(positionArray));
        else % Start i, Previous i - 1
            currentDorsiSpringLength = dorsiSpringLengthArray(i);
            previousDorsiSpringLength = dorsiSpringLengthArray(i-1);
            
            currentPlantarSpringLength = plantarSpringLengthArray(i);
            previousPlantarSpringLength = plantarSpringLengthArray(i-1);
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
    PlotMomentContribution(hipContributedMoments, kneeContributedMoments, ankleContributedMoments, ...
        dorsiTorsionContributedMoments, plantarTorsionContributedMoments);
    PlotCamMoments(dorsiTorsionCamMoments, plantarTorsionCamMoments);
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

function PlotTopBarLinkageChangeDistance(topLinkageDistanceChangeArray, bottomLinkageDistanceChangeArray, ...
topLinkXMovement, topLinkYMovement)
    figure
    % Plot the translation distance change of the top link
    top = subplot(2,1,1);
    plot(top, 1:length(topLinkageDistanceChangeArray), topLinkageDistanceChangeArray, 'LineWidth',2);
    hold on
    plot(top, 1:length(bottomLinkageDistanceChangeArray), bottomLinkageDistanceChangeArray, 'LineWidth',2);
    grid on
    title('Distance from Center of Limb to Pin');
    ylabel('Length (m)')
    xlabel('Gait Cycle (%)') 
    set(top, 'LineWidth',1)
    legend(top, 'Thigh Linkage', 'Bottom Linkage')
    axis(top, [0 length(topLinkageDistanceChangeArray) (min(bottomLinkageDistanceChangeArray)-0.005) (max(topLinkageDistanceChangeArray)+0.005)])
    
    
    bottom = subplot(2,1,2);
    plot(bottom, 1:length(topLinkXMovement), topLinkXMovement, 'LineWidth',2);
    hold on
    plot(bottom, 1:length(topLinkYMovement), topLinkYMovement, 'LineWidth',2);
    grid on
    title('Distance from Thigh to Pin');
    ylabel('Length (m)')
    xlabel('Gait Cycle (%)') 
    set(bottom, 'LineWidth',1)
    legend(bottom, 'Thigh X Mov.', 'Thigh Y Mov.')
    axis(bottom, [0 length(topLinkXMovement) (min(topLinkXMovement)-0.005) (max(topLinkYMovement)+0.005)])
end

function PlotPlantarSpringLength(springLengthArray)
    %figure 
    
    %plot(1:length(springLengthArray), springLengthArray);
    
    figure
    % Plot the plantarflexion cable and spring length graph
    top = subplot(1,1,1);
    plot(top, 1:length(springLengthArray), springLengthArray, 'LineWidth',2);
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
    plot(top, 1:length(dorsiSpringLengthArray), dorsiSpringLengthArray, 'LineWidth',2);
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
    title('Position of the Knee and Linkage Intersection');
    ylabel('X Coordinates (m)')
    xlabel('Gait Cycle (%)') 
    set(top, 'LineWidth',1)
    legend(top, 'Knee Center','Linkage Intersection')
    
    axis(top, [0 100 -0.2 0.3])
    
    bottom = subplot(2,1,2);
    plot(bottom, 1:length(kneePointYArray), kneePointYArray, 'LineWidth',2);
    hold on
    grid on
    plot(bottom, 1:length(intersectPointYArray), intersectPointYArray, 'LineWidth',2);
    title('Position of the Knee and Linkage Intersection');
    xlabel('Gait Cycle (%)') 
    ylabel('Y Coordinates (m)') 
    set(bottom, 'LineWidth',1)
    
    legend(bottom, 'Knee Center','Linkage Intersection')
    axis(bottom, [0 100 -0.45 -0.3])
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