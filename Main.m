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
    
    % Run the gait simulation
    GaitSimulation(positionArray);
end


%PlotPatientGaitAngles(patient29Angles);
%PlotPatientGaitForces(patient29Forces);

function PlotPatientGaitAngles(patientAngles)
    figure
    % Graph number 1
    topLeft = subplot(1,3,1);
    plot(topLeft, patientAngles.Time, patientAngles.LFootAngleX);
    title(topLeft,'Left Foot Angle X');
    %topLeft.FontSize = 14;
    
    topModel = subplot(1,3,2);
    plot(topModel, patientAngles.Time, patientAngles.LFootAngleY);
    title(topModel,'Left Foot Angle Y');
    grid(topModel,'on');
    
    topModel = subplot(1,3,3);
    scatter(topModel, patientAngles.Time, patientAngles.LFootAngleZ);
    title(topModel,'Left Foot Angle Z');
    grid(topModel,'on');
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

