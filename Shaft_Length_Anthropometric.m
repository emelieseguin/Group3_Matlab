function Shaft_Length_Anthropometric()
%Height will be obtained from GUI 
H=1.78;
%Total length of the shaft
zt = (0.153/1.78)*H;
%Density of shaft material in kg/m^3
densityAl = 2700;
densitySt = 8050;
%Different points along shaft based on a percentage
z1 = 0;
z2 = 0.06535948*zt;
z3 = 0.09803922*zt;
z4 = 0.11764706*zt;
z5 = 0.18300654*zt;
z6 = 0.19607843*zt;
z7 = 0.26143791*zt;
z8 = 0.40522876*zt;
z9 = 0.42483660*zt;
z10 = 0.49019608*zt;
z11 = 0.58823530*zt;
z12 = 0.60784314*zt;
z13 = 0.93464052*zt;
z14 = 1.00000000*zt;

%Different diameters along shaft based on a percentage
dp1 = (0.015/1.78)*H;
dp2 = (0.012/1.78)*H;
dp3 = (0.02/1.78)*H;
dp4 = (0.0282/1.78)*H;
dp5 = (0.02/1.78)*H;
dp6 = (0.017/1.78)*H;
dp7 = (0.02/1.78)*H;

%Summation of masses and there centers of mass
mizi = (densityAl*pi/4)*((dp1.^2)*(z3-z1)*(z1+((z3-z1)/2)) + (dp2.^2)*(z4-z3)*(z3+((z4-z3)/2)) + (dp3.^2)*(z7-z4)*(z4+((z7-z4)/2)) + (dp4.^2)*(z10-z7)*(z7+((z10-z7)/2)) + (dp5.^2)*(z11-z10)*(z10+((z11-z10)/2)) + (dp6.^2)*(z12-z11)*(z11+((z12-z11)/2))+ (dp7.^2)*(z14-z12)*(z12+((z14-z12)/2)));
%total mass of the shaft
mtot = (densityAl*pi/4)*((dp1.^2)*(z3-z1) + (dp2.^2)*(z4-z3) + (dp3.^2)*(z7-z4) + (dp4.^2)*(z10-z7) + (dp5.^2)*(z11-z10) + (dp6.^2)*(z12-z11)+ (dp7.^2)*(z14-z12));
%volume of the shaft
vtot = (pi/4) * ((dp1.^2)*(z3-z1) + (dp2.^2)*(z4-z3) + (dp3.^2)*(z7-z4) + (dp4.^2)*(z10-z7) + (dp5.^2)*(z11-z10) + (dp6.^2)*(z12-z11)+ (dp7.^2)*(z14-z12));
%Center of mass for entire shaft
ztot = mizi/mtot;

% dimensions of retaining rings
lRetainingRing1 = (0.2/178)*H; % the thickness of the retaing ring in the z direction
rRetainingRing1Out = 0.5*dp2 + (0.2/178)*H; % outer radius retaining ring 1 is 2mm larger than shaft radius
vRetainingRing1 = lRetainingRing1 * pi * (rRetainingRing1Out.^2 - (0.5 * dp2).^2) % volume of retaining ring 1
lRetainingRing2 = (0.2/178)*H; % the thickness of the retaing ring in the z direction
rRetainingRing2Out = 0.5*dp6 + (0.2/178)*H; % outer radius retaining ring 2 is 2mm larger than shaft radius
vRetainingRing2 = lRetainingRing2 * pi * (rRetainingRing2Out.^2 - (0.5 * dp6).^2) % volume of retaining ring 1
mRetainingRing1 = vRetainingRing1 * densitySt; % mass of retaining ring 1
mRetainingRing2 = vRetainingRing2 * densitySt; % mass of retaining ring 2

% dimensions of the key
lShaftKeyHip = z6 - z4; % the length of the key in the z direction along the shaft
wShaftKeyHip = (0.5/178)*H; % the width of the key in the x direction
hShaftKeyHip = (0.5/178)*H; % the height of the key in the y direction
vShaftKeyHip = lShaftKeyHip * wShaftKeyHip * hShaftKeyHip; % volume of the key
mShaftKeyHip = vShaftKeyHip * densitySt; % mass of the key

% dimensions of the torsional hip spring
mHipSpring = 0.059764821; % the mass of torsional hip spring

ExoskeletonMassvar = Exoskeleton_Mass_Anthropometric();



% acceleration caused by gravity 
g = 9.81; 
% forces acting on shaft
Fg6 = - 0.5*ExoskeletonMassvar.MdiscCase * g; % the reaction force at the case support...this support holds up half the weight of case
Fg1 = - mRetainingRing1 * g; % the downward force on shaft from weight of retaining ring 1
Fg2 = - mShaftKeyHip * g; %  the downward force on the shaft from the weight of the key
Fg3 = - mHipSpring * g; % the downward force on the shaft from the weight of the spring
Fg4 = - mRetainingRing2 * g; % the downward force on the shaft from the wight of retaining ring 2
Fg5 = - mtot * g; % the downward force caused by the weight of the shaft itself
Fg7 = - 0.5*ExoskeletonMassvar.MdiscCase * g; % the reaction force at the case support...this support holds up half the weight of case

% summation of moments
Fy2 = (-Fg6*(z2/2) - Fg1*((z3+z4)/2) - Fg2*((z5+z4)/2) + (- Fg6 - Fg1 - Fg2 - Fg3 - Fg4 - Fg5 - Fg7)*((z4+z5)/2) - Fg3*((z7+z9)/2) - Fg5*(ztot) - Fg4*((z11+z12)/2) - Fg7*((z13+z14)/2))/((-z4-z5+z10+z11)/2);
% taking the summation of forces to calculate the reaction forces on the 2
% discs assuming up in the y is positive
Fy4 = - Fg6 - Fg1 - Fg2 - Fg3 - Fg4 - Fg5 - Fg7 - Fy2; % reaction force at lateral disc

% checking to ensure the summation of forces on the shaft is zero
Rty = Fg6 + Fg1 + Fg2 + Fg3 + Fg4 +Fg5 + Fg7 + Fy2 + Fy4;


end

