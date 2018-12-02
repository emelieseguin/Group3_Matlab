function HipJointBearingCalcs(fRadial, fThrust, thighAngularVelocity, patientHeight)

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
    
    %% Parametrized Geometry
    ballDiameter = (0.00576114/2.78)*patientHeight;
    innerLargeRingDiameter = (0.045183/1.78)*patientHeight;
    innerSmallRingDiameter = (0.029527/1.78)*patientHeight;
    
    %% Determining fEquivalent based on fRadial and fThrust
    if ((fThrust/fRadial)<=0.35)
        fEquivalent = fRadial;
    elseif ((fThrust/fRadial)>0.35 && (fThrust/fRadial)<10)
        fEquivalent = fRadial * ((1+1.115)*((fThrust/fRadial)-0.35));
    elseif ((fThrust/fRadial)>=10)
        fEquivalent = 1.176*fThrust;

    %% Rated Capacity Calculations
    requiredC = fEquivalent*Ka*((life/(Kr*Lr))^0.3);
    
    dm = (innerLargeRingDiameter+innerSmallRingDiameter)/2;
    fc = (ballDiameter*cos(alpha))/dm;

    calcC = fc*((i*cos(alpha))^0.7)*(Z^(2/3))*(ballDiameter^1.8);

    %% Bearing Life Calculations
    L10 = (calcC/fRadial); %rating life - life at which 10 percent of bearings have failed and 90 percent of them are still good. 

    radialLoadLife = Kr*Lr*((calcC/(fEquivalent*Ka))^3.33);
    
    %% Petroff's Equation
    frictionCoefficient = 2*(pi^2)*((dynamicViscosity*shaftRPM)/(fRadial/(shaftRadius*bearingLength)))*(shaftRadius/radialClearance);

    %% Friction Torque
    frictionTorque = frictionCoefficient*fRadial*shaftRadius;

    %% Energy Lost due to Friction
    energyLoss = ((2*pi*shaftRPM)/60)*frictionTorque;

end