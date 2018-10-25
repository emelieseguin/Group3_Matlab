function Main()
    % Names of body parts
    global leftShankLength thighLength footLength;
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    % Build the anthropomtric model
    model = AnthropometricModel(120.0, 50.0);

    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    %patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
    
    
    % Build the position array from the csv file
    positionArray = [];
    for item = 1:(length(patient29Angles.LFootAngleZ))
        
        % Get the angles from the object
        foot = patient29Angles.LFootAngleZ(item);
        knee = patient29Angles.LKneeAngleZ(item);
        hip = patient29Angles.LHipAngleZ(item);
        
        % Create the position of the leg, add it to the array
        position = GaitLegPosition(model.dimensionMap(thighLength), model.dimensionMap(leftShankLength), ...
            model.dimensionMap(footLength), foot, knee, hip, model.comPercentageMap);
        positionArray = [positionArray position];
    end   
    
    %PlotPatientGaitAngles(patient29Angles); -- looks same as the old
    %people data from the power point
    
    %PlotPatientGaitForces(patient29Forces);
    
    % Plot the Linear Velocity and Accelerations
    linearAccel = LinearAcceleration(positionArray, 1.3);
    linearAccel.PlotVelocityInterpolationCurves();
    linearAccel.PlotAccelerationCurves();
    
    % Plot the Angular Velocity and Accelerations
    angularAccel = AngularAcceleration(positionArray, 1.3);
    angularAccel.PlotVelocityInterpolationCurves();
    angularAccel.PlotAccelerationCurves();
    
    % Run the gait simulation
    GaitSimulation(positionArray);
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

