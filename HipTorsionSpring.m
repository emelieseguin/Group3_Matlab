function [maxMomentFromSpring, shaftDiameter, wireDiameterSpring, lengthSuppLeg, lengthHipSpring, weightHipTorsionSpring] ...
    = HipTorsionSpring(patientHeight, patientHipAngles) 
    %% Design variables 
    d = UnitConversion.Meters2Inches(0.003/1.78*patientHeight); % Diameter of wire[m]   
    wireDiameterSpring = UnitConversion.Inches2Meters(d);
    D = UnitConversion.Meters2Inches(0.035/1.78*patientHeight); % Mean diameter of coil[m]  
    % MUST HAVE D>(Dp4+Delta+d) 
    density = 8800;%kg/m^3
    E = UnitConversion.Pa2Psi(103400000000); % Young's Modulus [Pa] 
    Delta = UnitConversion.Meters2Inches(0.0005/1.78*patientHeight); % Diametral clearance [m] 
    Lwork = UnitConversion.Meters2Inches(0.04/1.78*patientHeight); % Length of working leg [m] 
    Lsupp = UnitConversion.Meters2Inches(0.01/1.78*patientHeight); % Length of supporting leg [m] 
    lengthSuppLeg = UnitConversion.Inches2Meters(Lsupp);
    Nb = 18; %Number of body turns
    A = 145000; % Area from Shigley table 10-4
    m = 0; % Constant from Shigley table 10-4
    
    %% Calculations
    %Calculate spring index 
        c = D/d;        
    %Calculate factor for inner surface stress concentration     
        Ki = ((4*(c.^2))-c-1)/(4*c*(c-1));             
    %Maximum extension angle - multiply by -1 to get a positive value 
        maxExtension = (min(patientHipAngles))*(-1); 
    %Maximum moment
        Mmax = (3*pi/64)*((maxExtension*(d.^4)*E)/(3*pi*D*Nb+Lwork+Lsupp));       
    %Deflection of body coils
        ThetaCPrime = Mmax*((10.8*D*Nb)/((d.^4)*E));
    %New mean diameter of coil
        DPrime = (Nb*D)/(ThetaCPrime+Nb);
    %Shaft diameter    
        Dp = DPrime - Delta - d;
    %Moment amplitude
        Ma = Mmax/2;
    %Stress
        SigmaA = (32*Ki*Ma)/(pi*(d.^3));    
    %Find Ultimate strength 
        Sut = A/(d.^m);
    %Find Sr 
        Sr = 0.5*Sut;        
    %Find Se 
         Se = (Sr/2)/(1-(((Sr/2)/Sut).^2)); 
    %Find Sa 
        Sa = ((Sut.^2)/(2*Se))*(-1+((1+((2*Se/Sut)^.2)).^(1/2))); 
    %Calculate original length of spring [m] 
        L = d*(Nb+1); 
    %Calculate new length of spring [m] 
        LPrime = d*(Nb+1+ThetaCPrime); 
    %Check safety factor
        n = Sa/SigmaA; 
        
   %convert variables to SI units
    D = UnitConversion.Inches2Meters(D); 
    d = UnitConversion.Inches2Meters(d); 
    E = UnitConversion.Psi2Pa(E); 
    Lwork = UnitConversion.Inches2Meters(Lwork); 
    Lsupp = UnitConversion.Inches2Meters(Lsupp);    
    L = UnitConversion.Inches2Meters(L);
    lengthHipSpring = L;
    LPrime = UnitConversion.Inches2Meters(LPrime);
    Delta = UnitConversion.Inches2Meters(Delta);
    DPrime = UnitConversion.Inches2Meters(DPrime);
    Dp = UnitConversion.Inches2Meters(Dp);
    shaftDiameter = Dp;
    maxMomentFromSpring = UnitConversion.PoundFInch2NewtonM(Mmax);
    SigmaA = UnitConversion.Psi2Pa(SigmaA);
    Sut = UnitConversion.Psi2Pa(Sut);
    Sr = UnitConversion.Psi2Pa(Sr);      
    Se = UnitConversion.Psi2Pa(Se);
    Sa = UnitConversion.Psi2Pa(Sa);
    
    weightHipTorsionSpring = GetWeightTorsion(d, Nb, Lwork, Lsupp);
end
function weight = GetWeightTorsion(d, Nb, Lwork, Lsupp)
   V = pi*(d.^2)/4*(Nb+Lwork+Lsupp);%Units in meters
    weight = V*density; %Units in Kg
end