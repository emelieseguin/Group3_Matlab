classdef PlantarTorsionSpring
    properties       
        % Hard Drawn
        YoungsModulus = 200000000000; % Young's Modulus [Pa]
        Density = 7850; % kg/m^3
        A = 140000; % Area from Shigley table 10-4
        m = 0.19; % Constant from Shigley table 10-4
        
        % Spring dimensions - can put more
        NumberBodyTurns = 3.5;
        wireDiameterSpring
        meanDiameterCoil
        
        lengthSupportLeg
        lengthWorkingLeg
        
        % Values used elsewhere
        weightPlantarTorsionSpring
        
        % Additional Torque
        additionalTorquePercentage = 0.20;
        
        % Peaks of the Curve Indexes -- Constant
        neutralValueIndex = 85;
        min1Index = 8
        max1Index = 49
        min2Index = 65
        max2Index = 85
        min3Index = 94
        max3Index = 100
        
        % Peaks of Curve Value
        neutralValue
        min1Value
        max1Value
        min2Value
        max2Value
        min3Value
        max3Value    
        
        %% Param Variables
        diameterNeededForShaft
        originalLengthOfSpringOnShaft
        
        %Other values for moment contribution
        rCam
        S
        wPlantarPull
        effectiveWPlantarPull
        
    end
    methods
        function obj = PlantarTorsionSpring(patientHeight, mPlantarPull, ...
            plantarSpringLengthArray)
   
            %% Values to pull for moment contribution
            obj.min1Value = plantarSpringLengthArray(obj.min1Index);
            obj.max1Value = plantarSpringLengthArray(obj.max1Index);
            obj.min2Value = plantarSpringLengthArray(obj.min2Index);
            obj.max2Value = plantarSpringLengthArray(obj.max2Index);
            obj.min3Value = plantarSpringLengthArray(obj.min3Index);
            obj.max3Value = plantarSpringLengthArray(obj.max3Index);
            obj.neutralValue = plantarSpringLengthArray(obj.neutralValueIndex);
        
           %% Set Design Variables
            %Rotation of cam
            camRotation = pi; %[rad]
            rCam = (obj.neutralValue - obj.min2Value)/pi;
            obj.rCam = rCam;
            S = rCam*2; %Vertical translation of cam-cable attachment point for one cam rotation
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
            %Calculate weight of the cable and spring
                wPlantarPull = mPlantarPull*9.81; %[N]
                obj.wPlantarPull = wPlantarPull;
                effectiveWPlantarPull = wPlantarPull * (1+obj.additionalTorquePercentage);
                obj.effectiveWPlantarPull = effectiveWPlantarPull;
            %Required torque on cam to lift the string:
                T = wPlantarPull*S/camRotation; %[Nm]
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
            
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\plantarTorsionSpringDimensions.txt', 'w');
                fprintf(fileID, '"dPlantarTorsionSpringCoil" = %f\n', D);
                fprintf(fileID, '"dPlantarTorsionSpringWire" = %f\n', d);
                fprintf(fileID, '"shaftRadius"= %f\n', Dp/2);
                fprintf(fileID, '"LoPlantarTorsionSpring" = %f\n', L);
                fprintf(fileID, '"numBodyTurnsPlantarTorsionSpring" = %f\n', obj.NumberBodyTurns);
                fprintf(fileID, '"LWorkPlantarTorsionSpring" = %f\n', Lwork);
                fprintf(fileID, '"LSuppPlantarTorsionSpring" = %f\n', Lsupp);
            fclose(fileID);            

            obj.weightPlantarTorsionSpring = obj.GetWeightTorsion(Lwork, Lsupp);
            
            global logFilePath;
            logFile = fopen(logFilePath, 'a+');
                fprintf(logFile, '\n\n****   Plantarflexion Cam Spring  ****\n\n');
                fprintf(logFile, '    Wire Diameter = %4.4f m\n', round(obj.wireDiameterSpring, 4));
                fprintf(logFile, '    Mean Coil Diameter = %4.4f m\n', round(obj.meanDiameterCoil,4));
                fprintf(logFile, '    Spring Index = %4.2f\n', round(c,2));
                fprintf(logFile, '    Number of Body Turns = %4.1f\n', round(obj.NumberBodyTurns,1));
                fprintf(logFile, '    Mass of Spring = %4.4f kg\n\n', round(obj.weightPlantarTorsionSpring,4));
                fprintf(logFile, '    Safety Factor = %3.2f\n', n);
                fprintf(logFile, '\n');
            fclose(logFile);
        end

        function MomentSI = GetMomentOnCam(obj, currentSpringCableLength, previousSpringCableLength, extensionCableLength, ...
        lengthUnstrechedSpring, R1, lengthAt0, i)
    
    
            if(i == 101)
                disp('made it');
            end
            
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
                if (i <= obj.min1Index)
                    angleI = (-1)*angle; 
                end
                %Section B
                if (obj.min1Index < i && i <= obj.max1Index)
                    angleMin1 = (obj.neutralValue-obj.min1Value)/obj.rCam;
                    angleI = angleMin1 - angle; 
                end        
                %Section C
                if (obj.max1Index < i && i <= obj.min2Index)
                    angleI = (-1)*angle; 
                end
                %Section D
                if (obj.min2Index < i && i <= obj.max2Index)
                    angleI = pi - angle; 
                end                
                %Section E
                if (obj.max2Index < i && i <= obj.min3Index)
                    angleMax2 = (obj.neutralValue-obj.max2Value)/obj.rCam;
                    angleI = angleMax2 - angle; 
                end
                %Section F
                if (obj.min3Index < i && i <= obj.max3Index)
                    angleMin3 = (obj.neutralValue-obj.min3Value)/obj.rCam;
                    angleI = angleMin3 - angle; 
                end
                %Section G
                if (obj.max3Index < i)
                    angleMax3 = (obj.neutralValue-obj.max3Value)/obj.rCam;
                    angleI = angleMax3 - angle; 
                end
                
                if(angleI ~= 0)
                    MomentSI = (obj.effectiveWPlantarPull)*Si/angleI; %[Nm]
                    %MomentSI = (obj.effectiveWPlantarPull-obj.wPlantarPull)*obj.S/angleI; %[Nm]
                else
                    MomentSI = 0;
                end
            end
        end
        
        function MomentSI = GetMomentContribution(obj, currentPlantarFlexionSpringPosition, i)
                        
            forceOnFoot = obj.effectiveWPlantarPull-obj.wPlantarPull;
            currentFy = forceOnFoot*sin(deg2rad(currentPlantarFlexionSpringPosition.AppliedHeelCableForceAngle));
            currentFx = forceOnFoot*cos(deg2rad(currentPlantarFlexionSpringPosition.AppliedHeelCableForceAngle));
            currentMoment = currentFy*currentPlantarFlexionSpringPosition.distanceFromAnkle2LowAttachmentX + currentFx*currentPlantarFlexionSpringPosition.distanceFromAnkle2LowAttachmentY;
            MomentSI = (-1)*currentMoment;%nextMoment - currentMoment;
        end
        
        function weight = GetWeightTorsion(obj, Lwork, Lsupp)
            V = pi*(obj.wireDiameterSpring.^2)/4*(obj.NumberBodyTurns+Lwork+Lsupp); %Units in meters
            weight = V*obj.Density; %Units in Kg
        end
    end
end


