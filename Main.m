function Main()
    global thighLength rightShankLength;
    % Names of body parts
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    % Build the anthropomtric model
    personHeight = 1.78; % in m
    model = AnthropometricModel(personHeight, 50.0);

    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    patient29CopData_Left = 'Patient29_ForcePlateData_LeftFoot.csv';
    patient29FootLengthInMm = 295;  % Approximated foot length
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
        
    % Build the position and 4Bar array from the patientAngle data
    positionArray = [];
    fourBarArray = [];
    kneePointXArray = zeros(1,101);
    kneePointYArray = zeros(1,101);
    intersectPointXArray = zeros(1,101);
    intersectPointYArray = zeros(1,101);
    plantarFlexionArray = [];
    springLengthArray = [];
    dorsiFlexionArray = [];
    dorsiSpringLengthArray = [];
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
         
        %linkagePosition = FourBarLinkagePositionNew(personHeight, position.KneeJointX, position.KneeJointY, ...
        %    model.dimensionMap(thighLength), model.dimensionMap(rightShankLength), hip, knee);
        linkagePosition = FourBarLinkagePosition(personHeight, position.KneeJointX, position.KneeJointY, ...
            model.dimensionMap(rightShankLength), hip, knee);
        fourBarArray = [fourBarArray linkagePosition];
 
        intersectPointXArray(item) = linkagePosition.IntersectPointX;
        intersectPointYArray(item) = linkagePosition.IntersectPointY;
     
        plantarPosition = PlantarFlexionSpringPosition(personHeight, position.AnkleJointX, position.AnkleJointY, ...
             ankle, foot, position.ShankComXPoint, position.ShankComYPoint);
        plantarFlexionArray = [plantarFlexionArray plantarPosition];
        springLengthArray = [springLengthArray plantarPosition.Length];
         
        dorsiPosition = DorsiFlexionSpringPosition(personHeight, position.KneeJointX, position.KneeJointY, ...
            position.AnkleJointX, position.AnkleJointY, position.ThighComXPoint, position.ThighComYPoint, ... 
            position.FootComXPoint, position.FootComYPoint, position.ShankComXPoint, position.ShankComYPoint, ... 
            hip, knee, ankle, foot, position.ToeX, position.ToeY);
        dorsiFlexionArray = [dorsiFlexionArray dorsiPosition];
        dorsiSpringLengthArray = [dorsiSpringLengthArray dorsiPosition.Length];
    end   
    
    % Calc the linear and angular accelerations 
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
        
    % Plot the plantarflexion and dorsiflexion spring
    %PlotShankSpringLength(springLengthArray);
    %PlotDorsiSpringLength(dorsiSpringLengthArray);
    % Plot the Intersection of the 4 bar linkage with respect to the knee
    % joint position
    Plot4BarLinkageWRTKneeJoint(kneePointXArray, kneePointYArray, ...
    intersectPointXArray, intersectPointYArray);
    
    %HipTorsionSpring(patient29Angles.LHipAngleZ);
    %PlantarSpringCalcs(springLengthArray);
    %DorsiSpringCalcs();
    
    % Run the gait simulation
    %FourBarLinkageSim(fourBarArray);
    %GaitSimulation(positionArray);
    FullSimulation(fourBarArray, positionArray);
    %PlantarFlexionSpringSim(plantarFlexionArray);
    %DorsiFlexionSpringSim(dorsiFlexionArray);
    %FullSimulationPart2(plantarFlexionArray, positionArray, dorsiFlexionArray);
    
    %inverseDynamics = InverseDynamics(model, positionArray, linearAccel, ...
    %    angularAccel, patient29Forces, normCopData, timeForGaitCycle);
    %inverseDynamics.PlotMomentGraphs();
end

%PlotPatientGaitAngles(patient29Angles);
%PlotPatientGaitForces(patient29Forces);

function PlotShankSpringLength(springLengthArray)
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
            axis(top, [0 length(springLengthArray)  (1)*(max(springLengthArray)+1) (-1)*(min(springLengthArray)-1)])

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
            axis(top, [0 length(dorsiSpringLengthArray)  (min(dorsiSpringLengthArray)-0.05) (max(dorsiSpringLengthArray)+0.05)])
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

