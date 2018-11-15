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
Fy2 = (-Fg6*(z2/2) - Fg1*((z3+z4)/2) - Fg2*((z5+z4)/2) - (- Fg6 - Fg1 - Fg2 - Fg3 - Fg4 - Fg5 - Fg7)*((z4+z5)/2) - Fg3*((z7+z9)/2) - Fg5*(ztot) - Fg4*((z11+z12)/2) - Fg7*((z13+z14)/2))/((-z4-z5+z10+z11)/2);
% taking the summation of forces to calculate the reaction forces on the 2
% discs assuming up in the y is positive
Fy4 = - Fg6 - Fg1 - Fg2 - Fg3 - Fg4 - Fg5 - Fg7 - Fy2 ; % reaction force at lateral disc
% checking to ensure the summation of forces on the shaft is zero
Rty = Fg6 + Fg1 + Fg2 + Fg3 + Fg4 +Fg5 + Fg7 + Fy2 + Fy4;



% summation of moments and forces on 2 DOF pin joint
r2DOFPin = 0.005; % the diameter of the 2DOF joint pin
l2DOFPin = 0.03; % the length of the 2 DOF joint pin
v2DOFPin = pi * r2DOFPin.^2 * l2DOFPin; % the volume of the 2 DOF joint pin
m2DOFPin = densitySt * v2DOFPin; % the mass of the 2 DOF joint pin
mBelow2DOFJoint = ExoskeletonMassvar.mBelow2DOFJoint;

F1pin = ExoskeletonMassvar.mBelow2DOFJoint*g + m2DOFPin*g; % the reaction force on the 2 DOF pin joint


% Plantarflexion cam design parameters
lPlantarSpring = (5/178)*H; % the length of the plantarflexion spring
lPlantarString = (27.59/178)*H - lPlantarSpring; % the length of the string minus the spring
rPlantarString = (0.1/178)*H; % the radius of the plantar flexion string
vPlantarString = lPlantarString*pi*rPlantarString.^2; % the volume of the plantar flexion string
mPlantarString = vPlantarString * densitySt; % mass of the plantar flexion string

rPlantarCamSpring = (0.05/178)*H; % the radius of the torsional spring wire
RPlantarCamSpring = (2/178)*H; % the mean radius of the torsional spring coil
nPlantarCamSpring = 2; % the number of body turns of the torsional spring
vPlantarCamSpring = pi*rPlantarCamSpring.^2*2*pi*nPlantarCamSpring*RPlantarCamSpring; % the volume of the torsional spring
mPlantarCamSpring = densitySt * vPlantarCamSpring; % the mass of the torsional spring

mPlantarCamCase = 0.005713; % the mass of the casing around the cam and cam shaft

mPlantarCam = 0.0064341; % the mass of the plantar flexion cam

PlantarCamZ1 = 0; % the beginning of the cam shaft
PlantarCamZ2 = (.5/178)*H; % the distance to the first step down (circlip) of the the shaft
PlantarCamZ3 = (.7/178)*H; % the distance to the first step up (bearing) after the circlip 
PlantarCamZ4 = (1.2/178)*H; % the distance to the second step up after the bearing
PlantarCamZ5 = (3.2/178)*H; % the distance to the edge of the cam
PlantarCamZ6 = (3.9/178)*H; % the distance to the end of the cam
PlantarCamZ7 = (4.2/178)*H; % the distance to the end of the shaft

PlantarCamDp1 = (0.6/178)*H; % the diamater of the shaft up to the circlip
PlantarCamDp2 = (0.5/178)*H; % the diameter of the shaft at the circlip
PlantarCamDp3 = (0.6/178)*H; % the diameter of the shaft after the circlip/diameter of inside of bearing
PlantarCamDp4 = (0.8/178)*H; % the diameter of the shaft up to the cam
PlantarCamDp5 = (0.6/178)*H; % the diameter of the shaft after the cam

PlantarCamShaftMiZi = (densityAl*pi/4) * (PlantarCamDp1.^2 * (PlantarCamZ2-PlantarCamZ1)*((PlantarCamZ2+PlantarCamZ1)/2) + PlantarCamDp2.^2 * (PlantarCamZ3-PlantarCamZ2)*((PlantarCamZ3+PlantarCamZ2)/2) +PlantarCamDp3.^2 * (PlantarCamZ4-PlantarCamZ3)* ((PlantarCamZ4+PlantarCamZ3)/2) +PlantarCamDp4.^2 * (PlantarCamZ5-PlantarCamZ4)* ((PlantarCamZ5+PlantarCamZ4)/2) +PlantarCamDp5.^2 * (PlantarCamZ7-PlantarCamZ5)* ((PlantarCamZ7+PlantarCamZ5)/2)); % the summation of masses and their centres of mass
mPlantarCamShaft = (densityAl*pi/4) * (PlantarCamDp1.^2 * (PlantarCamZ2-PlantarCamZ1)+ PlantarCamDp2.^2 * (PlantarCamZ3-PlantarCamZ2) +PlantarCamDp3.^2 * (PlantarCamZ4-PlantarCamZ3) +PlantarCamDp4.^2 * (PlantarCamZ5-PlantarCamZ4) +PlantarCamDp5.^2 * (PlantarCamZ7-PlantarCamZ5)); % the total mass of the plantar flexion cam shaft
PlantarCamZtot = PlantarCamShaftMiZi/mPlantarCamShaft; % the center of mass of the plantar cam shaft

Fy1 = g * (mPlantarCamShaft + mPlantarCam + mPlantarCamCase + mPlantarCamSpring);

end

