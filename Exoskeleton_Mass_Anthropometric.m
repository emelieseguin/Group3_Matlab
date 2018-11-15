
classdef Exoskeleton_Mass_Anthropometric
    properties
        %densityAl
        %densitySt
        %densityHDPE
        %densityFoam
        mBelt
        Mbearing1Case
        Mshaft1
        Mmount
        MDOFjoint
        MdiscCase
        Mdisc
        Mshaft
        MdiscConnecter
        MthighStrapCaseSupport
        MthighStrapCase
        MthighStrapPadding
        McalfStrapCaseSupport
        McalfStrapCase
        McalfStrapPadding
        MtopBarPulley
        MtopBar
        MdorsiSpringCase
        mLinks
        MuniJoint
        MbotBarPulley
        MbotBar
        mBelow2DOFJoint
    end
     methods
        function obj = Exoskeleton_Mass_Anthropometric()
                % NOTE: all length dimensions are in terms of meters, volumes are in m^3
                % and masses are in kg

                %Height obtained from GUI
                H = 1.78;
                %Density of different materials in kg/m^3
                densityAl = 2700;
                densitySt = 8050;
                densityHDPE = 970;
                densityFoam = 48.06;

                % dimensions of the belt which wraps around the users waist
                rBelt = (15/178)*H; % radius of the users waist will be obtained from the GUI
                hBelt = (7/178)*H; % the height of the belt extending in the y direction
                tBelt = (1/178)*H; % the thickness of the belt 
                vBelt = 0.5*pi*((rBelt + tBelt).^2 - rBelt.^2) * hBelt;

                obj.mBelt = vBelt * densityAl; % the total mass of the the belt 

                % Dimensions of bearing case
                Mbearing1 = 0.089; %this is either given or can caluclate later...took this from mcmastercarr
                Rbearing1Out = 0.042; %radius of outside of bearing
                Hbearing1 = 0.012; % height of bearing
                hLid1 = (1/178)*H; % lid height which covers bearing and case in cm
                Rcase1 = Rbearing1Out+(0.5/178)*H; % radius of case which covers bearing
                Rbearing1In = 0.01; % radius of inside of bearing
                Lshaft1 = Hbearing1 + hLid1 + (2/178)*H; % length of shaft in bearing
                Vbearing1Case = pi*(Rcase1.^2 - Rbearing1Out.^2)*hLid1 + pi*Rcase1.^2*hLid1; % volume of just case around bearing
                Vshaft1 = pi*(Rbearing1In.^2)*Lshaft1; % volume of hip shaft 1

                obj.Mbearing1Case = Vbearing1Case * densityAl; % the mass of the bearing case
                obj.Mshaft1 = Vshaft1 * densityAl; % mass of the hip bearing shaft

                % Dimensions of hip to bearing case mount....mount1 is where the screws are
                % and mount 2 extends to bearing case
                Lmount1 = (2/178)*H; %dimension which expands in the z direction
                Wmount1 = (6/178)*H; %dimension which expands in the x direction
                Hmount1 = (3/178)*H; %dimension which expands in the y direction
                Lmount2 = (4/178)*H; %dimension which expands in the z direction
                Wmount2 = (3/178)*H; %dimension which expands in the x direction
                Hmount2 = (3/178)*H; %dimension which expands in the y direction
                Vmount = (Lmount1 * Wmount1 * Hmount1) + (Lmount2 * Wmount2 * Hmount2); % total volume of the belt to bearing case mount

                obj.Mmount = Vmount * densityAl; % mass of the mount

                %2 DOF joint which connects hip bearing case to hip disc case
                obj.MDOFjoint = 0.07711; % mass of 2 DOF joint
                HDOFjoint = 0.05; % height of 2 DOF joint in the y directon

                %The dimensions of the hip disc mechanism 
                LdiscConnecter = (4/178)*H; % dimension which expands in the z direction...discConnector connects 2 DOF joint to lateral disc
                WdiscConnecter = (2/178)*H; % dimension which expands in the x direction
                HdiscConnecter = (2/178)*H; % dimension which expands in the y direction
                Rdisc = (4/178)*H; % radius of the hip discs
                Wdisc = (2.19402/178)*H; % Width of the discs
                DistanceDiscs = (3.5/178)*H; % distance between the two discs 
                zt = (15.3/178)*H; % total length of the shaft
                TdiscCase = (0.5/178)*H; % thickness of the disc case
                LdiscCaseIn = zt; % inner length of the hip disc mechanism case expanding in the z direction
                LdiscCaseOut = LdiscCaseIn + 2*TdiscCase; % outer length of the hip disc mechanism case
                WdiscCaseIn = 2*Rdisc + (1/178)*H; % inner width of hip disc mechanism case in x direction
                WdiscCaseOut = WdiscCaseIn + 2*TdiscCase; % outer width of hip disc mechanism case
                HdiscCaseIn = 2*Rdisc + (1/178)*H; % inner height of the disc mechanism case in the y direction
                HdiscCaseOut = HdiscCaseIn +2*TdiscCase; % outer height of the disc mechanism case 
                VdiscCase = (LdiscCaseOut * WdiscCaseOut * HdiscCaseOut) - (LdiscCaseIn * WdiscCaseIn * HdiscCaseIn) - (LdiscConnecter * WdiscConnecter * TdiscCase + WdiscCaseOut * (1/178)*H * TdiscCase); % volume of the case which surrounds the disc mechniams minus the holes for the connecters to fit through
                Vdisc = pi*Rdisc.^2*Wdisc; % volume of one of the discs 
                VdiscConnecter = LdiscConnecter * WdiscConnecter * HdiscConnecter; % volume of the disc connector
                Vshaft = (0.000056005/178)*H; % volume of the shaft connecting both discs

                obj.MdiscCase = VdiscCase * densityHDPE; % mass of the case surrounding the discs
                obj.Mdisc = Vdisc * densityAl; % mass of 1 of the discs
                obj.MdiscConnecter = VdiscConnecter * densityAl; % the mass of the piece that connects from the 2DOF joint to the lateral disc
                obj.Mshaft = Vshaft * densityAl; % mass of the shaft which supports both hip discs

                % The dimensions for the thigh strap which connects the upper leg to the device
                LthighStrapCaseSupport = (2/178)*H; % dimension of the strap case suppot in z direction...strap case support is the piece extending from the fram and connecting to the strap case
                WthighStrapCaseSupport = (1/178)*H; % dimension of the strap case support in x direction
                HthighStrapCaseSupport = (2/178)*H; % dimesnion of the strap case support in y direction
                Rthigh = (10/178)*H; % radius of the thigh obtained from the GUI
                RthighStrapCaseIn = Rthigh + (1/178)*H; % radius from center of the thigh to the inside of the strap casing
                TthighStrapCase = (0.5/178)*H; % thickness of the strap casing
                RthighStrapCaseOut = RthighStrapCaseIn + TthighStrapCase; % radius from the center of the thigh to the outside of the strap casing
                HthighStrapCase = (8/178)*H; % the height of the strap case in the y direction
                VthighStrapCaseSupport = LthighStrapCaseSupport * WthighStrapCaseSupport *HthighStrapCaseSupport; % volume of the support which connects the case to the leg
                VthighStrapCase = 0.5*pi*(RthighStrapCaseOut.^2 - RthighStrapCaseIn.^2) * HthighStrapCase; % volume of the leg strap case
                VthighStrapPadding = 0.5*pi*(RthighStrapCaseIn.^2 - Rthigh.^2) * HthighStrapCase; % volume of the padding in between the thigh and case

                obj.MthighStrapCaseSupport = VthighStrapCaseSupport * densityAl; % the mass of the support which connects the thigh strap to the leg
                obj.MthighStrapCase = VthighStrapCase * densityHDPE; % the mass of the case which wraps around the users thigh
                obj.MthighStrapPadding = VthighStrapPadding * densityFoam; % the mass of the foam padding which cushions the thigh against the case

                % the dimensions for the calf strap which connects the lower leg to the device
                LcalfStrapCaseSupport = (2/178)*H; % dimension of the strap case support in z direction...strap case support is the piece extending from the fram and connecting to the strap case
                WcalfStrapCaseSupport = (1/178)*H; % dimension of the strap case support in x direction
                HcalfStrapCaseSupport = (2/178)*H; % dimesnion of the strap case support in y direction
                Rcalf = (8/178)*H; % radius of the calf obtained from the GUI
                RcalfStrapCaseIn = Rcalf + (1/178)*H; % radius from center of the calf to the inside of the strap casing
                TcalfStrapCase = (0.5/178)*H; % thickness of the strap casing
                RcalfStrapCaseOut = RcalfStrapCaseIn + TcalfStrapCase; % radius from the center of the calf to the outside of the strap casing
                HcalfStrapCase = (8/178)*H; % the height of the strap case in the y direction
                VcalfStrapCaseSupport = LthighStrapCaseSupport * WthighStrapCaseSupport *HthighStrapCaseSupport; % volume of the support which connects the case to the leg
                VcalfStrapCase = 0.5*pi*(RcalfStrapCaseOut.^2 - RcalfStrapCaseIn.^2) * HcalfStrapCase; % volume of the leg strap case
                VcalfStrapPadding = 0.5*pi*(RcalfStrapCaseIn.^2 - Rcalf.^2) * HcalfStrapCase; % volume of the padding in between the calf and case

                obj.McalfStrapCaseSupport = VcalfStrapCaseSupport * densityAl; % the mass of the support which connects the calf strap to the leg
                obj.McalfStrapCase = VcalfStrapCase * densityHDPE; % the mass of the case which wraps around the users calf
                obj.McalfStrapPadding = VcalfStrapPadding * densityFoam; % the mass of the foam padding which cushions the calf against the case

                % the dimensions for the dorsiflexion spring mechanism and bar connecting
                % the hip disc to the top of the 4 bar linkage 
                HtopBar = 0.245*H - Lshaft1 + 0.5 * Hbearing1 - HDOFjoint - HdiscConnecter - 2*Rdisc - 0.00738034*H; % the distance from the medial disc in the hip mechanism to the top of the 4 bar linkage (y direction) and the 0.00738034H is the anthropometric distance between the center of the 4 bar link and the center of link3
                LtopBar = (1/178)*H; % the length of the top bar in the z direction
                WtopBar = (3/178)*H; % the width of the top bar in the x direction
                LoDorsiSpring = (3.08/178)*H; % the relaxed length of the dorsispring without including the hooks
                rDorsiSpring = (0.5/178)*H; % the radius of the hooks which support the dorsiflexion spring 
                LtotDorsiSpring = (LoDorsiSpring + 4*rDorsiSpring); % the total length of the dorsiflexion spring including the hooks
                dDorsiSpring = (0.12/178)*H; % the diameter of the dorsiflexion spring wire
                meanDdorsiSpring = (0.7/178)*H; % the mean diameter of the dorsiflexion spring coil
                OutDdorsiSpring = meanDdorsiSpring + dDorsiSpring; % the diameter to the outer edge of the dorsiflexion spring coil
                LdorsiSpringCaseIn = OutDdorsiSpring + (0.6/178)*H; % the dimension of the inside of the dorsiflexion spring case in the z direction
                LdorsiSpringCaseOut = LdorsiSpringCaseIn + (0.6/178)*H; % the dimension of the outside of the dorsiflexion springcase in the z direction assuming a case thickness of 3mm
                WdorsiSpringCaseIn = OutDdorsiSpring + (0.6/178)*H; % the dimension of the inside of the dorsiflexion spring case in the x direciton
                WdorsiSpringCaseOut = WdorsiSpringCaseIn + (0.6/178)*H; %the dimension of the outside of the dorsiflexion spring case in the x direction assuming a case thickness of 3mm
                HdorsiSpringCaseIn = LtotDorsiSpring + (0.6/178)*H; % the dimension of the inside of the spring case in the y direction allowing for 6mm of spring extension
                HdorsiSpringCaseOut = HdorsiSpringCaseIn + (0.3/178)*H % the dimension of the outside of the spring case in the y direction assuming a case thickness of 3mm
                VtopBar = HtopBar * LtopBar * WtopBar; % the volume of the top bar which connects the medial hip disc to the top of the 4 bar linkage
                VdorsiSpringCase = (LdorsiSpringCaseOut * WdorsiSpringCaseOut * HdorsiSpringCaseOut) - (LdorsiSpringCaseIn * WdorsiSpringCaseIn * HdorsiSpringCaseIn); % the volume of the case surrounding the spring

                obj.MtopBarPulley = 0.077111; % the mass of the pulley attached to the top bar (femur) [kg]
                obj.MtopBar = VtopBar * densityAl; % the mass of the top bar which connects the medial disc to link 3 of the 4 bar knee
                obj.MdorsiSpringCase = VdorsiSpringCase * densityHDPE; % mass of the case surrounding the dorsiflexion spring


                % the dimensions of the 4 bar linkage 
                Llink1 = (4.45/178)*H; % the length of the 4 bar link which is directly connected to the tibial bar (bot bar)
                Llink2 = (5.16/178)*H; % the length of the 4 bar link which connects to the anterior part of the tibia and the posterior part of the femur
                Llink3 = (4.09/178)*H; % the length of the 4 bar link which is directly connected to the femur bar (top bar)
                Llink4 = (4.72/178)*H; % the length ofthe 4 bar link which is connected at the posterior part of the tibia and the anterior part of the femur
                tLinks = (0.5/178)*H; % the thickness of the links...this dimension extends into the z direction
                wLinks = (1/178)*H; % the width of all of the links...this dimension is perpendicular to the length of the links
                vLinks = (Llink1 + Llink2 + Llink3 + Llink4) * tLinks * wLinks; % the combined volume of all of the links

                obj.mLinks = vLinks * densityAl; % total mass of the links used to create 4 bar pulley

                % the dimensions of the universal joint at the ankle 
                obj.MuniJoint = 0.077111; % the mass of the universal joint at the ankle [kg]
                HuniJoint = (5/178)*H; % the height of the universal joint in the y direction 

                % the dimensions of the bar connecting the bottom of the 4 bar link to the
                % ankle joint
                HbotBar = 0.246*H - 0.5*HuniJoint - 0.00763596*H; % the distance in the y direction between the ankle joint and the center of link1 where 0.00763596H is the anthropometric distance between the knee center and the center of link1
                LbotBar = (1/178)*H; % the length of the bar in the z direction
                WbotBar = (3/178)*H; % the width of the bar in the x direction
                VbotBar = HbotBar * LbotBar * WbotBar; % the total volume of bot bar

                obj.MbotBarPulley = 0.077111; % the mass of the pullet attached to the bot bar (tibia) [kg]
                obj.MbotBar = VbotBar * densityAl; % the mass of the bot bar which connects the universal ankle joint to link 1 of the 4 bar knee

                % the dimensions of the ankle bar and foot bar
                
                %total mass of everything below the 2 DOF hip joint
                obj.mBelow2DOFJoint = 0.5*obj.MDOFjoint + obj.MdiscConnecter + 2*obj.Mdisc + obj.Mshaft + obj.MdiscCase + obj.MthighStrapCaseSupport + obj.MthighStrapCase + obj.MthighStrapPadding + obj.McalfStrapCaseSupport + obj.McalfStrapCase + obj.McalfStrapPadding + obj.MtopBarPulley + obj.MtopBar + obj.MdorsiSpringCase + obj.mLinks + obj.MuniJoint + obj.MbotBarPulley + obj.MbotBar; % total mass of the leg which is being held up by the 2 DOF pin joint
        end

     end
end


%                 function Exoskeleton_Mass_Anthropometric()
%                 % NOTE: all length dimensions are in terms of meters, volumes are in m^3
%                 % and masses are in kg
% 
%                 %Height obtained from GUI
%                 H = 1.78;
%                 %Density of different materials in kg/m^3
%                 densityAl = 2700;
%                 densitySt = 8050;
%                 densityHDPE = 970;
%                 densityFoam = 48.06;
% 
%                 % dimensions of the belt which wraps around the users waist
%                 rBelt = (15/178)*H; % radius of the users waist will be obtained from the GUI
%                 hBelt = (7/178)*H; % the height of the belt extending in the y direction
%                 tBelt = (1/178)*H; % the thickness of the belt 
%                 vBelt = 0.5*pi*((rBelt + tBelt).^2 - rBelt.^2) * hBelt
% 
%                 mBelt = vBelt * densityAl; % the total mass of the the belt 
% 
%                 % Dimensions of bearing case
%                 Mbearing1 = 0.089; %this is either given or can caluclate later...took this from mcmastercarr
%                 Rbearing1Out = 0.042; %radius of outside of bearing
%                 Hbearing1 = 0.012; % height of bearing
%                 hLid1 = (1/178)*H; % lid height which covers bearing and case in cm
%                 Rcase1 = Rbearing1Out+(0.5/178)*H; % radius of case which covers bearing
%                 Rbearing1In = 0.02; % radius of inside of bearing
%                 Lshaft1 = Hbearing1 + hLid1 + (2/178)*H; % length of shaft in bearing
%                 Vbearing1Case = pi*(Rcase1.^2 - Rbearing1Out.^2)*hLid1 + pi*Rcase1.^2*hLid1; % volume of just case around bearing
%                 Vshaft1 = pi*(Rbearing1In.^2)*Lshaft1; % volume of hip shaft 1
% 
%                 Mbearing1Case = Vbearing1Case * densityAl; % the mass of the bearing case
%                 Mshaft1 = Vshaft1 * densityAl; % mass of the hip bearing shaft
% 
%                 % Dimensions of hip to bearing case mount....mount1 is where the screws are
%                 % and mount 2 extends to bearing case
%                 Lmount1 = (2/178)*H; %dimension which expands in the z direction
%                 Wmount1 = (6/178)*H; %dimension which expands in the x direction
%                 Hmount1 = (3/178)*H; %dimension which expands in the y direction
%                 Lmount2 = (4/178)*H; %dimension which expands in the z direction
%                 Wmount2 = (3/178)*H; %dimension which expands in the x direction
%                 Hmount2 = (3/178)*H; %dimension which expands in the y direction
%                 Vmount = (Lmount1 * Wmount1 * Hmount1) + (Lmount2 * Wmount2 * Hmount2); % total volume of the belt to bearing case mount
% 
%                 Mmount = Vmount * densityAl; % mass of the mount
% 
%                 %2 DOF joint which connects hip bearing case to hip disc case
%                 MDOFjoint = 0.07711; % mass of 2 DOF joint
%                 HDOFjoint = 0.05; % height of 2 DOF joint in the y directon
% 
%                 %The dimensions of the hip disc mechanism 
%                 LdiscConnecter = (4/178)*H; % dimension which expands in the z direction...discConnector connects 2 DOF joint to lateral disc
%                 WdiscConnecter = (2/178)*H; % dimension which expands in the x direction
%                 HdiscConnecter = (2/178)*H; % dimension which expands in the y direction
%                 Rdisc = (4/178)*H; % radius of the hip discs
%                 Wdisc = (2.19402/178)*H; % Width of the discs
%                 DistanceDiscs = (3.5/178)*H; % distance between the two discs 
%                 zt = (15.3/178)*H; % total length of the shaft
%                 TdiscCase = (0.5/178)*H; % thickness of the disc case
%                 LdiscCaseIn = zt; % inner length of the hip disc mechanism case expanding in the z direction
%                 LdiscCaseOut = LdiscCaseIn + 2*TdiscCase; % outer length of the hip disc mechanism case
%                 WdiscCaseIn = 2*Rdisc + (1/178)*H; % inner width of hip disc mechanism case in x direction
%                 WdiscCaseOut = WdiscCaseIn + 2*TdiscCase; % outer width of hip disc mechanism case
%                 HdiscCaseIn = 2*Rdisc + (1/178)*H; % inner height of the disc mechanism case in the y direction
%                 HdiscCaseOut = HdiscCaseIn +2*TdiscCase; % outer height of the disc mechanism case 
%                 VdiscCase = (LdiscCaseOut * WdiscCaseOut * HdiscCaseOut) - (LdiscCaseIn * WdiscCaseIn * HdiscCaseIn) - (LdiscConnecter * WdiscConnecter * TdiscCase + WdiscCaseOut * (1/178)*H * TdiscCase); % volume of the case which surrounds the disc mechniams minus the holes for the connecters to fit through
%                 Vdisc = pi*Rdisc.^2*Wdisc; % volume of one of the discs 
%                 VdiscConnecter = LdiscConnecter * WdiscConnecter * HdiscConnecter; % volume of the disc connector
%                 Vshaft = (0.000056005/178)*H; % volume of the shaft connecting both discs
% 
%                 MdiscCase = VdiscCase * densityHDPE; % mass of the case surrounding the discs
%                 Mdisc = Vdisc * densityAl; % mass of 1 of the discs
%                 MdiscConnecter = VdiscConnecter * densityAl; % the mass of the piece that connects from the 2DOF joint to the lateral disc
%                 Mshaft = Vshaft * densityAl; % mass of the shaft which supports both hip discs
% 
%                 % The dimensions for the thigh strap which connects the upper leg to the device
%                 LthighStrapCaseSupport = (2/178)*H; % dimension of the strap case suppot in z direction...strap case support is the piece extending from the fram and connecting to the strap case
%                 WthighStrapCaseSupport = (1/178)*H; % dimension of the strap case support in x direction
%                 HthighStrapCaseSupport = (2/178)*H; % dimesnion of the strap case support in y direction
%                 Rthigh = (10/178)*H; % radius of the thigh obtained from the GUI
%                 RthighStrapCaseIn = Rthigh + (1/178)*H; % radius from center of the thigh to the inside of the strap casing
%                 TthighStrapCase = (0.5/178)*H; % thickness of the strap casing
%                 RthighStrapCaseOut = RthighStrapCaseIn + TthighStrapCase; % radius from the center of the thigh to the outside of the strap casing
%                 HthighStrapCase = (8/178)*H; % the height of the strap case in the y direction
%                 VthighStrapCaseSupport = LthighStrapCaseSupport * WthighStrapCaseSupport *HthighStrapCaseSupport; % volume of the support which connects the case to the leg
%                 VthighStrapCase = 0.5*pi*(RthighStrapCaseOut.^2 - RthighStrapCaseIn.^2) * HthighStrapCase; % volume of the leg strap case
%                 VthighStrapPadding = 0.5*pi*(RthighStrapCaseIn.^2 - Rthigh.^2) * HthighStrapCase; % volume of the padding in between the thigh and case
% 
%                 MthighStrapCaseSupport = VthighStrapCaseSupport * densityAl; % the mass of the support which connects the thigh strap to the leg
%                 MthighStrapCase = VthighStrapCase * densityHDPE; % the mass of the case which wraps around the users thigh
%                 MthighStrapPadding = VthighStrapPadding * densityFoam; % the mass of the foam padding which cushions the thigh against the case
% 
%                 % the dimensions for the calf strap which connects the lower leg to the device
%                 LcalfStrapCaseSupport = (2/178)*H; % dimension of the strap case support in z direction...strap case support is the piece extending from the fram and connecting to the strap case
%                 WcalfStrapCaseSupport = (1/178)*H; % dimension of the strap case support in x direction
%                 HcalfStrapCaseSupport = (2/178)*H; % dimesnion of the strap case support in y direction
%                 Rcalf = (8/178)*H; % radius of the calf obtained from the GUI
%                 RcalfStrapCaseIn = Rcalf + (1/178)*H; % radius from center of the calf to the inside of the strap casing
%                 TcalfStrapCase = (0.5/178)*H; % thickness of the strap casing
%                 RcalfStrapCaseOut = RcalfStrapCaseIn + TcalfStrapCase; % radius from the center of the calf to the outside of the strap casing
%                 HcalfStrapCase = (8/178)*H; % the height of the strap case in the y direction
%                 VcalfStrapCaseSupport = LthighStrapCaseSupport * WthighStrapCaseSupport *HthighStrapCaseSupport; % volume of the support which connects the case to the leg
%                 VcalfStrapCase = 0.5*pi*(RcalfStrapCaseOut.^2 - RcalfStrapCaseIn.^2) * HcalfStrapCase; % volume of the leg strap case
%                 VcalfStrapPadding = 0.5*pi*(RcalfStrapCaseIn.^2 - Rcalf.^2) * HcalfStrapCase; % volume of the padding in between the calf and case
% 
%                 McalfStrapCaseSupport = VcalfStrapCaseSupport * densityAl; % the mass of the support which connects the calf strap to the leg
%                 McalfStrapCase = VcalfStrapCase * densityHDPE; % the mass of the case which wraps around the users calf
%                 McalfStrapPadding = VcalfStrapPadding * densityFoam; % the mass of the foam padding which cushions the calf against the case
% 
%                 % the dimensions for the dorsiflexion spring mechanism and bar connecting
%                 % the hip disc to the top of the 4 bar linkage 
%                 HtopBar = 0.245*H - Lshaft1 + 0.5 * Hbearing1 - HDOFjoint - HdiscConnecter - 2*Rdisc - 0.00738034*H; % the distance from the medial disc in the hip mechanism to the top of the 4 bar linkage (y direction) and the 0.00738034H is the anthropometric distance between the center of the 4 bar link and the center of link3
%                 LtopBar = (1/178)*H; % the length of the top bar in the z direction
%                 WtopBar = (3/178)*H; % the width of the top bar in the x direction
%                 LoDorsiSpring = (3.08/178)*H; % the relaxed length of the dorsispring without including the hooks
%                 rDorsiSpring = (0.5/178)*H; % the radius of the hooks which support the dorsiflexion spring 
%                 LtotDorsiSpring = (LoDorsiSpring + 4*rDorsiSpring); % the total length of the dorsiflexion spring including the hooks
%                 dDorsiSpring = (0.12/178)*H; % the diameter of the dorsiflexion spring wire
%                 meanDdorsiSpring = (0.7/178)*H; % the mean diameter of the dorsiflexion spring coil
%                 OutDdorsiSpring = meanDdorsiSpring + dDorsiSpring; % the diameter to the outer edge of the dorsiflexion spring coil
%                 LdorsiSpringCaseIn = OutDdorsiSpring + (0.6/178)*H; % the dimension of the inside of the dorsiflexion spring case in the z direction
%                 LdorsiSpringCaseOut = LdorsiSpringCaseIn + (0.6/178)*H; % the dimension of the outside of the dorsiflexion springcase in the z direction assuming a case thickness of 3mm
%                 WdorsiSpringCaseIn = OutDdorsiSpring + (0.6/178)*H; % the dimension of the inside of the dorsiflexion spring case in the x direciton
%                 WdorsiSpringCaseOut = WdorsiSpringCaseIn + (0.6/178)*H; %the dimension of the outside of the dorsiflexion spring case in the x direction assuming a case thickness of 3mm
%                 HdorsiSpringCaseIn = LtotDorsiSpring + (0.6/178)*H; % the dimension of the inside of the spring case in the y direction allowing for 6mm of spring extension
%                 HdorsiSpringCaseOut = HdorsiSpringCaseIn + (0.3/178)*H % the dimension of the outside of the spring case in the y direction assuming a case thickness of 3mm
%                 VtopBar = HtopBar * LtopBar * WtopBar; % the volume of the top bar which connects the medial hip disc to the top of the 4 bar linkage
%                 VdorsiSpringCase = (LdorsiSpringCaseOut * WdorsiSpringCaseOut * HdorsiSpringCaseOut) - (LdorsiSpringCaseIn * WdorsiSpringCaseIn * HdorsiSpringCaseIn); % the volume of the case surrounding the spring
% 
%                 MtopBarPulley = 0.077111; % the mass of the pulley attached to the top bar (femur) [kg]
%                 MtopBar = VtopBar * densityAl; % the mass of the top bar which connects the medial disc to link 3 of the 4 bar knee
%                 MdorsiSpringCase = VdorsiSpringCase * densityHDPE; % mass of the case surrounding the dorsiflexion spring
% 
% 
%                 % the dimensions of the 4 bar linkage 
%                 Llink1 = (4.45/178)*H; % the length of the 4 bar link which is directly connected to the tibial bar (bot bar)
%                 Llink2 = (5.16/178)*H; % the length of the 4 bar link which connects to the anterior part of the tibia and the posterior part of the femur
%                 Llink3 = (4.09/178)*H; % the length of the 4 bar link which is directly connected to the femur bar (top bar)
%                 Llink4 = (4.72/178)*H; % the length ofthe 4 bar link which is connected at the posterior part of the tibia and the anterior part of the femur
%                 tLinks = (0.5/178)*H; % the thickness of the links...this dimension extends into the z direction
%                 wLinks = (1/178)*H; % the width of all of the links...this dimension is perpendicular to the length of the links
%                 vLinks = (Llink1 + Llink2 + Llink3 + Llink4) * tLinks * wLinks; % the combined volume of all of the links
% 
%                 mLinks = vLinks * densityAl; % total mass of the links used to create 4 bar pulley
% 
%                 % the dimensions of the universal joint at the ankle 
%                 MuniJoint = 0.077111; % the mass of the universal joint at the ankle [kg]
%                 HuniJoint = (5/178)*H; % the height of the universal joint in the y direction 
% 
%                 % the dimensions of the bar connecting the bottom of the 4 bar link to the
%                 % ankle joint
%                 HbotBar = 0.246*H - 0.5*HuniJoint - 0.00763596*H; % the distance in the y direction between the ankle joint and the center of link1 where 0.00763596H is the anthropometric distance between the knee center and the center of link1
%                 LbotBar = (1/178)*H; % the length of the bar in the z direction
%                 WbotBar = (3/178)*H; % the width of the bar in the x direction
%                 VbotBar = HbotBar * LbotBar * WbotBar; % the total volume of bot bar
% 
%                 MbotBarPulley = 0.077111; % the mass of the pullet attached to the bot bar (tibia) [kg]
%                 MbotBar = VbotBar * densityAl; % the mass of the bot bar which connects the universal ankle joint to link 1 of the 4 bar knee
% 
%                 % the dimensions of the ankle bar and foot bar




% end