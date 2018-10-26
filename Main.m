function Main()
    global rightShankLength;
    % Names of body parts
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    % Build the anthropomtric model
    personHeight = 178;
    model = AnthropometricModel(120.0, 50.0);

    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    patient29CopData_Left = 'Patient29_ForcePlateData_LeftFoot.csv';
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
    
    % Build the position and 4Bar array from the patientAngle data
    positionArray = [];
    fourBarArray = [];
    for item = 1:(length(patient29Angles.LFootAngleZ))
        
        % Get the angles from the object
        foot = patient29Angles.LFootAngleZ(item);
        knee = patient29Angles.LKneeAngleZ(item);
        hip = patient29Angles.LHipAngleZ(item);
        
        % Create the position of the leg, add it to the array
        position = GaitLegPosition(model, foot, knee, hip);
        positionArray = [positionArray position];
        
        linkagePosition = FourBarLinkagePosition(personHeight, position.KneeJointX, position.KneeJointY, ...
            model.dimensionMap(rightShankLength), hip, knee);
        fourBarArray = [fourBarArray linkagePosition];
    end   
    
    % Calc the linear and angular accelerations 
    % 1.3 is a dummy time for the gait cycle
    patient29_HeelStrike = 0;
    patient29_ToeOff = patient29Forces.ToeOffPercentage;
    timeForGaitCycle = 1.3;
    linearAccel = LinearAcceleration(positionArray, timeForGaitCycle);
    angularAccel = AngularAcceleration(positionArray, timeForGaitCycle);
    normCopData = NormalizeCopData(patient29CopData_Left, ...
        patient29_HeelStrike, patient29_ToeOff);
    
    % Plot the Linear Velocity and Acceleration
        %linearAccel.PlotVelocityInterpolationCurves();
        %linearAccel.PlotAccelerationCurves();
    
    % Plot the Angular Velocity and Accelerations
        %angularAccel.PlotVelocityInterpolationCurves();
        %angularAccel.PlotAccelerationCurves();
        
    % Run the gait simulation
    FourBarLinkageSim(fourBarArray);
    GaitSimulation(positionArray);
    
    InverseDynamics(model, linearAccel, angularAccel, patient29Forces, normCopData);
end

%PlotPatientGaitAngles(patient29Angles);
%PlotPatientGaitForces(patient29Forces);

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

