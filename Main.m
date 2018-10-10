function Main()
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    model = AnthropometricModel(120.0, 50.0);
    disp(model);
    
    patient29AnglesCsvFileName = 'Patient29_Normal_Walking_Angles.csv';
    patient29ForcesCsvFileName = 'Patient29_Normal_Walking_Forces.csv';
    
    % Create objects to store the gait information (angles, forces) of patient 29
    patient29Angles = GaitDataAngles(patient29AnglesCsvFileName);
    patient29Forces = GaitDataForces(patient29ForcesCsvFileName);
    
    plot(patient29Angles.time, patient29Angles.angle1);
    plot(patient29Forces.time, patient29Forces.xForces);
    disp(patient29Forces);
end