classdef PlantarTorsionSpring
    properties
        % Material Properties
        YoungsModulus = 103400000000; % Young's Modulus [Pa]
        Density = 8800; % kg/m^3
        A = 145000; % Area from Shigley table 10-4
        m = 0; % Constant from Shigley table 10-4
        
        % Spring dimensions - can put more
        NumberBodyTurns = 2;
        wireDiameterSpring
        meanDiameterCoil
        
        lengthSupportLeg
        lengthWorkingLeg
        
        % Values used elsewhere
        weightPlantarTorsionSpring
    end
    methods
        function obj = PlantarTorsionSpring(patientHeight, mPlantarPull, ...
            plantarSpringLengthArray) 
            %% Create a function to find the vertical displacement from the array, from plantarSpringLengthArray    
            %Required vertical displacement of cam-cable attachment point to pick up slack
            S = 0.01197*patientHeight; %[m]


            %% Set Design Variables
            %Rotation of cam
            camRotation = pi/2; %[rad]
 
            obj.wireDiameterSpring = (0.0005/1.78)*patientHeight; % Diameter of wire[m]
            d = UnitConversion.Meters2Inches(obj.wireDiameterSpring);
            
            obj.meanDiameterCoil = (0.004/1.78)*patientHeight; % Mean diameter of coil[m]  
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
            LPrime = UnitConversion.Inches2Meters(LPrime);
            Delta = UnitConversion.Inches2Meters(Delta);
            DPrime = UnitConversion.Inches2Meters(DPrime);
            Dp = UnitConversion.Inches2Meters(Dp);
            Mmax = UnitConversion.PoundFInch2NewtonM(Mmax);
            SigmaA = UnitConversion.Psi2Pa(SigmaA);
            Sut = UnitConversion.Psi2Pa(Sut);
            Sr = UnitConversion.Psi2Pa(Sr);      
            Se = UnitConversion.Psi2Pa(Se);
            Sa = UnitConversion.Psi2Pa(Sa);

            obj.weightPlantarTorsionSpring = obj.GetWeightTorsion(d, Lwork, Lsupp);
        end
        
        function weight = GetWeightTorsion(obj, d, Lwork, Lsupp)
            V = pi*(d.^2)/4*(obj.NumberBodyTurns+Lwork+Lsupp); %Units in meters
            weight = V*obj.Density; %Units in Kg
        end
    end
end


