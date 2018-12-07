function HipShaftBendingMomentAnalysis(maxBendingMoment, hipShaft, ...
    momentFromTorsionSpring)

    shaftDiameter = hipShaft.dp3;
    lShaftKeyHip = hipShaft.lShaftKeyHip;
    wShaftKeyHip = hipShaft.wShaftKeyHip;
    hShaftKeyHip = hipShaft.hShaftKeyHip;
    YieldStrengthAl = 169000000;
    
    %% Shaft safety factor
    
    MinShaftRad = ((((4*maxBendingMoment) + (2*sqrt(3)*momentFromTorsionSpring))/(YieldStrengthAl*pi))^(1/3));
    MinShaftDiameter = 2*MinShaftRad;
    
    % Safety Factor of the shaft 
    ShaftSafetyFactor = shaftDiameter/MinShaftDiameter;
    
    %% Keyway safety factor
    ForceOnKey = momentFromTorsionSpring/shaftDiameter;
    SsyAl = 0.577*YieldStrengthAl;
    KeySafetyFactor = (SsyAl*wShaftKeyHip*lShaftKeyHip)/ForceOnKey;
    
    global logFilePath;
    logFile = fopen(logFilePath, 'a+');
        fprintf(logFile, '\n\n****   Hip Shaft Bending Moment Validation  ****\n\n');
        fprintf(logFile, '    Radius at Maximum Moment = %4.4f m\n', round(shaftDiameter, 4));
        fprintf(logFile, '    Minumum Diameter of Shaft = %4.4f m\n', round(MinShaftDiameter, 4));
        fprintf(logFile, '    Safety Factor = %3.2f\n', round(ShaftSafetyFactor, 2));
        
        
        fprintf(logFile, '\n\n****   Hip Shaft Key Validation  ****\n\n');
        fprintf(logFile, '    Key Dimensions:\n');
        fprintf(logFile, '         Length = %3.4fm\n', round(lShaftKeyHip, 4));
        fprintf(logFile, '         Width = %3.4fm\n', round(wShaftKeyHip, 4));
        fprintf(logFile, '         Height = %3.4fm\n', round(hShaftKeyHip, 4));
        fprintf(logFile, '    Force on Key = %3.4fN\n', round(ForceOnKey, 4));
        fprintf(logFile, '    Safety Factor = %3.2f\n', round(KeySafetyFactor, 2));      
    fclose(logFile); 
end