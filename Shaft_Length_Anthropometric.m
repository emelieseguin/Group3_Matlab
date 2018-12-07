classdef Shaft_Length_Anthropometric
    properties
        %% Material Properties
        %Density of shaft material in kg/m^3
        DensityAl = 2700;
        DensitySt = 8050;
        
        %% Distances of force from 0 
        supportDist1
        zShaftLength
        
        %% Dimensions of the shaft to build it in solidworks
        dp1
        dp2
        dp3
        dp4
        dp5
        dp6
        dp7
        dp8
        dp9
        distFromZ9_Z11
        distFromZ6_Z9
        distFromZ6_Z3
        distFromZ5_Z3
        distFromZ11_Z10
        distFromZ5_Z9
        distFromZ10_Z5
        
        lShaftKeyHip
        wShaftKeyHip
        hShaftKeyHip
        
        %% Distances corresponding to mass of components
        casingDist1
        retainingRingDist1
        keyDist
        springDist
        comOfShaftDist
        bearingDist
        exoLegDist
        retainingRingDist2
        casingDist2
        
        %% Masses needed for SFBM Diagrams
        mRetainingRing1
        mRetainingRing2
        mShaftKeyHip
        weightShaft
        
        %% Shaft Diameters
        diameter3
    end
    methods 
        function obj = Shaft_Length_Anthropometric(patientHeight, diameterHipTorsionSpring, ...
                wireDiameterSpring, lengthSuppLeg, lengthHipSpring)
            
            %Different diameters along shaft based on a percentage
             dp4 = diameterHipTorsionSpring; % Already param in HipTorsionSpring.m
            
            dp1 = dp4 - (0.0048/1.78)*patientHeight;
            dp2 = dp4 - (0.0078/1.78)*patientHeight;
            dp3 = dp4 - (0.0048/1.78)*patientHeight;
            obj.dp3 = dp3;
            dp5 = dp4 - (0.0048/1.78)*patientHeight;
            dp6 = dp4 - (0.0078/1.78)*patientHeight;
            dp7 = dp4 - (0.0048/1.78)*patientHeight;
            
            filletDimension = 0.1*dp3;
            
            % Different points along shaft based on a percentage
            z1 = 0;
            z2 = z1 + (0.005/1.78)*patientHeight;
            obj.casingDist1 = (z1+z2)/2;
            
            z3 = z2 + (0.001/1.78)*patientHeight;
            obj.retainingRingDist1 = (z2+z3)/2;
            
            z4 = z3 + (0.010/1.78)*patientHeight;
            obj.keyDist = (z3+z4)/2;
            
            z5 = z4 + (0.004/1.78)*patientHeight;
            obj.supportDist1 = (z3+z5)/2;
            
            z6 = z5 + filletDimension;
            z7 = z6+lengthHipSpring;
            
            z8 = z7+wireDiameterSpring;
            obj.springDist = (z8+z6)/2;
            
            z7Point5 = (z7+z8)/2;
            
            z9 = z8 + (0.005/1.78)*patientHeight;
            z10 = z9 + filletDimension;
            z11 = z10 + (0.01/1.78)*patientHeight;
            obj.bearingDist = (z10+z11)/2;
            obj.exoLegDist = (z10+z11)/2;
            z12 = z11 + (0.001/1.78)*patientHeight;
            obj.retainingRingDist2 = (z11+z12)/2;
            z13 = z12 + (0.005/1.78)*patientHeight;
            obj.zShaftLength = z13;
            obj.casingDist2 = (z12+z13)/2;
            
            distFromZ2_Z1 = z2-z1;
            distFromZ3_Z2 = z3-z2;
            distFromZ6_Z3 = z6-z3;
            %% We need stuff from torsion spring to build this -- from Em
            distFromZ6_Z9 = z9-z6;
            distFromZ9_Z11 = z11-z9;
            distFromZ11_Z12 = z12-z11;
            distFromZ12_Z13 = z13-z12;
            distFromZ8_Z7 = z8-z7;
            distFromZ5_Z3 = z5-z3;
            distFromZ11_Z10 = z11 - z10;
            distFromZ5_Z9 = z9 - z5;
            
            %% More calcs
            % Summation of masses and there centers of mass
            mizi = (obj.DensityAl*pi/4)*(((dp1.^2)*(distFromZ2_Z1)*(z1+((distFromZ2_Z1)/2)) + (dp2.^2)*(z3-z2)*(z2+((z3-z2)/2)) + (dp3.^2)*(z5-z3)*(z3+((z5-z3)/2))+ (dp4.^2)*(z9-z6)*(z6+((z9-z6)/2))+(dp5.^2)*(z11-z10)*(z10+((z11-z10)/2))+(dp6.^2)*(z12-z11)*(z11+((z12-z11)/2))+(dp7.^2)*(z13-z12)*(z12+((z13-z12)/2))));
            % Total mass of the shaft
            mtot = (obj.DensityAl*pi/4)*((dp1.^2)*(distFromZ2_Z1) + (dp2.^2)*(z3-z2) + (dp3.^2)*(z5-z3)+ (dp4.^2)*(z9-z6)+ (dp5.^2)*(z11-z10)+ (dp6.^2)*(z12-z11)+ (dp7.^2)*(z13-z12));
            obj.weightShaft = mtot;
            % Volume of the shaft
            vtot = (pi/4) * ((dp1.^2)*(z2-z1) + (dp2.^2)*(z3-z2) + (dp3.^2)*(z5-z3)+ (dp4.^2)*(z9-z6)+ (dp5.^2)*(z11-z10)+ (dp6.^2)*(z12-z11)+ (dp7.^2)*(z13-z12));
            % Center of mass for entire shaft
            ztot = mizi/mtot;
            obj.comOfShaftDist = ztot;

            % Dimensions of retaining rings
            lRetainingRing1 = (0.5/178)*patientHeight;
            rRetainingRing1Out = 0.5*dp2 + (0.24/178)*patientHeight; 
            vRetainingRing1 = lRetainingRing1 * pi * (rRetainingRing1Out.^2 - (0.5 * dp2).^2); % Volume of retaining ring 1
            lRetainingRing2 = (0.5/178)*patientHeight; % the thickness of the retaing ring in the z direction
            rRetainingRing2Out = 0.5*dp6 + (0.24/178)*patientHeight; 
            vRetainingRing2 = lRetainingRing2 * pi * (rRetainingRing2Out.^2 - (0.5 * dp6).^2); % Volume of retaining ring 1
            obj.mRetainingRing1 = vRetainingRing1 * obj.DensityAl; % Mass of retaining ring 1
            obj.mRetainingRing2 = vRetainingRing2 * obj.DensityAl; % Mass of retaining ring 2
            % Dimensions of the key
            lShaftKeyHip = z4 - z3; % the length of the key in the z direction along the shaft
            wShaftKeyHip = (0.5/178)*patientHeight; % the width of the key in the x direction
            hShaftKeyHip = (0.5/178)*patientHeight; % the height of the key in the y direction
            vShaftKeyHip = lShaftKeyHip * wShaftKeyHip * hShaftKeyHip; % volume of the key
            obj.mShaftKeyHip = vShaftKeyHip * obj.DensityAl; % mass of the key

            %% Distances along the shaft used to build the shaft in solidworks                       
            distFromZ6_Z9 = z9-z6;
            distFromZ9_Z11 = z11-z9;
            distFromZ11_Z12 = z12-z11;
            distFromZ12_Z13 = z13-z12;
            distFromZ10_Z5 = z10-z5;
            obj.diameter3 = dp3;
            
            %% Add diameters to the object
            obj.dp1 = dp1;
            obj.dp5 = dp5;
            obj.distFromZ9_Z11 = distFromZ9_Z11;
            obj.distFromZ6_Z9 = distFromZ6_Z9; 
            obj.distFromZ6_Z3 = distFromZ6_Z3;
            obj.distFromZ5_Z3 = distFromZ5_Z3;
            obj.distFromZ11_Z10 = distFromZ11_Z10;
            obj.distFromZ5_Z9 = distFromZ5_Z9;
            obj.distFromZ10_Z5 = distFromZ10_Z5;
            
            obj.lShaftKeyHip = lShaftKeyHip;
            obj.wShaftKeyHip = wShaftKeyHip;
            obj.hShaftKeyHip = hShaftKeyHip;
            
            
            %% Print the shaft to a text file
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\hipShaftDimensions.txt','w');
                fprintf(fileID, '"distFromZ2_Z1"= %f\n', distFromZ2_Z1);
                fprintf(fileID, '"hipShaftDiam1"= %f\n', dp1);
                fprintf(fileID, '"distFromZ3_Z2"= %f\n', distFromZ3_Z2);
                fprintf(fileID, '"hipShaftDiam2"= %f\n', dp2);
                fprintf(fileID, '"distFromZ6_Z3"= %f\n', distFromZ6_Z3);
                fprintf(fileID, '"hipShaftDiam3"= %f\n', dp3);
                fprintf(fileID, '"hipShaftRadius3"= %f\n', dp3/2);
                fprintf(fileID, '"distFromZ6_Z9"= %f\n', distFromZ6_Z9);
                fprintf(fileID, '"distZ7"= %f\n', z7);
                fprintf(fileID, '"distFromZ8_Z7"= %f\n', distFromZ8_Z7);                
                fprintf(fileID, '"hipShaftDiam4"= %f\n', dp4);
                fprintf(fileID, '"distFromZ9_Z11"= %f\n', distFromZ9_Z11);
                fprintf(fileID, '"hipShaftDiam5"= %f\n', dp5);
                fprintf(fileID, '"distFromZ11_Z12"= %f\n', distFromZ11_Z12);
                fprintf(fileID, '"hipShaftDiam6"= %f\n', dp6);
                fprintf(fileID, '"distFromZ12_Z13"= %f\n', distFromZ12_Z13);
                fprintf(fileID, '"hipShaftDiam7"= %f\n', dp7);
                fprintf(fileID, '"lShaftKeyHip"= %f\n', lShaftKeyHip);
                fprintf(fileID, '"wShaftKeyHip"= %f\n', wShaftKeyHip);
                fprintf(fileID, '"hShaftKeyHip"= %f\n', hShaftKeyHip);
                fprintf(fileID, '"lengthSuppLeg"= %f\n', lengthSuppLeg);
                fprintf(fileID, '"z7Point5"= %f\n', z7Point5);
            fclose(fileID);
        end
    end
end
