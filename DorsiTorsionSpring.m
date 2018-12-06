classdef DorsiTorsionSpring
    properties
        % Material Properties of the Spring - Hard Drawn Steel
        YoungsModulus = 200000000000; % Young's Modulus [Pa]
        Density = 7850; % kg/m^3
        A = 140000; % Area from Shigley table 10-4
        m = 0.19; % Constant from Shigley table 10-4
        
        % Spring dimensions
        NumberBodyTurns = 3.5; % least amount possible
        wireDiameterSpring
        meanDiameterCoil
        
        lengthSupportLeg
        lengthWorkingLeg
        
        % Additional Torque
        additionalTorquePercentage = 0.20;
        
        % Moment Contribution
        firstValueIndex
        neutralValueIndex
        min1ValueIndex
        max2ValueIndex
        min2ValueIndex
        max3ValueIndex
        min3ValueIndex
        
        firstValue
        neutralValue
        min1Value
        max2Value
        min2Value
        max3Value
        min3Value
        
        rCam
        S
        wDorsiPull
        effectiveWDorsiPull
        
         %% Param Variables
        diameterNeededForShaft
        originalLengthOfSpringOnShaft
        
        % Values to return
        weightDorsiTorsionSpring
    end
    methods
        function obj = DorsiTorsionSpring(patientHeight, mDorsiPull, ...
                                    dorsiSpringLengthArray) 
            %% Values to pull for moment contribution
            obj.firstValueIndex = 1;
            obj.neutralValueIndex = 9; 
            obj.min1ValueIndex = 48;
            obj.max2ValueIndex = 65;
            obj.min2ValueIndex = 88;
            obj.max3ValueIndex = 90;
            obj.min3ValueIndex = 100;
            
            obj.firstValue = dorsiSpringLengthArray(obj.firstValueIndex);
            obj.neutralValue = dorsiSpringLengthArray(obj.neutralValueIndex);
            obj.min1Value = dorsiSpringLengthArray(obj.min1ValueIndex);
            obj.max2Value = dorsiSpringLengthArray(obj.max2ValueIndex);
            obj.min2Value = dorsiSpringLengthArray(obj.min2ValueIndex);
            obj.max3Value = dorsiSpringLengthArray(obj.max3ValueIndex);
            obj.min3Value = dorsiSpringLengthArray(obj.min3ValueIndex);
            
            
            %% Set Design Variables
            %Rotation of cam
             camRotation = pi; %[rad]
             
             rCam = (obj.neutralValue - obj.min1Value)/pi;
             obj.rCam = rCam;
             S = rCam; %Vertical translation of cam-cable attachment point for one cam rotation
             obj.S = S;
             obj.wireDiameterSpring = (0.0011/1.78)*patientHeight; % Diameter of wire[m]
             d = UnitConversion.Meters2Inches(obj.wireDiameterSpring);

             obj.meanDiameterCoil = (0.013/1.78)*patientHeight; % Mean diameter of coil[m]  
             D = UnitConversion.Meters2Inches(obj.meanDiameterCoil);  
             % MUST HAVE D>(Dp+Delta+d) 
             E = UnitConversion.Pa2Psi(obj.YoungsModulus); % Young's Modulus [Pa]
             Delta = UnitConversion.Meters2Inches(0.00005/1.78*patientHeight); % Diametral clearance [m] 

             obj.lengthWorkingLeg = 0.0105/1.78*patientHeight; % Length of working leg [m]
             Lwork = UnitConversion.Meters2Inches(obj.lengthWorkingLeg);

             obj.lengthSupportLeg = 0.0105/1.78*patientHeight; % Length of supporting leg [m] 
             Lsupp = UnitConversion.Meters2Inches(obj.lengthSupportLeg); 
            %% Calculations
            %Calculate weight of cable
                wDorsiPull = mDorsiPull*9.81; %[N]
                obj.wDorsiPull = wDorsiPull;
                effectiveWDorsiPull = wDorsiPull * (1 + obj.additionalTorquePercentage);
                obj.effectiveWDorsiPull = effectiveWDorsiPull;
            %Required torque on cam to lift the string:
                T = effectiveWDorsiPull*S/camRotation; %[Nm]
                Mmax = UnitConversion.NewtonM2PoundFInch(T); %[lbf in]
            %Calculate spring index 
                c = D/d;        
            %Calculate factor for inner surface stress concentration     
                Ki = ((4*(c.^2))-c-1)/(4*c*(c-1));             
            %Deflection of body coils
                ThetaCPrime = Mmax*((10.8*D*obj.NumberBodyTurns)/((d.^4)*E));
            %New mean diameter of coil
                DPrime = (obj.NumberBodyTurns*D)/(ThetaCPrime+obj.NumberBodyTurns);
            %Shaft diameter    
                Dp = DPrime - Delta - d;
            %Moment amplitude
                Ma = Mmax/2;
            %Stress
                SigmaA = (32*Ki*Ma)/(pi*(d.^3));    
            %Find Ultimate strength 
                Sut = obj.A/(d.^obj.m);
            %Find Sr 
                Sr = 0.5*Sut;        
            %Find Se 
                 Se = (Sr/2)/(1-(((Sr/2)/Sut).^2)); 
            %Find Sa 
                Sa = ((Sut.^2)/(2*Se))*(-1+((1+((2*Se/Sut)^.2)).^(1/2))); 
            %Calculate original length of spring [m] 
                L = d*(obj.NumberBodyTurns+1); 
            %Calculate new length of spring [m] 
                LPrime = d*(obj.NumberBodyTurns+1+ThetaCPrime); 
            %Check safety factor
                n = Sa/SigmaA; 

           %convert variables to SI units
            D = UnitConversion.Inches2Meters(D); 
            d = UnitConversion.Inches2Meters(d); 
            E = UnitConversion.Psi2Pa(E); 
            Lwork = UnitConversion.Inches2Meters(Lwork); 
            Lsupp = UnitConversion.Inches2Meters(Lsupp);    
            L = UnitConversion.Inches2Meters(L);
            obj.originalLengthOfSpringOnShaft = L;
            LPrime = UnitConversion.Inches2Meters(LPrime);
            Delta = UnitConversion.Inches2Meters(Delta);
            DPrime = UnitConversion.Inches2Meters(DPrime);
            Dp = UnitConversion.Inches2Meters(Dp);
            obj.diameterNeededForShaft = Dp;
            Mmax = UnitConversion.PoundFInch2NewtonM(Mmax);
            SigmaA = UnitConversion.Psi2Pa(SigmaA);
            Sut = UnitConversion.Psi2Pa(Sut);
            Sr = UnitConversion.Psi2Pa(Sr);      
            Se = UnitConversion.Psi2Pa(Se);
            Sa = UnitConversion.Psi2Pa(Sa);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\dorsiTorsionSpringDimensions.txt', 'w');
                fprintf(fileID, '"dDorsiTorsionSpringCoil" = %f\n', D);
                fprintf(fileID, '"dDorsiTorsionSpringWire" = %f\n', d);
                fprintf(fileID, '"shaftRadius"= %f\n', Dp/2);
                fprintf(fileID, '"LoDorsiTorsionSpring" = %f\n', L);
                fprintf(fileID, '"numBodyTurnsDorsiTorsionSpring" = %f\n', obj.NumberBodyTurns);
                fprintf(fileID, '"LWorkDorsiTorsionSpring" = %f\n', Lwork);
                fprintf(fileID, '"LSuppDorsiTorsionSpring" = %f\n', Lsupp);
            fclose(fileID);
            obj.weightDorsiTorsionSpring = obj.GetWeightTorsion(Lwork, Lsupp);
            
            global logFilePath;
            logFile = fopen(logFilePath, 'a+');
                fprintf(logFile, '\n\n****   Dorsiflexion Cam Spring  ****\n\n');
                fprintf(logFile, '    Wire Diameter = %4.4f m\n', round(obj.wireDiameterSpring, 4));
                fprintf(logFile, '    Mean Coil Diameter = %4.4f m\n', round(obj.meanDiameterCoil,4));
                fprintf(logFile, '    Spring Index = %4.2f\n', round(c,2));
                fprintf(logFile, '    Number of Body Turns = %4.1f\n', round(obj.NumberBodyTurns,1));
                fprintf(logFile, '    Mass of Spring = %4.4f kg\n\n', round(obj.weightDorsiTorsionSpring,4));
                fprintf(logFile, '    Safety Factor = %3.2f\n', n);
                fprintf(logFile, '\n');
            fclose(logFile);
        end
        
        function MomentSI = GetMomentOnCam(obj, currentSpringCableLength, previousSpringCableLength, extensionCableLength, ...
                lengthUnstrechedSpring, R1, i)
            %% Current Position Moment
            yCurrent = (currentSpringCableLength-extensionCableLength-(obj.neutralValue + (4*R1)));
            MomentSI = 0;
            angleCurrent = (obj.neutralValue - currentSpringCableLength)/obj.rCam;
            angleLast = (obj.neutralValue - previousSpringCableLength)/obj.rCam;
            
            %% Find Si
            Si = obj.rCam*(sin(angleCurrent) - sin(angleLast));
            
            % Check negative cases
            if((angleCurrent>pi/2) && (angleLast>pi/2) || ...
            (angleCurrent > pi/2)&&(angleLast<pi/2)&& (sin(angleLast) > sin(angleCurrent)) || ...
            ((angleCurrent < pi/2)&&(angleLast>pi/2) && (sin(angleCurrent) > sin(angleLast))))
                Si = Si*(-1);
            end
            
            %% Find angle
            if (yCurrent < 0)
                angle = (obj.neutralValue-currentSpringCableLength)/obj.rCam;
                
                %Section A
                if (i <= obj.neutralValueIndex)
                    angleFirst = (obj.neutralValue-obj.firstValue)/obj.rCam;
                    angleI = angleFirst - angle; 
                end
                %Section B
                if ((obj.neutralValueIndex < i) && (i <= obj.min1ValueIndex))
                    angleI = (-1)*angle;
                end
                %Section C
                if ((obj.min1ValueIndex < i) && (i <= obj.max2ValueIndex))
                    angleI = (pi/2) - angle;
                end
                %Section D
                if ((obj.max2ValueIndex < i) && (i <= obj.min2ValueIndex))
                    angleI = (-1)*angle;
                end
                %Section E
                if ((obj.min2ValueIndex < i) && (i <= obj.max3ValueIndex))
                    angleMin2 = (obj.neutralValue-obj.min2Value)/obj.rCam;
                    angleI = angleMin2 - angle; 
                end
                %Section F
                if ((obj.max3ValueIndex < i) && (i <= obj.min3ValueIndex))
                    angleMax3 = (obj.neutralValue-obj.max3Value)/obj.rCam;
                    angleI = angleMax3 - angle; 
                end
                %Section G
                if (obj.min3ValueIndex < i)
                    angleMin3 = (obj.neutralValue-obj.min3Value)/obj.rCam;
                    angleI = angleMin3 - angle; 
                    
                end
                MomentSI = (obj.effectiveWDorsiPull)*Si/angleI; %[Nm]
                disp(rad2deg(angleI));
            end            
        end
        
        function MomentSI = GetMomentContribution(obj, currentDorsiFlexionSpringPosition)
            forceOnFoot = obj.effectiveWDorsiPull-obj.wDorsiPull;
            currentFy = forceOnFoot*sin(deg2rad(currentDorsiFlexionSpringPosition.AppliedToeCableForceAngle));
            currentFx = forceOnFoot*cos(deg2rad(currentDorsiFlexionSpringPosition.AppliedToeCableForceAngle));
            currentMoment = currentFy*currentDorsiFlexionSpringPosition.distanceFromAnkle2ToeCableX + currentFx*currentDorsiFlexionSpringPosition.distanceFromAnkle2ToeCableY;            
                
            MomentSI = (-1)*currentMoment;
        end
        
        function weight = GetWeightTorsion(obj, Lwork, Lsupp)
            V = pi*(obj.wireDiameterSpring.^2)/4*(obj.NumberBodyTurns+Lwork+Lsupp);%Units in meters
            weight = V*obj.Density; %Units in Kg
        end
    end
end