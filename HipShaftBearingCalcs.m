function HipShaftBearingCalcs(fRadial, thighAngularVelocity, patientHeight)

    %% Initial Constants
    shaftRPM = thighAngularVelocity * (60/(2*pi)); %converting rads/sec to rpm
    Ka = 1.5; %Light impact application, picked value at top of range for safety
    designLife = 40000; %Inbetween 8-hour service every working day (30000 hours) and continuous 24-hour service (50000 hours)
    life = shaftRPM*designLife*60;
    Kr = 1; %from standard 90% reliability
    Lr = (9.6)*10^6; %life corresponding to rated capacity
    i = 1.0; %number of rows of balls in bearing, should be constant
    alpha = 0; %nominal contact angle of the balls, is 0 for radial bearings, should be constant
    Z = 12; %number of balls per row, shoud be constant
    dynamicViscosity = 50/1000; %the dynamic viscosity of the oil in the bearing in Pa*s
    
    
    %% Parametrized Geometry
    ballDiameter = (0.00576114/1.78)*patientHeight;
    ballDiameterImperial = ballDiameter*39.3701;
    innerSmallRingDiameter = (0.015912/1.78)*patientHeight;
    innerLargeRingDiameter = (0.0383755/1.78)*patientHeight;
    bearingLength = (0.01/1.78)*patientHeight;
    radialClearance = (0.0000075/1.78)*patientHeight;
    shaftRadius = (0.00748/1.78)*patientHeight;
    
    %% Rated Capacity Calculations
    requiredC = (fRadial/1000)*Ka*((life/(Kr*Lr))^(0.3)); % answer is in kN
    
    dm = ((innerLargeRingDiameter+innerSmallRingDiameter)/2);
    fc = (4530/1.78)*patientHeight;

    calcCImperial = fc*((i*cos(alpha))^0.7)*(Z^(2/3))*(ballDiameterImperial^1.8);
    calcC = (calcCImperial*4.45)/1000; % answer is in kN

    %% Bearing Life Calculations
    L10 = (calcC/(fRadial/100)); %rating life - life at which 10 percent of bearings have failed and 90 percent of them are still good. 

    radialLoadLife = ((Kr*Lr*((calcC/((fRadial/1000)*Ka))^3.33))/shaftRPM)/60; %answer is in hours
    
    %% Petroff's Equation
    frictionCoefficient = 2*(pi^2)*((dynamicViscosity*shaftRPM)/(fRadial/(2*shaftRadius*bearingLength)))*(shaftRadius/radialClearance);

    %% Friction Torque
    frictionTorque = frictionCoefficient*fRadial*shaftRadius;

    %% Energy Lost due to Friction
    energyLoss = ((2*pi*shaftRPM)/60)*frictionTorque;

end