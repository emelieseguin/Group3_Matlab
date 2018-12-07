classdef PlantarSpringCalcs
    properties
        % Material Properties
        YoungsModulus = 200000000000; % Young's Modulus - Steel [Pa]
        ShearModulus = 79300000000; % Shear Modulus  - Steel
        Density = 7850; % kg/m^3
        A = 140000; % Area from Shigley table 10-4
        m = 0.19; % Constant from Shigley table 10-4
        
        % Spring dimensions
        NumberBodyTurns = 7;
        wireDiameterSpring
        meanDiameterCoil
        
        R1
        R2
        curlAngle = 330; %how "curled" in the end hooks are
        
         %% Put the Neutral of the graph
        neutralLengthIndex = 85;
        neutralLengthValue;
        
        %% Calculated Values
        k
        lengthUnstrechedSpring
        weightExtensionSpring
        extensionCableLength
        totalLengthUnstrechedSpring
        R1PlantarSpring
        dPlantarSpringWire
    end
    methods
        function  obj = PlantarSpringCalcs(personHeight, plantarSpringLengthArray)
            %% Design variables
            obj.wireDiameterSpring = 0.0025/1.78*personHeight; % Diameter of wire
            d = UnitConversion.Meters2Inches(obj.wireDiameterSpring); 
            
            obj.meanDiameterCoil = 0.025/1.78*personHeight; % Mean diameter of coil
            D = UnitConversion.Meters2Inches(obj.meanDiameterCoil); 
            
            E = UnitConversion.Pa2Psi(obj.YoungsModulus);
            G = UnitConversion.Pa2Psi(obj.ShearModulus);  
            Fi = UnitConversion.Newton2Lbf(5.29/1.78*personHeight); %Initial tension force in spring
            
            obj.R1 = obj.meanDiameterCoil/2;
            R1 = UnitConversion.Meters2Inches(obj.R1); 
            obj.R2 = obj.meanDiameterCoil/2;
            R2 = UnitConversion.Meters2Inches(obj.R2); 

            %% Length of the plantar flexion spring - find from array -- use plantarSpringLengthArray
            maxLength = max(plantarSpringLengthArray);
            minLength = min(plantarSpringLengthArray);
            % Position where the second highest peek occurs -- will need to change 
            % if the placement of pulleys changes
            neutralLength = plantarSpringLengthArray(obj.neutralLengthIndex);
            obj.neutralLengthValue = neutralLength;

            LtotO = UnitConversion.Meters2Inches(neutralLength);

            %Bring in y value [m]
            Lmax = UnitConversion.Meters2Inches(maxLength);
            y = Lmax-LtotO;

            %% Calculations
            %Calculate number of active turns
            Na = obj.NumberBodyTurns+(G/E);
            %Calculate the linear spring constant
            k = (d.^4)*(G)/(8*(D.^3)*Na);
            %Calculate spring index
            c = D/d;
            %Calculate original spring length
            Lo = (2*c-1+obj.NumberBodyTurns)*d;
            %Calculate new spring length
            L = Lo + y;
            %Calculate cable length
            CL = LtotO-(Lo+4*R1);
            %Calculate Bergstrasser factor
            Kb = (4*c+2)/(4*c-3);
            %Calculate maximum force applied
            Fmax = Fi + k*y;
            %Minimum force
            Fmin = Fi;
            %Calculate cyclic force amplitude
            Fa = (Fmax-Fmin)/2;
            %Calculate cyclic force mean
            Fm = (Fmax+Fmin)/2;
            %Calculate shear stress amplitude
            TauA = 8*Kb*Fa*D/(pi*(d.^3));
            %Calculate shear stress mean
            TauM = Fm/Fa*TauA;    
            %Calculate Ultimate strength 
            Sut = obj.A/(d.^obj.m); 
            %Calculate Ssy - eq'n from Shigley table 10-7
            Ssy = 0.45*Sut;
            %Calculate Sy - eq'n from Shigley table 10-7
            Sy = 0.75*Sut;
            %Calculate ultimate shear strength Ssu
            Ssu = 0.67*Sut;

            Ssa = UnitConversion.Pa2Psi(241000000); %[Pa] from Zimmerli data  
            Ssm = UnitConversion.Pa2Psi(379000000); %[Pa] from Zimmerli data

            %CASE 1 ANALYSIS - Coil fatigue failure

                %Get modified endurance limit
                Sse = (Ssa)/(1-((Ssm/Ssu).^2));
            nCase1 = (1/2)*((Ssu/TauM).^2)*(TauA/Sse)*(-1+((1+(((2*TauM*Sse)/(Ssu*TauA)).^2)).^(1/2)));

            %CASE 2 ANALYSIS - Coil yielding failure  
                %Get torsional stress caused by initial tension
                 TauI = 8*Kb*Fi*D/(pi*(d.^3));

                 r = TauA/(TauM-TauI);
                 Ssay = (r/(r+1))*(Ssy-TauI);
                 nCase2 = Ssay/TauA;

            %CASE 3 ANALYSIS - End-hook bending fatigue failure (at location A)
            c1 = 2*R1/d;
            kA = (4*(c1.^2)-c1-1)/(4*c1*(c1-1));
            SigmaA = Fa*(kA*((16*D)/(pi*(d.^3)))+(4/(pi*(d.^2))));
            SigmaM = Fm/Fa*SigmaA;
            Se = Sse/0.577;
            nCase3 = (1/2)*((Sut/SigmaM).^2)*(SigmaA/Se)*(-1+((1+(((2*SigmaM*Se)/(Sut*SigmaA)).^2)).^(1/2)));

            %CASE 4 ANALYSIS - End-hook torsional fatigue failure (at location B)
            c2 = 2*R2/d;
            kB = (4*c2-1)/(4*c2-4);
            TauAB = Fa*kB*8*D/(pi*(d.^3));
            TauMB = Fm/Fa*TauAB;
            nCase4 = (1/2)*((Ssu/TauMB).^2)*(TauAB/Sse)*(-1+((1+(((2*TauMB*Sse)/(Ssu*TauAB)).^2)).^(1/2)));

            %convert variables to SI units
            D = round(UnitConversion.Inches2Meters(D),6);
            d = UnitConversion.Inches2Meters(d); 
            E = UnitConversion.Psi2Pa(E); 
            G = UnitConversion.Psi2Pa(G);
            R1 = UnitConversion.Inches2Meters(R1); 
            R2 = UnitConversion.Inches2Meters(R2); 
            Fi = UnitConversion.Lbf2Newton(Fi); 
            Lo = UnitConversion.Inches2Meters(Lo);
            obj.lengthUnstrechedSpring = Lo;
            obj.totalLengthUnstrechedSpring = Lo + 4*R1;
            
            L = UnitConversion.Inches2Meters(L);
            y = UnitConversion.Inches2Meters(y);
            k = UnitConversion.PoundFperInch2NewtonperMeter(k);
            obj.k = k; % Set k in SI units
            Lmax = UnitConversion.Inches2Meters(Lmax);
            LtotO = UnitConversion.Inches2Meters(LtotO);
            CL = UnitConversion.Inches2Meters(CL);
            Fmax = UnitConversion.Lbf2Newton(Fmax);
            Fmin = UnitConversion.Lbf2Newton(Fmin);
            Fa = UnitConversion.Lbf2Newton(Fa);
            Fm = UnitConversion.Lbf2Newton(Fm);
            TauA = UnitConversion.Psi2Pa(TauA);
            TauM = UnitConversion.Psi2Pa(TauM);  
            Sut = UnitConversion.Psi2Pa(Sut);
            Ssy = UnitConversion.Psi2Pa(Ssy);
            Sy = UnitConversion.Psi2Pa(Sy);
            Ssu = UnitConversion.Psi2Pa(Ssu);
            Ssa = UnitConversion.Psi2Pa(Ssa);
            Ssm = UnitConversion.Psi2Pa(Ssm);
            Sse = UnitConversion.Psi2Pa(Sse);    
            TauI = UnitConversion.Psi2Pa(TauI);
            Ssay = UnitConversion.Psi2Pa(Ssay);
            SigmaA = UnitConversion.Psi2Pa(SigmaA);
            SigmaM = UnitConversion.Psi2Pa(SigmaM);
            Se = UnitConversion.Psi2Pa(Se);
            TauAB = UnitConversion.Psi2Pa(TauAB);
            TauMB = UnitConversion.Psi2Pa(TauMB);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\plantarSpringDimensions.txt','w');
                fprintf(fileID, '"dPlantarSpringCoil"= %7.7f\n', D);
                fprintf(fileID, '"dPlantarSpringWire"= %f\n', d);
                fprintf(fileID, '"r1PlantarSpring"= %7.7f\n', D/2);
                fprintf(fileID, '"r2PlantarSpring"= %7.7f\n', D/2);
                fprintf(fileID, '"LoPlantarSpring"= %f\n', Lo);
                fprintf(fileID, '"numBodyTurnsPlantarSpring"= %f\n', obj.NumberBodyTurns);
           fclose(fileID);

            obj.weightExtensionSpring = GetWeightExtension(obj, R1);
            obj.extensionCableLength = CL;
            obj.R1PlantarSpring = D/2;
            obj.dPlantarSpringWire = d;
            global logFilePath;
            logFile = fopen(logFilePath, 'a+');
                fprintf(logFile, '\n\n****   Plantarflexion Extension Spring  ****\n\n');
                fprintf(logFile, '    Wire Diameter = %4.4f m\n', round(obj.wireDiameterSpring, 4));
                fprintf(logFile, '    Mean Coil Diameter = %4.4f m\n', round(obj.meanDiameterCoil,4));
                fprintf(logFile, '    Spring Index = %4.2f\n', round(c,2));
                fprintf(logFile, '    Number of Body Turns = %4.1f\n', round(obj.NumberBodyTurns,1));
                fprintf(logFile, '    Mass of Spring = %4.4f kg\n\n', round(obj.weightExtensionSpring,4));
                fprintf(logFile, '    Safety Factors:\n');
                fprintf(logFile, '        Case 1 = %3.2f\n', round(nCase1,2));
                fprintf(logFile, '        Case 2 = %3.2f\n', round(nCase2,2));
                fprintf(logFile, '        Case 3 = %3.2f\n', round(nCase3,2));
                fprintf(logFile, '        Case 4 = %3.2f\n', round(nCase4,2));
                fprintf(logFile, '\n');
                fprintf(logFile, '    Plantarflexion Cable Length = %4.4f m\n', round(obj.extensionCableLength,4));
            fclose(logFile);
        end 
        
        function MomentSI = GetMomentContribution(obj, currentSpringCableLength, ...
                currentPlantarFlexionSpringPosition, maxPlantarLength, maxValueIndex, i)
            %% Current Position Moment
            yCurrent = (currentSpringCableLength-obj.extensionCableLength-(obj.lengthUnstrechedSpring + (4*obj.R1)));
            % Negative values are the distances being picked up by the cam - slack region
            
            if(yCurrent > 0)
                
                if(maxValueIndex < i)
                    
                    % Spring pulling toe
                    yMax = (maxPlantarLength-obj.extensionCableLength-(obj.lengthUnstrechedSpring + (4*obj.R1)));
                    yCurrent = yCurrent-yMax;
                end 
                
                
                currentFy = obj.k*yCurrent*sin(deg2rad(currentPlantarFlexionSpringPosition.AppliedHeelCableForceAngle));
                currentFx = obj.k*yCurrent*cos(deg2rad(currentPlantarFlexionSpringPosition.AppliedHeelCableForceAngle));
                currentMoment = currentFy*currentPlantarFlexionSpringPosition.distanceFromAnkle2LowAttachmentX + currentFx*currentPlantarFlexionSpringPosition.distanceFromAnkle2LowAttachmentY;            

                %% Next Moment
                MomentSI = (-1)*currentMoment;%nextMoment - currentMoment;
            else
                MomentSI = 0;
            end
        end
        
        function weight = GetWeightExtension(obj, R1)
            V = ((pi*(obj.wireDiameterSpring.^2))/4)*(obj.NumberBodyTurns+2*deg2rad(obj.curlAngle)*R1);%Units in meters and rads
            weight = V*obj.Density; %Units in Kg
        end 
    end
end


