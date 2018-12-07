function ShoulderCalcs (personHeight, maxShaftMoment, maxTorsionFromSpring, ...
    shaftDiameter, shaft)
    maxShaftMoment = UnitConversion.NewtonM2PoundFInch(maxShaftMoment);
    maxTorsionFromSpring = UnitConversion.NewtonM2PoundFInch(maxTorsionFromSpring);

%% Design Variables - Calcs 1
    d = UnitConversion.Meters2Inches(shaft.diameter3);
    Sut = 47000; %Psi
    Sy = 24500; %Psi
    a = 2670; %Psi
    b = -0.265; 
    kT1 = 1.7; 
    kTS1 = 1.5; 
    kb1 = 0.9; 
    D = UnitConversion.Meters2Inches(shaftDiameter); % Diameter of shaft where torsional spring sits

%% Calculations 1
    % First iteration of fatigue stress-concentration factor
    kF1 = kT1;
    % First iteration of fatigue shear stress-concentration factor
    kFS1 = kTS1;
    % Marin surface modification factor
    ka = a*(Sut.^b);
    % Endurance limit of rotating beam specimen
    SePrime = 0.5*Sut;
    % First iteration of endurance limit of actual machine element subjected to loading
    Se1 = ka*kb1*SePrime;
    % Alternating and midrange bending moments
    Ma = abs(maxShaftMoment/2);
    Mm = Ma;
    % Alternating and midrange torques
    Ta = abs(maxTorsionFromSpring/2);
    Tm = Ta;
    % Diameter of critical location - from Goodman criterion
    eqnPart1 = (4*((kF1*Ma).^2)+3*((kFS1*Ta).^2)).^(1/2);
    eqnPart2 = (4*((kF1*Mm).^2)+3*((kFS1*Tm).^2)).^(1/2);
    dmin = (16/pi)*(((1/Se1)*(eqnPart1)+(1/Sut)*(eqnPart2)).^(1/3));
    
    %Check D/d ratio
    check1String = '';
    if(1.02 <= D/d && D/d <= 1.5)
      check1String = ['D/d = ', num2str(D/d), ' -> within boundaries.'];
    else
      check1String = ['D/d = ', num2str(D/d), ' -> not within boundaries.'];
    end

    %Radius of curvature
    r = d*0.1;
    
    
%% Design Variables - Calcs 2
     q = 0.68;
     qS = 0.82; 
     kT = 1.7;
     kTS = 1.2;
%% Calculations 2
    % Second iteration of fatigue stress-concentration factor
        kF = 1+q*(kT-1);
    % Second iteration of fatigue shear stress-concentration factor
        kFS = 1+qS*(kTS-1);
    % Second iteration of size factor
        kb = (d/7.62).^(-0.017);
    % Second iteration of endurance limit of actual machine element subjected to loading
        Se = ka*kb*SePrime;
    % Von Mises stresses
        sigmaAPrime = (((32*kF*Ma/pi/(d.^3)).^2)+3*((16*kFS*Ta/pi/(d.^3)).^2)).^(1/2);
        sigmaMPrime = (((32*kF*Mm/pi/(d.^3)).^2)+3*((16*kFS*Tm/pi/(d.^3)).^2)).^(1/2);
    % Safety factor - using Goodman criterion
        nF = (sigmaAPrime/Se+sigmaMPrime/Sut).^(-1);
        
    % Check minimum d is less than design d
    check2String = '';
    if(dmin <= d)
      check2String = 'Design is valid. Actual diameter is larger than required diameter.';
    else
      check2String = 'Design is not valid. Required diameter is larger than actual diameter.';
    end    
    
    global logFilePath;
    logFile = fopen(logFilePath, 'a+');
        fprintf(logFile, '\n\n****   Hip Shaft Shoulders  ****\n\n');
        fprintf(logFile, '    Radius of Shoulder Fillet = %4.4f m\n', round(r, 4));
        fprintf(logFile, '    Safety Factor = %3.2f\n', round(nF, 2));
        fprintf(logFile, '    Shaft Requirement Checks:\n');
        fprintf(logFile, ['        Check 1: ', check1String,'\n']);
        fprintf(logFile, ['        Check 2: ', check2String ,' \n']);
    fclose(logFile);
end