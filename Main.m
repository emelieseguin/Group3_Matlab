function Main()
    
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    model = AnthropometricModel(120.0, 50.0);

    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    %patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
    
    %PlotPatientGaitAngles(patient29Angles);
    %PlotPatientGaitForces(patient29Forces);
    GaitSimulation(model, patient29Angles);
end

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

