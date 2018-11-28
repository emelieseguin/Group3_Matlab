classdef footMechanism
    properties
        
    end
    methods
        function obj = footMechanism(patientHeight)
            
            lFoot = round(0.152*patientHeight, 6);
            wFoot = round(0.055*patientHeight, 6);
            %heelToAnkle = 0.039*patientHeight;
            
            %% Inner Rigid Piece
            dInnerHeel = wFoot;
            rInnerHeel = wFoot/2;
            dRigidHeel = wFoot+((0.01/1.78)*patientHeight);
            rRigidHeel = dRigidHeel/2;
            rHalfRigid = rRigidHeel/2;
            loftingDimension1 = dRigidHeel-(0.01/1.78)*patientHeight;
            hBackHeelPieceRigid = (0.05/1.78)*patientHeight;
            hBackHeelPieceOuter = hBackHeelPieceRigid - 0.025;
            
            dFromZ1_Z6 = round(lFoot - rInnerHeel, 6);
            dFromZ1_Z2 = ((0.15*dFromZ1_Z6)/1.78)*patientHeight;
            dFromZ2_Z3 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight;
            dFromZ3_Z4 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight;
            dFromZ4_Z5 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight;
            dFromZ5_Z6 = ((0.10*dFromZ1_Z6)/1.78)*patientHeight;
            
            dFromZ2_Z4 = dFromZ2_Z3 + dFromZ3_Z4;
            dFromZ2_Z4_wEdge = dFromZ2_Z4+0.0025;
            dFromZ2_Z3_Over2 = dFromZ2_Z3/2;
            
            lWideRigidPiece = (0.05/1.78)*patientHeight;
            lNarrowRigidPiece = (0.05/1.78)*patientHeight;
            
            strapWidth = dRigidHeel - 0.002;
            
            %% Soft Outer Piece
            dSoftHeel = wFoot+((0.02/1.78)*patientHeight);
            rSoftHeel = dSoftHeel/2;
            loftingDimension2 = dSoftHeel-(0.01/1.78)*patientHeight;
            
            %% Often Used Dimensions
            d1 = (0.0025/1.78)*patientHeight;
            d2 = (0.005/1.78)*patientHeight;
            d3 = (0.0075/1.78)*patientHeight;
            d4 = (0.01/1.78)*patientHeight;
            d5 = (0.015/1.78)*patientHeight;
            d6 = (0.02/1.78)*patientHeight;
            d7 = (0.05/1.78)*patientHeight;
            d8 = (0.06/1.78)*patientHeight;
            d9 = (0.00485/1.78)*patientHeight;
            d10 = (0.0015/1.78)*patientHeight;
            d11 = (0.0035/1.78)*patientHeight;
            d12 = (0.002/1.78)*patientHeight;
            d13 = (0.012/1.78)*patientHeight;
            d14 = (0.035/1.78)*patientHeight;
            d15 = (0.006/1.78)*patientHeight;
            d16 = (0.04/1.78)*patientHeight;
            d17 = (0.008/1.78)*patientHeight;
            d18 = (0.1/1.78)*patientHeight;
            d19 = (0.025/1.78)*patientHeight;
            d20 = (0.15/1.78)*patientHeight;
            d21 = (0.004/1.78)*patientHeight;
            
            %% Rigid Piece Volume Calculations
            v1 = (1/4)*(4/3)*pi*((rRigidHeel^3)-(rInnerHeel^3));
            v2 = (1/2)*pi*((rRigidHeel^2)-(rInnerHeel^2))*(hBackHeelPieceRigid);
            v3 = 0.005*dRigidHeel*dFromZ2_Z3;
            v4 = 2*0.005*(0.0025^2)+(1/2)*(loftingDimension1+0.01)*0.0075*0.0025;
            v5 = 0.005*rRigidHeel*dFromZ3_Z4;
            v6 = 2*0.01*0.0025*dFromZ2_Z3;
            v7 = 2*(0.005^2)*dFromZ2_Z3;
            v8 = 2*(0.015^2)*0.01;
            v9 = -2*0.005*0.015*0.02;
            v10 = -4*pi*(0.0025^2)*0.005;
            v11 = 2*(0.05^2)*0.005+(pi/2)*((rRigidHeel^2)-(rInnerHeel^2))*0.05;
            v12 = (1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2));
            %v13 = 0.005*wPiece*0.001-(1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2));
            v14 = 0; %volume of the loft, not sure how  to calculate yet
            
            %% Outer Piece Volume Calculations
            v15 = (1/4)*(4/3)*pi*((rSoftHeel^3)-(rInnerHeel^3));
            v16 = (1/2)*pi*((rSoftHeel^2)-(rRigidHeel^2))*hBackHeelPieceOuter;
            v17 = dSoftHeel*0.005*dFromZ2_Z4;
            v18 = 2*0.005*(0.0025^2)+(1/2)*(loftingDimension2+0.01)*0.0075*0.0025;
            v19 = 2*(0.005^2)*0.0025;
            v20 = 0.005*0.002;
            v21 = dFromZ2_Z4*dSoftHeel*0.05;
            v22 = -(dFromZ2_Z3*dRigidHeel+0.0025*dRigidHeel+dFromZ3_Z4*rRigidHeel)*0.0049;
            v23 = 0.01*dFromZ4_Z5*dSoftHeel;
            v24 = -0.015*0.005*dSoftHeel;
            v25 = -2*0.01*0.015*0.005;
            v26 = (1/2)*pi*dFromZ5_Z6^2*0.01;
            
            %% Strap Connector Piece Volume Calculations
            v27 = 0.005*0.015*0.35;
            v28 = -0.002*0.012*0.35;
            v29 = -2*pi*0.0015*0.0025^2;
            v30 = -2*0.0015*pi*0.001^2;
            
            %% Strap Insert Piece Volume Calculations
            v31 = 0.012*0.002*0.04;
            v32 = -0.002*pi*(0.0025^2);
            v33 = -7*0.002*pi*0.001^2;
            
            %% Strap Piece Volume Calculations
            v34 = 2*0.025*0.005+(pi/2)*0.005^2;
            v35 = 2*pi*0.005*0.0025^2;
            
            %% Toe Insert Piece Volume Calculations
            v36 = dSoftHeel*0.015*0.005;
            v37 = 2*0.002*0.01*0.015;
            v38 = -2*0.02*0.005*0.015;
            v39 = -2*0.005*pi*0.0025^2;
            
            %% Total Volume of the Foot Mechanism
            vTotal = v1+v2+v3+v4+v5+v6+v7+v8+v9+v10+v11+v12+v15+v16 ...
                +v17+v18+v19+v20+v21+v22+v23+v24+v25+v26+v27+v28+v29+v30 ...
                +v31+v32+v33+v34+v35+v36+v37+v38+v39; %missing v13
            
            %% Rigid Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footRigidPieceDimensions.txt', 'w');
                fprintf(fileID, '"dInnerHeel" = %7.7f\n', dInnerHeel);
                fprintf(fileID, '"rInnerHeel" = %7.7f\n', dInnerHeel/2);
                fprintf(fileID, '"dRigidHeel" = %7.7f\n', dRigidHeel);
                fprintf(fileID, '"rRigidHeel" = %7.7f\n', dRigidHeel/2);
                fprintf(fileID, '"hBackHeelPieceRigid" = %7.7f\n', hBackHeelPieceRigid);
                fprintf(fileID, '"loftingDimension1" = %7.7f\n', loftingDimension1);
                fprintf(fileID, '"rHalfRigid" = %7.7f\n', rHalfRigid);
                fprintf(fileID, '"dFromZ1_Z2" = %7.7f\n', dFromZ1_Z2);
                fprintf(fileID, '"dFromZ2_Z3" = %7.7f\n', dFromZ2_Z3);
                fprintf(fileID, '"dFromZ3_Z4" = %7.7f\n', dFromZ3_Z4);
                fprintf(fileID, '"dFromZ4_Z5" = %7.7f\n', dFromZ4_Z5);
                fprintf(fileID, '"dFromZ5_Z6" = %7.7f\n', dFromZ5_Z6);
                fprintf(fileID, '"dFromZ2_Z3_Over2" = %7.7f\n', dFromZ2_Z3_Over2);
                fprintf(fileID, '"dimension1" = %7.7f\n', d1);
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension3" = %7.7f\n', d3);
                fprintf(fileID, '"dimension4" = %7.7f\n', d4);
                fprintf(fileID, '"dimension5" = %7.7f\n', d5);
                fprintf(fileID, '"dimension6" = %7.7f\n', d6);
                fprintf(fileID, '"dimension7" = %7.7f\n', d7);
                fprintf(fileID, '"dimension8" = %7.7f\n', d8);
            fclose(fileID);
            
            %% Outer Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footOuterPieceDimensions.txt', 'w');
                fprintf(fileID, '"dSoftHeel" = %7.7f\n', dSoftHeel);
                fprintf(fileID, '"rSoftHeel" = %7.7f\n', dSoftHeel/2);
                fprintf(fileID, '"dRigidHeel" = %7.7f\n', dRigidHeel);
                fprintf(fileID, '"rRigidHeel" = %7.7f\n', dRigidHeel/2);
                fprintf(fileID, '"hBackHeelPieceOuter" = %7.7f\n', hBackHeelPieceOuter);
                fprintf(fileID, '"loftingDimension2" = %7.7f\n', loftingDimension2);
                fprintf(fileID, '"dFromZ1_Z2" = %7.7f\n', dFromZ1_Z2);
                fprintf(fileID, '"dFromZ2_Z3" = %7.7f\n', dFromZ2_Z3);
                fprintf(fileID, '"dFromZ3_Z4" = %7.7f\n', dFromZ3_Z4);
                fprintf(fileID, '"dFromZ4_Z5" = %7.7f\n', dFromZ4_Z5);
                fprintf(fileID, '"dFromZ5_Z6" = %7.7f\n', dFromZ5_Z6);
                fprintf(fileID, '"dFromZ2_Z4" = %f\n', dFromZ2_Z4);
                fprintf(fileID, '"dimension1" = %7.7f\n', d1);
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension3" = %7.7f\n', d3);
                fprintf(fileID, '"dimension4" = %7.7f\n', d4);
                fprintf(fileID, '"dimension5" = %7.7f\n', d5);
                fprintf(fileID, '"dimension6" = %7.7f\n', d6);
                fprintf(fileID, '"dimension7" = %7.7f\n', d7);
                fprintf(fileID, '"dimension8" = %7.7f\n', d8);
                fprintf(fileID, '"dimension9" = %7.7f\n', d9);
            fclose(fileID);
            
            %% Side Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footSidePieceDimensions.txt', 'w');
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension5" = %7.7f\n', d5);
                fprintf(fileID, '"dimension10" = %7.7f\n', d10);
                fprintf(fileID, '"dimension11" = %7.7f\n', d11);
                fprintf(fileID, '"dimension14" = %7.7f\n', d14);
            fclose(fileID);
            
            %% Strap Insert Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footInsertPieceDimensions.txt', 'w');
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension12" = %7.7f\n', d12);
                fprintf(fileID, '"dimension13" = %7.7f\n', d13);
                fprintf(fileID, '"dimension15" = %7.7f\n', d15);
                fprintf(fileID, '"dimension16" = %7.7f\n', d16);
                fprintf(fileID, '"dimension17" = %7.7f\n', d17);
                fprintf(fileID, '"dimension21" = %7.7f\n', d21);
            fclose(fileID);
            
            %% Ankle Strap Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footAnkleStrapPieceDimensions.txt', 'w');
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension3" = %7.7f\n', d3);
                fprintf(fileID, '"dimension6" = %7.7f\n', d6);
                fprintf(fileID, '"dimension18" = %7.7f\n', d18);
                fprintf(fileID, '"dimension19" = %7.7f\n', d19);
                fprintf(fileID, '"strapWidth" = %7.7f\n', strapWidth);
            fclose(fileID);
            
            %% Toe Strap Piece File
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footToeStrapPieceDimensions.txt', 'w');
                fprintf(fileID, '"dimension1" = %7.7f\n', d1);
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension3" = %7.7f\n', d3);
                fprintf(fileID, '"dimension4" = %7.7f\n', d4);
                fprintf(fileID, '"dimension5" = %7.7f\n', d5);
                fprintf(fileID, '"dimension6" = %7.7f\n', d6);
                fprintf(fileID, '"dimension16" = %7.7f\n', d16);
                fprintf(fileID, '"dimension20" = %7.7f\n', d20);
                fprintf(fileID, '"strapWidth" = %7.7f\n', strapWidth);
            fclose(fileID);
            
            %% Toe Insert Piece
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footToeInsertPieceDimensions.txt', 'w');
                fprintf(fileID, '"dimension1" = %7.7f\n', d1);
                fprintf(fileID, '"dimension2" = %7.7f\n', d2);
                fprintf(fileID, '"dimension3" = %7.7f\n', d3);
                fprintf(fileID, '"dimension4" = %7.7f\n', d4);
                fprintf(fileID, '"dimension5" = %7.7f\n', d5);
                fprintf(fileID, '"dimension6" = %7.7f\n', d6);
                fprintf(fileID, '"dSoftHeel" = %7.7f\n', dSoftHeel);
            fclose(fileID);
            
        end
    end
end