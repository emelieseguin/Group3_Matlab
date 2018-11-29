classdef HipTorsionSpring
    properties
        % Hard Drawn Steel
        YoungsModulus = 200000000000; % Young's Modulus [Pa]
        Density = 7850; % kg/m^3
        A = 140000; % Area from Shigley table 10-4
        m = 0.19; % Constant from Shigley table 10-4        
        
        % Spring dimensions - can put more
        NumberBodyTurns = 0.9;
        wireDiameterSpring
        meanDiameterCoil
        
        lengthSupportLeg
        lengthWorkingLeg

        % Values to return
        maxTorsionFromSpring
        shaftDiameter
        lengthHipSpring
        weightHipTorsionSpring
        maxExtension
    end
    methods
        function obj = HipTorsionSpring(patientHeight, patientHipAngles)  %% read it in
            %% Set Design Variables 
            obj.wireDiameterSpring = (0.004/1.78)*patientHeight; % Diameter of wire[m]
            d = UnitConversion.Meters2Inches(obj.wireDiameterSpring);  
            
            obj.meanDiameterCoil = (0.025/1.78)*patientHeight; % Mean diameter of coil[m]  
            D = UnitConversion.Meters2Inches(obj.meanDiameterCoil); 
            
            % MUST HAVE D>(Dp4+Delta+d) 
            E = UnitConversion.Pa2Psi(obj.YoungsModulus);  
            Delta = UnitConversion.Meters2Inches(0.0005/1.78*patientHeight); % Diametral clearance [m] 
            
            obj.lengthWorkingLeg = 0.03/1.78*patientHeight; % Length of working leg [m] 
            Lwork = UnitConversion.Meters2Inches(obj.lengthWorkingLeg); 
            
            obj.lengthSupportLeg = 0.01/1.78*patientHeight; % Length of supporting leg [m] 
            Lsupp = UnitConversion.Meters2Inches(obj.lengthSupportLeg); 

            %% Calculations
            %Calculate spring index 
                c = D/d;        
            %Calculate factor for inner surface stress concentration     
                Ki = ((4*(c.^2))-c-1)/(4*c*(c-1));             
            %Maximum extension angle - multiply by -1 to get a positive value
                maxExtension = deg2rad((min(patientHipAngles))*(-1)); 
                obj.maxExtension = (-1)*rad2deg(maxExtension);
            %Maximum moment
                Mmax = (3*pi/64)*((maxExtension*(d.^4)*E)/(3*pi*D*obj.NumberBodyTurns+Lwork+Lsupp));       
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
            obj.lengthHipSpring = L;
            LPrime = UnitConversion.Inches2Meters(LPrime);
            Delta = UnitConversion.Inches2Meters(Delta);
            DPrime = UnitConversion.Inches2Meters(DPrime);
            Dp = UnitConversion.Inches2Meters(Dp);
            obj.shaftDiameter = Dp;
            obj.maxTorsionFromSpring = UnitConversion.PoundFInch2NewtonM(Mmax);
            SigmaA = UnitConversion.Psi2Pa(SigmaA);
            Sut = UnitConversion.Psi2Pa(Sut);
            Sr = UnitConversion.Psi2Pa(Sr);      
            Se = UnitConversion.Psi2Pa(Se);
            Sa = UnitConversion.Psi2Pa(Sa);
                        
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\hipTorsionSpringDimensions.txt', 'w');
                fprintf(fileID, '"dHipTorsionSpringCoil"= %f\n', D);
                fprintf(fileID, '"rHipTorsionSpringCoil"= %7.7f\n', D/2); % I think thats R
                fprintf(fileID, '"shaftRadius"= %f\n', Dp/2);
                fprintf(fileID, '"dHipTorsionSpringWire"= %f\n', d);
                fprintf(fileID, '"LoHipTorsionSpring"= %f\n', L);
                fprintf(fileID, '"LWorkHipTorsionSpring"= %f\n', Lwork);
                fprintf(fileID, '"LSuppHipTorsionSpring"= %f\n', Lsupp);
                fprintf(fileID, '"numBodyTurnsHipTorsionSpring"= %f\n', obj.NumberBodyTurns);
            fclose(fileID);

            obj.weightHipTorsionSpring = obj.GetWeightTorsion(d, Lwork, Lsupp);
        end
        
        function MomentSI = GetMomentContribution(obj, currentHipAngle, i)
            
            MomentSI = 0;
            if(currentHipAngle < 0)
                d = UnitConversion.Meters2Inches(obj.wireDiameterSpring); 
                D = UnitConversion.Meters2Inches(obj.meanDiameterCoil); 
                Lwork = UnitConversion.Meters2Inches(obj.lengthWorkingLeg); 
                Lsupp = UnitConversion.Meters2Inches(obj.lengthSupportLeg);
                E = UnitConversion.Pa2Psi(obj.YoungsModulus);  
                %angleDiff = deg2rad(nextHipAngle-currentHipAngle);
                %angleDiff = (deg2rad(nextHipAngle-currentHipAngle));%/(timeForGaitCycle/100);
                angle = deg2rad(currentHipAngle);
                MomentImperial = (-1)*(3*pi/64)*((angle*(d.^4)*E)/(3*pi*D*obj.NumberBodyTurns+Lwork+Lsupp));
                if(i > 57) % Flexing - ' -'ve moment applied by spring '
                   angle = deg2rad(abs(obj.maxExtension -  currentHipAngle));
                   MomentImperial = (-1)*(3*pi/64)*((angle*(d.^4)*E)/(3*pi*D*obj.NumberBodyTurns+Lwork+Lsupp)); %uses newly calcuated angle
                end 

                % CCW is +'ve so times -1 
                %MomentImperial = (-1)*(3*pi/64)*((angleDiff*(d.^4)*E)/(3*pi*D*obj.NumberBodyTurns+Lwork+Lsupp));
                %MomentImperial = (-1)*(3*pi/64)*((angle*(d.^4)*E)/(3*pi*D*obj.NumberBodyTurns+Lwork+Lsupp));
                MomentSI = UnitConversion.PoundFInch2NewtonM(MomentImperial);
            end 
        end
        
        function weight = GetWeightTorsion(obj, d, Lwork, Lsupp)
            V = pi*(d.^2)/4*(obj.NumberBodyTurns+Lwork+Lsupp);%Units in meters
            weight = V*obj.Density; %Units in Kg
        end
    end
end


