function ShearForceOnPins(personHeight, massOnThePins)
%Pin diameter
    dPin = 0.0055/1.78*personHeight;
%Shear yield stress of pin  - HDPE
    tauY = 33100000; %Pa
    
%Weight of bottom components
    wBot = 9.81*massOnThePins;
%Shear stress on one pin
    tau = wBot/(pi*dPin^2);
%Safety factor
    n = tauY/tau;

    global logFilePath;
    logFile = fopen(logFilePath, 'a+');
        fprintf(logFile, '\n\n****   Four-Bar Pins  ****\n\n');
        fprintf(logFile, '    Pin Diameter = %4.4f m\n', round(dPin, 4));
        fprintf(logFile, '    Total Weight on Pins = %4.2f N\n', round(wBot, 2));
        fprintf(logFile, '    Safety Factor: %3.2f\n', round(n, 2));
    fclose(logFile);
end