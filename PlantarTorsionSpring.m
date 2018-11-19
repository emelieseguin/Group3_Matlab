function [weightPlantarTorsionSpring]= PlantarTorsionSpring(personHeight, mPlantarPull, ...
    plantarSpringLengthArray) 
    %% Create a function to find the vertical displacement from the array, from plantarSpringLengthArray    
    %Required vertical displacement of cam-cable attachment point to pick up slack
    S = 0.01197*personHeight; %[m]
    
        
    %% Rest of code
    %Rotation of cam
    camRotation = pi/2; %[rad]
    %Design variables 
    d = UnitConversion.Meters2Inches(0.0005/1.78*personHeight); % Diameter of wire[m]     
    D = UnitConversion.Meters2Inches(0.004/1.78*personHeight); % Mean diameter of coil[m]  
    % MUST HAVE D>(Dp+Delta+d) 
    density = 8800;%kg/m^3
    E = UnitConversion.Pa2Psi(103400000000); % Young's Modulus [Pa]
    Delta = UnitConversion.Meters2Inches(0.00005/1.78*personHeight); % Diametral clearance [m] 
    Lwork = UnitConversion.Meters2Inches(0.0105/1.78*personHeight); % Length of working leg [m] 
    Lsupp = UnitConversion.Meters2Inches(0.0105/1.78*personHeight); % Length of supporting leg [m] 
    Nb = 2; %Number of body turns
    A = 145000; % Area from Shigley table 10-4
    m = 0; % Constant from Shigley table 10-4
        
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
    
    weightPlantarTorsionSpring = GetWeightTorsion(d, Nb, Lwork, Lsupp, density);

end
function weight = GetWeightTorsion(d, Nb, Lwork, Lsupp, density)
   V = pi*(d.^2)/4*(Nb+Lwork+Lsupp);%Units in meters
    weight = V*density; %Units in Kg
end