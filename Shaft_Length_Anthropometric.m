function Shaft_Length_Anthropometric()
%Height will be obtained from GUI 
H=1.78;
%Total length of the shaft
zt = (0.153/1.78)*H;
%Density of shaft material in kg/m^3
density = 2700;
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
mizi = (density*pi/4)*((dp1.^2)*(z3-z1)*(z1+((z3-z1)/2)) + (dp2.^2)*(z4-z3)*(z3+((z4-z3)/2)) + (dp3.^2)*(z7-z4)*(z4+((z7-z4)/2)) + (dp4.^2)*(z10-z7)*(z7+((z10-z7)/2)) + (dp5.^2)*(z11-z10)*(z10+((z11-z10)/2)) + (dp6.^2)*(z12-z11)*(z11+((z12-z11)/2))+ (dp7.^2)*(z14-z12)*(z12+((z14-z12)/2)));
%total mass of the shaft
mtot = (density*pi/4)*((dp1.^2)*(z3-z1) + (dp2.^2)*(z4-z3) + (dp3.^2)*(z7-z4) + (dp4.^2)*(z10-z7) + (dp5.^2)*(z11-z10) + (dp6.^2)*(z12-z11)+ (dp7.^2)*(z14-z12));
%volume of the shaft
vtot = (pi/4) * ((dp1.^2)*(z3-z1) + (dp2.^2)*(z4-z3) + (dp3.^2)*(z7-z4) + (dp4.^2)*(z10-z7) + (dp5.^2)*(z11-z10) + (dp6.^2)*(z12-z11)+ (dp7.^2)*(z14-z12));
%Center of mass for entire shaft
ztot = mizi/mtot;


end

function Forces_On_Shaft()
% acceleration caused by gravity 
g = 9.81; 




end

