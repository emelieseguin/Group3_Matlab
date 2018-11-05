function DorsiSpringCalcs()
%Patient Height
H = 1.78; %m
%Design variables
    D = Meters2Inches(0.007/1.78*H); % Mean diameter of coil
    d = Meters2Inches(0.0012/1.78*H); % Diameter of wire
    E = Pa2Psi(200000000000); % Young's Modulus  - Steel
    G = Pa2Psi(79300000000); % Shear Modulus  - Steel 
    R1 = Meters2Inches(0.005/1.78*H); % 
    R2 = Meters2Inches(0.005/1.78*H); % 
    Fi = Newton2Lbf(5.29/1.78*H); %Initial tension force in spring
    Nb = 15; % Number of body turns
    A = 140000; % Area from Shigley table 10-4
    m = 0.19; % Constant from Shigley table 10-4
    LtotO = Meters2Inches(1.160/1.78*H); %

    %Bring in y value [m]
    Lmax = Meters2Inches(1.1659/1.78*H); %got this value from other calculations
    y = Lmax-LtotO;
    
    %Calculate number of active turns
    Na = Nb+(G/E);
    %Calculate the linear spring constant
    k = (d.^4)*(G)/(8*(D.^3)*Na);
    %Calculate spring index
    c = D/d;
    %Calculate original spring length
    Lo = (2*c-1+Nb)*d;
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
    Sut = A/(d.^m); 
    %Calculate Ssy - eq'n from Shigley table 10-7
    Ssy = 0.45*Sut;
    %Calculate Sy - eq'n from Shigley table 10-7
    Sy = 0.75*Sut;
    %Calculate ultimate shear strength Ssu
    Ssu = 0.67*Sut;
     
    Ssa = Pa2Psi(241000000); %[Pa] from Zimmerli data  
    Ssm = Pa2Psi(379000000); %[Pa] from Zimmerli data
    
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
    D = Inches2Meters(D); 
    d = Inches2Meters(d); 
    E = Psi2Pa(E); 
    G = Psi2Pa(G);
    R1 = Inches2Meters(R1); 
    R2 = Inches2Meters(R2); 
    Fi = Lbf2Newton(Fi); 
    Lo = Inches2Meters(Lo);
    L = Inches2Meters(L);
    y = Inches2Meters(y);
    k = PoundFperInch2NewtonperMeter(k);
    Lmax = Inches2Meters(Lmax);
    LtotO = Inches2Meters(LtotO);
    CL = Inches2Meters(CL);
    Fmax = Lbf2Newton(Fmax);
    Fmin = Lbf2Newton(Fmin);
    Fa = Lbf2Newton(Fa);
    Fm = Lbf2Newton(Fm);
    TauA = Psi2Pa(TauA);
    TauM = Psi2Pa(TauM);  
    Sut = Psi2Pa(Sut);
    Ssy = Psi2Pa(Ssy);
    Sy = Psi2Pa(Sy);
    Ssu = Psi2Pa(Ssu);
    Ssa = Psi2Pa(Ssa);
    Ssm = Psi2Pa(Ssm);
    Sse = Psi2Pa(Sse);    
    TauI = Psi2Pa(TauI);
    Ssay = Psi2Pa(Ssay);
    SigmaA = Psi2Pa(SigmaA);
    SigmaM = Psi2Pa(SigmaM);
    Se = Psi2Pa(Se);
    TauAB = Psi2Pa(TauAB);
    TauMB = Psi2Pa(TauMB);
    
end
function meters = Inches2Meters(inches)
    meters = inches/39.37;
end
function inches = Meters2Inches(meters)
    inches = meters*39.37;
end
function Newton = Lbf2Newton(Lbf)
    Newton = Lbf*4.448222;
end
function Lbf = Newton2Lbf(Newton)
    Lbf = Newton/4.448222;
end
function Pa = Psi2Pa(Psi)
    Pa = Psi*6894.757;
end
function Psi = Pa2Psi(Pa)
    Psi = Pa/6894.757;
end
function NewtonM = PoundFInch2NewtonM(PoundF)
    NewtonM = PoundF/8.850746;
end
function PoundFInch = NewtonM2PoundFInch(NewtonM)
    PoundFInch = NewtonM*8.850746;
end
function NewtonperMeter = PoundFperInch2NewtonperMeter(PoundFperInch)
    NewtonperMeter = PoundFperInch*175.127;
end