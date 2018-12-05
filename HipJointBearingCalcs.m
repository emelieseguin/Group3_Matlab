function HipJointBearingCalcs(fRadial, thighAngularVelocity, patientHeight)

    %% Initial Constants
    shaftRPM = thighAngularVelocity * 9.5493; %converting rads/sec to rpm
    Ka = 1.5; %Light impact application, picked value at top of range for safety
    designLife = 40000; %Inbetween 8-hour service every working day (30000 hours) and continuous 24-hour service (50000 hours)
    life = shaftRPM*designLife*60;
    Kr = 1; %from standard 90% reliability
    Lr = (9.6)*10^6; %life corresponding to rated capacity
    i = 1.0; %number of rows of balls in bearing, should be constant
    alpha = 0; %nominal contact angle of the balls, is 0 for radial bearings, should be constant
    Z = 12; %number of balls per row, shoud be constant
    dynamicViscosity = 50;
    
    %% Parametrized Geometry
    ballDiameter = (0.00576114/2.78)*patientHeight;
    innerLargeRingDiameter = (0.04455384/1.78)*patientHeight;
    innerSmallRingDiameter = (0.02952028/1.78)*patientHeight;
    bearingLength = (0.009525/1.78)*patientHeight;
    radialClearance = (0.0000075/1.78)*patientHeight;
    shaftRadius = (0.0142875/1.78)*patientHeight;

    %% Rated Capacity Calculations
    requiredC = fRadial*Ka*((life/(Kr*Lr))^0.3);
    
    dm = (innerLargeRingDiameter+innerSmallRingDiameter)/2;
    fc = (ballDiameter*cos(alpha))/dm;

    calcC = fc*((i*cos(alpha))^0.7)*(Z^(2/3))*(ballDiameter^1.8);

    %% Bearing Life Calculations
    L10 = (calcC/fRadial); %rating life - life at which 10 percent of bearings have failed and 90 percent of them are still good. 

    radialLoadLife = Kr*Lr*((calcC/(fRadial*Ka))^3.33);
    
    %% Petroff's Equation
    frictionCoefficient = 2*(pi^2)*((dynamicViscosity*shaftRPM)/(fRadial/(shaftRadius*bearingLength)))*(shaftRadius/radialClearance);

    %% Friction Torque
    frictionTorque = frictionCoefficient*fRadial*shaftRadius;

    %% Energy Lost due to Friction
    energyLoss = ((2*pi*shaftRPM)/60)*frictionTorque;

end