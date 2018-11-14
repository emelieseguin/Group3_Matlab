function PlantarTorsionSpring() 
%Variables to be brought in from other code
    %Patient Height
        H = 1.78; %m
    %Mass of cable
        mCable = 0.005713; %[kg]
    %Required vertical displacement of cam-cable attachment point to pick up slack
        S = 0.01197*H; %[m]
    %Rotation of cam
        camRotation = pi/2; %[rad]
%Design variables 
    d = Meters2Inches(0.0005/1.78*H); % Diameter of wire[m]     
    D = Meters2Inches(0.004/1.78*H); % Mean diameter of coil[m]  
    % MUST HAVE D>(Dp+Delta+d) 
    E = Pa2Psi(103400000000); % Young's Modulus [Pa]
    Delta = Meters2Inches(0.00005/1.78*H); % Diametral clearance [m] 
    Lwork = Meters2Inches(0.0105/1.78*H); % Length of working leg [m] 
    Lsupp = Meters2Inches(0.0105/1.78*H); % Length of supporting leg [m] 
    Nb = 2; %Number of body turns
    A = 145000; % Area from Shigley table 10-4
    m = 0; % Constant from Shigley table 10-4
        
    %Calculate weight of cable
        wCable = mCable*9.81; %[N]
    %Required torque on cam to lift the string:
        T = wCable*S/camRotation; %[Nm]
        Mmax = NewtonM2PoundFInch(T); %[lbf in]
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
    D = Inches2Meters(D); 
    d = Inches2Meters(d); 
    E = Psi2Pa(E); 
    Lwork = Inches2Meters(Lwork); 
    Lsupp = Inches2Meters(Lsupp);    
    L = Inches2Meters(L);
    LPrime = Inches2Meters(LPrime);
    Delta = Inches2Meters(Delta);
    DPrime = Inches2Meters(DPrime);
    Dp = Inches2Meters(Dp);
    Mmax = PoundFInch2NewtonM(Mmax);
    SigmaA = Psi2Pa(SigmaA);
    Sut = Psi2Pa(Sut);
    Sr = Psi2Pa(Sr);      
    Se = Psi2Pa(Se);
    Sa = Psi2Pa(Sa);

end
function meters = Inches2Meters(inches)
    meters = inches/39.37;
end
function inches = Meters2Inches(meters)
    inches = meters*39.37;
end
function Pa = Psi2Pa(Psi)
    Pa = Psi*6894.757;
end
function Psi = Pa2Psi(Pa)
    Psi = Pa/6894.757;
end
function NewtonM = PoundFInch2NewtonM(PoundFInch)
    NewtonM = PoundFInch/8.850746;
end
function PoundFInch = NewtonM2PoundFInch(NewtonM)
    PoundFInch = NewtonM*8.850746;
end
