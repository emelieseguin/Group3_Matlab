function SetAnthropometricNames()
    
    %% Global variables names set to be used for anthropometric model
    % Foot Dimensions Naming
    global footWidth footLength footHeight toeLength;
    footWidth = 'Foot Width';
    footLength = 'Foot Length';
    footHeight = 'Foot Height'; 
    toeLength = 'Toe Length';
    
    % Ankle Dimensions
    global heelToAnkle;
    heelToAnkle = 'Heel To Ankle';
    
    % Leg Dimensions Naming
    global rightShankLength leftShankLength;
    rightShankLength = 'Right Shank';
    leftShankLength = 'Left Shank';
    
    % Thigh Dimensions Naming
    global thighLength;
    thighLength = 'Thigh Length';
    
    % Foot Segment Weight Naming
    global footSegmentWeight;
    footSegmentWeight = 'Foot Segment Weight';
    
    % Leg Segment Weight Naming
    global legSegmentWeight;
    legSegmentWeight = 'Leg Segment Weight';
    
    % Thigh Segment Weight Naming
    global thighSegmentWeight;
    thighSegmentWeight = 'Thigh Segment Weight';
    
    % Foot and Leg Segment Weight Naming
    global footAndLegSegmentWeight;
    footAndLegSegmentWeight = 'Foot and Leg Segment Weight';
    
    % Total Leg Segment Weight Naming
    global totalLegSegmentWeight;
    totalLegSegmentWeight = 'Total Leg Segment Weight';
    
    % Abdomen Segment Weight Naming
    global abdomenSegmentWeight;
    abdomenSegmentWeight = 'Abdomen Segment Weight';
    
    % Pelvis Segment Weight Naming
    global pelvisSegmentWeight;
    pelvisSegmentWeight = 'Pelvis Segment Weight';
    
    % Abdomen and Pelvis Segment Weight Naming
    global abdomenAndPelvisSegmentWeight;
    abdomenAndPelvisSegmentWeight = 'Abdomen and Pelvis Segment Weight';
    
    % Centre of Mass Locations from Proximal End of Joint
    global pFootCOMx pFootCOMy pShankCOM pThighCOM pFootAndLegCOM pTotalLegCOM;
    global pAbdomenCOM pPelvisCOM pAbdomenAndPelvisCOM;
    
    pFootCOMx = 'Foot Center of Mass Location in X';
    pFootCOMy = 'Foot Center of Mass Location in Y';
    pShankCOM = 'Leg Center of Mass Location';
    pThighCOM = 'Thigh Center of Mass Location';
    pFootAndLegCOM = 'Foot and Leg Center of Mass Location';
    pTotalLegCOM = 'Total Leg Center of Mass Location';
    pAbdomenCOM = 'Abdomen Center of Mass Location';
    pPelvisCOM = 'Pelvis Center of Mass Location';
    pAbdomenAndPelvisCOM = 'Abdomen and Pelvis Center of Mass Location';
    
end