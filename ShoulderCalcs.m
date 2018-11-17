function ShoulderCalcs (personHeight, maxShaftMoment, maxTorsionFromSpring, ...
    shaftDiameter, shaft)
    %% Keep for not to test read in values
    %personHeight = 1.78; %m
    maxShaftMoment = UnitConversion.NewtonM2PoundFInch(maxShaftMoment);
    %maxShaftMoment = -1.053062; %lbf in 
        %Mmax = -0.11898; %Nm
    maxTorsionFromSpring = UnitConversion.NewtonM2PoundFInch(maxTorsionFromSpring);
    %maxTorsionFromSpring = 20.188551; %lbf in
        %Tmax = 2.281; %Nm
%% Design Variables - Calcs 1
    dReal = UnitConversion.Meters2Inches(shaft.diameter3); % This is the actual small shaft diameter
    Sut = 47000; %Psi
        %Sut = 324000000; %Mpa - Aluminum
    Sy = 24500; %Psi
        %Sy = 169000000; %Mpa - Aluminum
    a = 2670; %Psi
        %a = 4.51; %Mpa
    b = -0.265; 
    kT1 = 1.7; 
    kTS1 = 1.5; 
    n = 2.1; %Design safety factor
    kb1 = 0.9; 
    D = UnitConversion.Meters2Inches(shaftDiameter); %in - Diameter of shaft where torsional spring sits

%% Calculations 1
    %First iteration of fatigue stress-concentration factor
    kF1 = kT1;
    %First iteration of fatigue shear stress-concentration factor
    kFS1 = kTS1;
    % Marin surface modification factor
    ka = a*(Sut.^b);
    %Endurance limit of rotating beam specimen
    SePrime = 0.5*Sut;
    %First iteration of endurance limit of actual machine element subjected to loading
    Se1 = ka*kb1*SePrime;
    % Alternating and midrange bending moments
    Ma = maxShaftMoment/2;
    Mm = Ma;
    %Alternating and midrange torques
    Ta = maxTorsionFromSpring/2;
    Tm = Ta;
    %Diameter of critical location - from Goodman criterion
    eqnPart1 = (4*((kF1*Ma).^2)+3*((kFS1*Ta).^2)).^(1/2);
    eqnPart2 = (4*((kF1*Mm).^2)+3*((kFS1*Tm).^2)).^(1/2);
    d = (16*n/pi)*(((1/Se1)*(eqnPart1)+(1/Sut)*(eqnPart2)).^(1/3));

    %Check D/d ratio
    if(1.02 <= D/d && D/d <= 1.5)
      disp(['D/d = ', num2str(D/d), ' -> within boundaries.']);
    else
      disp(['D/d = ', num2str(D/d), ' -> not within boundaries.']);
    end

    %Radius of curvature
    r = d*0.1;
    
    
%% Design Variables - Calcs 2
     q = 0.68;
     qS = 0.82; 
     kT = 1.7;
     kTS = 1.2;
%% Calculations 2
    %Second iteration of fatigue stress-concentration factor
        kF = 1+q*(kT-1);
    %Second iteration of fatigue shear stress-concentration factor
        kFS = 1+qS*(kTS-1);
    %Second iteration of size factor
        kb = (d/7.62).^(-0.017);
    %Second iteration of endurance limit of actual machine element subjected to loading
        Se = ka*kb*SePrime;
    %Von Mises stresses
        sigmaAPrime = (((32*kF*Ma/pi/(d.^3)).^2)+3*((16*kFS*Ta/pi/(d.^3)).^2)).^(1/2);
        sigmaMPrime = (((32*kF*Mm/pi/(d.^3)).^2)+3*((16*kFS*Tm/pi/(d.^3)).^2)).^(1/2);
    %Safety factor - using Goodman criterion
        nF = (sigmaAPrime/Se+sigmaMPrime/Sut).^(-1);
        disp(['nF = ',num2str(nF)]);
    %Check minimum d is less than design d
    if(d <= dReal)
      disp('Design is valid.');
    else
      disp('Design is not valid. Required diameter is larger than actual diameter.');
    end    
end