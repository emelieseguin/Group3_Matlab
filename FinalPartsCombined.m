function FinalPartsCombined(patientHeight, hipShaft, dorsiCablePosition)
%% Set Up Equations for Length of Segments in final assembly 
 
 ThighLength= (0.245*patientHeight); %??read in from main?? 
 ShankLength= (0.246*patientHeight); %??read in from main??
 FootHeight = (0.039*patientHeight);
 
 percentDownThigh = dorsiCablePosition.thighPulleyPercentDownThigh;
 percentDownShank = dorsiCablePosition.shankPullyPercentDownShank;
 
 PulleyFromProximalHip = percentDownThigh*ThighLength;
 PulleyFromProximalKnee = percentDownShank*ShankLength;

ThighCom =  0.433*ThighLength;
ShankCom =  0.433*ShankLength;

 
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\LengthOfSegmentsInAssembly.txt', 'w');
                fprintf(fileID, '"ThighLength" = %7.7f\n', ThighLength);
                fprintf(fileID, '"ShankLength" = %7.7f\n', ShankLength);
                fprintf(fileID, '"FootHeight" = %7.7f\n', FootHeight);
                fprintf(fileID, '"ThighCom" = %7.7f\n', ThighCom);
                fprintf(fileID, '"ShankCom" = %7.7f\n', ShankCom);
                fprintf(fileID, '"PulleyFromProximalHip" = %7.7f\n', PulleyFromProximalHip);
                fprintf(fileID, '"PulleyFromProximalKnee" = %7.7f\n', PulleyFromProximalKnee);
                
            fclose(fileID);

%% MetalHipAttachmentsDimension.txt variables
hipInnerDiameter=(0.3/1.78) * patientHeight; %could be inputed value rest of dimensions need to be based off this one 
hipOuterDiameter=hipInnerDiameter + ((0.02/1.78) * patientHeight);%
hipInnerRadius=(0.17/1.78)* patientHeight;%
hipBeltThickness=(0.06/1.78)* patientHeight;%
lengthBackBar=(0.25/1.78)* patientHeight;%
lengthCenterlineToPlane=(lengthBackBar/2) + (hipInnerRadius - ((0.04/1.78)*patientHeight));%
distanceToAttachmentBar= (hipBeltThickness/2);%
radiusOfAttachmentBar= (0.03/1.78)*patientHeight;%
heightOfAttachmentBar= (hipBeltThickness/3);%
heightExtrudeCut1= hipBeltThickness/3;%
boltAttachmentDiameter=(0.008/1.78)*patientHeight;%
filletRadiusMetalHip= (0.0025/1.78)*patientHeight;

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\MetalHipAttachmentsDimension.txt','w');
        fprintf(fileID, '"hipInnerDiameter"= %f\n', hipInnerDiameter);
        fprintf(fileID, '"hipOuterDiameter"= %f\n', hipOuterDiameter);
        fprintf(fileID, '"hipBeltThickness"= %f\n', hipBeltThickness);
        fprintf(fileID, '"hipInnerRadius"= %f\n', hipInnerRadius);
        fprintf(fileID, '"lengthBackBar"= %f\n', lengthBackBar);
        fprintf(fileID, '"lengthCenterlineToPlane"= %f\n', lengthCenterlineToPlane);
        fprintf(fileID, '"distanceToAttachmentBar"= %f\n', distanceToAttachmentBar);
        fprintf(fileID, '"radiusOfAttachmentBar"= %f\n', radiusOfAttachmentBar);
        fprintf(fileID, '"heightExtrudeCut1"= %f\n', heightExtrudeCut1);
        fprintf(fileID, '"boltAttachmentDiameter"= %f\n', boltAttachmentDiameter);
        fprintf(fileID, '"heightOfAttachmentBar"= %f\n', heightOfAttachmentBar);      
        fprintf(fileID, '"filletRadiusMetalHip"= %f\n', filletRadiusMetalHip);      

    fclose(fileID);          

    
%% HipPadding.txt Variables 
hipBeltThickness=(0.06/1.78)* patientHeight;%
paddingOuterDiameter= hipInnerDiameter;%
paddingInnerDiameter= paddingOuterDiameter- ((0.04/1.78)* patientHeight);%
hipPaddingThickness=(0.15/1.78)* patientHeight;%
hipInnerRadius=(0.17/1.78)* patientHeight;%
heightExtrudeCut1= hipBeltThickness/3;%
metalHipAttachmentsThickness= (hipOuterDiameter - hipInnerDiameter)/2;%
lengthBackBar=(0.25/1.78)* patientHeight;%
thirdHipPaddingThickness= hipPaddingThickness/3;%
halfHipPaddingThickness=hipPaddingThickness/2;%
backPadRadius1=(0.12/1.78)*patientHeight;%
backPadRadius2=(0.06/1.78)*patientHeight;%
distanceTopofPad=(0.04/1.78)*patientHeight;%
widthOfRadius1=(0.03/1.78)*patientHeight;
heightRadius1=(0.016/1.78)*patientHeight;%
heightExtrudeCut2=(0.02/1.78)*patientHeight;
distanceBottomofPad=(0.015/1.78)*patientHeight;
distanceTopOfPadPoint1=(0.006/1.78)*patientHeight;
distanceTopOfPadPoint2=(0.003/1.78)*patientHeight;%

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\HipPadding.txt','w');
       fprintf(fileID, '"hipBeltThickness"= %f\n', hipBeltThickness);
       fprintf(fileID, '"paddingInnerDiameter"= %f\n', paddingInnerDiameter);
       fprintf(fileID, '"paddingOuterDiameter"= %f\n', paddingOuterDiameter);
       fprintf(fileID, '"hipPaddingThickness"= %f\n', hipPaddingThickness);
       fprintf(fileID, '"heightExtrudeCut1"= %f\n', heightExtrudeCut1);
       fprintf(fileID, '"halfHipPaddingThickness"= %f\n', halfHipPaddingThickness);
       fprintf(fileID, '"metalHipAttachmentsThickness"= %f\n', metalHipAttachmentsThickness);
       fprintf(fileID, '"lengthBackBar"= %f\n', lengthBackBar);
       fprintf(fileID, '"hipInnerRadius"= %f\n', hipInnerRadius);
       fprintf(fileID, '"thirdHipPaddingThickness"= %f\n', thirdHipPaddingThickness);
       fprintf(fileID, '"halfHipBeltThickness"= %f\n', halfHipPaddingThickness);
       fprintf(fileID, '"backPadRadius1"= %f\n', backPadRadius1);
       fprintf(fileID, '"backPadRadius2"= %f\n', backPadRadius2);
       fprintf(fileID, '"distanceTopofPad"= %f\n', distanceTopofPad);
       fprintf(fileID, '"heightExtrudeCut2"= %f\n', heightExtrudeCut2);
       fprintf(fileID, '"distanceBottomofPad"= %f\n', distanceBottomofPad);
       fprintf(fileID, '"distanceTopOfPadPoint1"= %f\n', distanceTopOfPadPoint1);
       fprintf(fileID, '"distanceTopOfPadPoint2"= %f\n', distanceTopOfPadPoint2);
       fprintf(fileID, '"widthOfRadius1"= %f\n', widthOfRadius1);
       fprintf(fileID, '"heightRadius1"= %f\n', heightRadius1);
       
    fclose(fileID);
%% Hip2DOFJointBearing.txt Variables 
notchLength1=(0.00047625/1.78)*patientHeight;
notchAngle1=(45.0);
revolve1Distance1=(0.00195385/1.78)*patientHeight;
cylindricalRevolveDistance=(0.00423333/1.78)*patientHeight;
revolve1Length=(0.053975/1.78)*patientHeight;
revolve1Length2=(0.028575/1.78)*patientHeight;
revolve1Width1=(0.009525/1.78)*patientHeight;

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\Hip2DOFJointBearing.txt','w');
        fprintf(fileID, '"notchLength1"= %f\n', notchLength1);
        fprintf(fileID, '"notchAngle1"= %f\n', notchAngle1);
        fprintf(fileID, '"revolve1Distance1"= %f\n', revolve1Distance1);
        fprintf(fileID, '"cylindricalRevolveDistance"= %f\n', cylindricalRevolveDistance);
        fprintf(fileID, '"revolve1Length"= %f\n', revolve1Length);
        fprintf(fileID, '"revolve1Length2"= %f\n', revolve1Length2);
        fprintf(fileID, '"revolve1Width1"= %f\n', revolve1Width1);
    fclose(fileID);
 
%% Hip2DOFJointShaft.txt Variables 
shaftDiameter1=(0.028575/1.78)*patientHeight; 
shaftShoulderDiameter=(revolve1Length2+revolve1Width1);
shaftShoulderLength=(0.01/1.78)*patientHeight;
shaftLength=(0.045/1.78)*patientHeight;
pinDiameter=(0.008/1.78)*patientHeight;
pinHeightFromShaftBase=(0.012/1.78)*patientHeight;
cutlength=(0.05/1.78)*patientHeight;
cutWidth=(0.0142875/1.78)*patientHeight;
cutRadius=(0.01/1.78)*patientHeight;
connectorLength=(cutlength/2);
cutHeight=(0.018/1.78)*patientHeight;

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\Hip2DOFJointShaft.txt','w');
        fprintf(fileID, '"shaftDiameter1"= %f\n', shaftDiameter1);
        fprintf(fileID, '"shaftShoulderDiameter"= %f\n', shaftShoulderDiameter);
        fprintf(fileID, '"shaftShoulderLength"= %f\n', shaftShoulderLength);
        fprintf(fileID, '"shaftLength"= %f\n', shaftLength);
        fprintf(fileID, '"pinDiameter"= %f\n', pinDiameter);
        fprintf(fileID, '"pinHeightFromShaftBase"= %f\n', pinHeightFromShaftBase);
        fprintf(fileID, '"cutlength"= %f\n', cutlength);
        fprintf(fileID, '"cutWidth"= %f\n', cutWidth);
        fprintf(fileID, '"cutRadius"= %f\n', cutRadius);
        fprintf(fileID, '"connectorLength"= %f\n', connectorLength);
        fprintf(fileID, '"cutHeight"= %f\n', cutHeight);       
    fclose(fileID);
%% Hip2DOFJointOutputShaft.txt Variables 
outputShaftSupportWidth = hipShaft.distFromZ5_Z3; %+ ((0.012575)/1.78)*patientHeight;
connectorLength=(cutlength/2);
cutWidth=(0.0142875/1.78)*patientHeight;
pinLength=(shaftDiameter1-cutWidth)/2;
pinDiameter=(0.008/1.78)*patientHeight; 
pinHeightFromShaftBase=(0.012/1.78)*patientHeight;
taperAngle=145;
taperLength=(hipShaft.distFromZ5_Z3/2);                                 %(0.01/1.78)*patientHeight;
distanceBetweenTaper=(0.015/1.78)*patientHeight;
diameterHipCylinder1=(0.08/1.78)*patientHeight;
cutRadius=(0.01/1.78)*patientHeight;
cutHeight=(0.018/1.78)*patientHeight;
radiusHipCylinder=diameterHipCylinder1/2;
connectingShaftDiameter1=(hipShaft.dp1);                                   %dp1 - from shaft
keyWayWidth =    hipShaft.wShaftKeyHip;                                    %wShaftKeyHip
keyWayHeight =   hipShaft.hShaftKeyHip;                                    % hShaftKeyHip - from shaft
cutRadiusOuter=(0.035/1.78)*patientHeight;
cutRadiusInner=(0.015/1.78)*patientHeight; %% Length of keyway???????  it is ---- hipShaft.lShaftKeyHip
lengthBetweenCuts=(0.01/1.78)*patientHeight;
lengthOfCut=outputShaftSupportWidth-taperLength;
extrudeDepth= hipShaft.distFromZ5_Z3 + lengthOfCut - outputShaftSupportWidth;                        %needs to be driven off of change in length of shaft (z6-z3)
%extrudeDepth= (z6-z3) - (thickness of wall) --> thickness of wall=
%shaftdiameter1-lengthofcut *warning --this is only 6mm at this point*

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\Hip2DOFJointOutputShaft.txt','w');
        fprintf(fileID, '"shaftDiameter1"= %f\n', shaftDiameter1);
        fprintf(fileID, '"connectorlength"= %f\n', connectorLength);
        fprintf(fileID, '"cutWidth"= %f\n', cutWidth);
        fprintf(fileID, '"pinLength"= %f\n', pinLength);
        fprintf(fileID, '"pinDiameter"= %f\n', pinDiameter);
        fprintf(fileID, '"pinHeightFromShaftBase"= %f\n', pinHeightFromShaftBase);
        fprintf(fileID, '"taperAngle"= %f\n', taperAngle);
        fprintf(fileID, '"taperLength"= %f\n', taperLength);
        fprintf(fileID, '"distanceBetweenTaper"= %f\n', distanceBetweenTaper);        
        fprintf(fileID, '"diameterHipCylinder1"= %f\n', diameterHipCylinder1);
        fprintf(fileID, '"cutRadius"= %f\n', cutRadius);
        fprintf(fileID, '"cutHeight"= %f\n', cutHeight);
        fprintf(fileID, '"radiusHipCylinder"= %f\n', radiusHipCylinder);
        fprintf(fileID, '"connectingShaftDiameter1"= %f\n', connectingShaftDiameter1);
        fprintf(fileID, '"keyWayWidth"= %f\n', keyWayWidth);
        fprintf(fileID, '"keyWayHeight"= %f\n', keyWayHeight);
        fprintf(fileID, '"cutRadiusOuter"= %f\n', cutRadiusOuter);
        fprintf(fileID, '"cutRadiusInner"= %f\n', cutRadiusInner);
        fprintf(fileID, '"lengthBetweenCuts"= %f\n', lengthBetweenCuts);
        fprintf(fileID, '"lengthOfCut"= %f\n', lengthOfCut);
        fprintf(fileID, '"extrudeDepth"= %f\n', extrudeDepth);
        fprintf(fileID, '"outputShaftSupportWidth"= %f\n', outputShaftSupportWidth);                         
    fclose(fileID);
    
%% Hip2DOFJointCasing.txt Variables 
%shaftDiameter1=(0.028575/1.78)*patientHeight;
%revolve1Length=(0.053975/1.78)*patientHeight;
%shaftShoulderLength=(0.01/1.78)*patientHeight;
%revolve1Width1=(0.009525/1.78)*patientHeight;
%notchAngle1=(45.0);
radiusOfAttachmentBar= (0.03/1.78)*patientHeight;
distanceToAttachmentBar= (hipBeltThickness/2);
casingOuterDiameter=(revolve1Length + ((0.01/1.78)*patientHeight));
casingExtrudeLength=(shaftShoulderLength + revolve1Width1 + ((0.01/1.78)*patientHeight));
extrudeCutLength1= (casingExtrudeLength - ((0.005/1.78)*patientHeight));
boltAttachmentDiameter=(0.008/1.78)*patientHeight;
distanceToBearingProfile= (casingExtrudeLength - (0.008/1.78)*patientHeight);
revolveDistanceTOBearingProfile=revolve1Length/2;
notchLength1=(0.00047625/1.78)*patientHeight;
outerWidthToCenterline=revolve1Width1-notchLength1;
taperLength2=(0.003/1.78)*patientHeight;
distanceToPlane= (casingOuterDiameter/2) + ((0.03/1.78)*patientHeight);
distanceToHipAttachmentBolts=(casingExtrudeLength/2);
heightOfAttachmentBar= (hipBeltThickness/3);

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\Hip2DOFJointCasing.txt','w');
        fprintf(fileID, '"shaftDiameter1"= %f\n', shaftDiameter1);
        fprintf(fileID, '"revolve1Length"= %f\n', revolve1Length);
        fprintf(fileID, '"shaftShoulderLength"= %f\n', shaftShoulderLength);
        fprintf(fileID, '"revolve1Width1"= %f\n', revolve1Width1);
        fprintf(fileID, '"notchAngle1"= %f\n', notchAngle1);
        fprintf(fileID, '"radiusOfAttachmentBar"= %f\n', radiusOfAttachmentBar);
        fprintf(fileID, '"distanceToAttachmentBar"= %f\n', distanceToAttachmentBar);
        fprintf(fileID, '"casingOuterDiameter"= %f\n', casingOuterDiameter);
        fprintf(fileID, '"boltAttachmentDiameter"= %f\n', boltAttachmentDiameter);      
        fprintf(fileID, '"casingExtrudeLength"= %f\n', casingExtrudeLength);      
        fprintf(fileID, '"extrudeCutLength1"= %f\n', extrudeCutLength1);      
        fprintf(fileID, '"distanceToBearingProfile"= %f\n', distanceToBearingProfile);      
        fprintf(fileID, '"revolveDistanceTOBearingProfile"= %f\n', revolveDistanceTOBearingProfile); 
        fprintf(fileID, '"notchLength1"= %f\n', notchLength1);      
        fprintf(fileID, '"outerWidthToCenterline"= %f\n', outerWidthToCenterline);      
        fprintf(fileID, '"taperLength2"= %f\n', taperLength2);      
        fprintf(fileID, '"distanceToPlane"= %f\n', distanceToPlane);      
        fprintf(fileID, '"distanceToHipAttachmentBolts"= %f\n', distanceToHipAttachmentBolts);      
        fprintf(fileID, '"heightOfAttachmentBar"= %f\n', heightOfAttachmentBar);      
    fclose(fileID);
    

    
%% MedialDiskBallBearing.txt Variables 
notchLength2=(0.00047625/1.78)*patientHeight;
notchAngle1=(45.0);
revolve2Distance1=(0.00195385/1.78)*patientHeight;
cylindricalRevolveDistance2=(0.00423333/1.78)*patientHeight;
revolve2Length=(0.053975/1.78)*patientHeight;
revolve2Length2=hipShaft.dp5;                                               %dp5 from Shaft
revolve2Width1= hipShaft.distFromZ11_Z10;                                    %from length of Z10 to Z11

    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\MedialDiskBallBearing.txt','w');
        fprintf(fileID, '"notchLength2"= %f\n', notchLength2);
        fprintf(fileID, '"notchAngle1"= %f\n', notchAngle1);
        fprintf(fileID, '"revolve2Distance1"= %f\n', revolve2Distance1);
        fprintf(fileID, '"cylindricalRevolveDistance2"= %f\n', cylindricalRevolveDistance2);
        fprintf(fileID, '"revolve2Length"= %f\n', revolve2Length);
        fprintf(fileID, '"revolve2Length2"= %f\n', revolve2Length2);
        fprintf(fileID, '"revolve2Width1"= %f\n', revolve2Width1);
    fclose(fileID);    
    
%% HipMedialDisk.txt Variables 
shaftDiameter1=(0.028575/1.78)*patientHeight;
taperLength3=(0.008/1.78)*patientHeight;
%radiusHipCylinder=diameterHipCylinder1/2;
%distanceBetweenTaper=(0.015/1.78)*patientHeight;
%connectorLength=(cutlength/2);
cutWidth=(0.0142875/1.78)*patientHeight;
cutRadius=(0.01/1.78)*patientHeight;
%fromMedialballbearing 
%notchLength2=(0.00047625/1.78)*patientHeight;
%notchAngle1=(45.0);
%revolve2Distance1=(0.00195385/1.78)*patientHeight;
%revolve2Length=(0.053975/1.78)*patientHeight;
%revolve2Length2=(0.020000/1.78)*patientHeight;                             %dp5 from Shaft
%revolve2Width1=(0.012000/1.78)*patientHeight;                              s%same as length of Z9 to Z11
revolveRadius=revolve2Length/2;
medialDiskWidth=hipShaft.distFromZ11_Z10 + 0.01;
medialDiskHeight=(0.015/1.78)*patientHeight;
femurConnectorHeight = ThighCom;
femurConnectorWidth = (0.04/1.78)*patientHeight;
%connectingShaftDiameter1=(0.020000/1.78)*patientHeight;                        %dp1 - from shaft
plungerExtrudeLength=hipShaft.distFromZ10_Z5 + extrudeDepth - ((medialDiskWidth - revolve2Width1)/2); %length of z9 to z6 of shaft minus...
plungerHeight= cutRadius/3;
plungerAngle=30;
halfPlungerAngle=15;
ExtrudetoGet4BarOffset = (0.00657866/1.78)*patientHeight;


    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\HipMedialDisk.txt','w');
        fprintf(fileID, '"shaftDiameter1"= %f\n', shaftDiameter1);
        fprintf(fileID, '"taperLength3"= %f\n', taperLength3);
        fprintf(fileID, '"radiusHipCylinder"= %f\n', radiusHipCylinder);
        fprintf(fileID, '"distanceBetweenTaper"= %f\n', distanceBetweenTaper);
        fprintf(fileID, '"cutWidth"= %f\n', cutWidth);
        fprintf(fileID, '"cutRadius"= %f\n', cutRadius);
        fprintf(fileID, '"medialDiskHeight"= %f\n', medialDiskHeight);
        fprintf(fileID, '"medialDiskWidth"= %f\n', medialDiskWidth); 
        fprintf(fileID, '"femurConnectorHeight"= %f\n', femurConnectorHeight);      
        fprintf(fileID, '"femurConnectorWidth"= %f\n', femurConnectorWidth);      
        fprintf(fileID, '"connectingShaftDiameter1"= %f\n', connectingShaftDiameter1);      
        fprintf(fileID, '"plungerExtrudeLength"= %f\n', plungerExtrudeLength);      
        fprintf(fileID, '"plungerHeight"= %f\n', plungerHeight);      
        fprintf(fileID, '"plungerAngle"= %f\n', plungerAngle);      
        fprintf(fileID, '"halfPlungerAngle"= %f\n', halfPlungerAngle);
        fprintf(fileID, '"ExtrudetoGet4BarOffset"= %f\n', ExtrudetoGet4BarOffset);
        
        %fromMedialBallBearing       
        fprintf(fileID, '"notchLength2"= %f\n', notchLength2);
        fprintf(fileID, '"notchAngle1"= %f\n', notchAngle1);
        fprintf(fileID, '"revolve2Width1"= %f\n', revolve2Width1); 
        fprintf(fileID, '"revolveRadius"= %f\n', revolveRadius);          
    fclose(fileID);
    
    
%% Paramaterized Pulley 

PulleyRevolveWidth= (0.009525/1.78)*patientHeight;
RopeDiameter = (0.004763/1.78)*patientHeight;
PulleyRevolveLength = (0.04/1.78)*patientHeight;
PulleyRevolveAngle =20;
LengthtoPulleyPlane = (0.000762/1.78)*patientHeight;
Sketch4ExtrudeDepth = (0.00127/1.78)*patientHeight;
PulleyExtrudeDepth2= (0.0014224/1.78)*patientHeight;
PulleyFilletRadius1 = (0.0015875/1.78)*patientHeight;
PulleyFilletRadius2 = (0.0028575/1.78)*patientHeight;
PulleyCutRadius1 = (0.005334/1.78)*patientHeight;
PulleyExtrude2 = (0.009525/1.78)*patientHeight;
PulleyFilletRadius3 = (0.000635/1.78)*patientHeight;
PulleyExtrudeDiameter2 = (0.005715/1.78)*patientHeight;
PulleyAttachWidth = (0.01778/1.78)*patientHeight; 
PulleyAttachHeight=(0.02709747/1.78)*patientHeight;
PulleyAttachmentAngle = 97.82997;
PulleyAttachRadius=(0.0127/1.78)*patientHeight;
PulleyLipThickness = (0.00192443/1.78)*patientHeight; 
PulleyRevolveDistance = (0.015/1.78)*patientHeight;

        fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\ParamaterizedPulley.txt','w');
            fprintf(fileID, '"PulleyRevolveWidth"= %f\n', PulleyRevolveWidth);
            fprintf(fileID, '"RopeDiameter"= %f\n', RopeDiameter);
            fprintf(fileID, '"PulleyRevolveLength"= %f\n', PulleyRevolveLength);
            fprintf(fileID, '"PulleyRevolveAngle"= %f\n', PulleyRevolveAngle);
            fprintf(fileID, '"LengthtoPulleyPlane"= %f\n', LengthtoPulleyPlane);
            fprintf(fileID, '"Sketch4ExtrudeDepth"= %f\n', Sketch4ExtrudeDepth);
            fprintf(fileID, '"PulleyFilletRadius1"= %f\n', PulleyFilletRadius1);
            fprintf(fileID, '"PulleyFilletRadius2"= %f\n', PulleyFilletRadius2);
            fprintf(fileID, '"PulleyCutRadius1"= %f\n', PulleyCutRadius1);
            fprintf(fileID, '"PulleyExtrude2"= %f\n', PulleyExtrude2);
            fprintf(fileID, '"PulleyFilletRadius3"= %f\n', PulleyFilletRadius3);
            fprintf(fileID, '"PulleyExtrudeDiameter2"= %f\n', PulleyExtrudeDiameter2);
            fprintf(fileID, '"PulleyExtrudeDepth2"= %f\n', PulleyExtrudeDepth2);
            fprintf(fileID, '"PulleyAttachWidth"= %f\n', PulleyAttachWidth);
            fprintf(fileID, '"PulleyAttachHeight"= %f\n', PulleyAttachHeight);
            fprintf(fileID, '"PulleyAttachmentAngle"= %f\n', PulleyAttachmentAngle);
            fprintf(fileID, '"PulleyAttachRadius"= %f\n', PulleyAttachRadius);
            fprintf(fileID, '"PulleyLipThickness"= %f\n', PulleyLipThickness);
            fprintf(fileID, '"PulleyRevolveDistance"= %f\n', PulleyRevolveDistance);
           
        fclose(fileID);
%%  
%%Sheldons Parts

% classdef Shaft_Length_Anthropometric
%     properties
%         %% Material Properties
%         %Density of shaft material in kg/m^3
%         DensityAl = 2700;
%         DensitySt = 8050;
%         
%         %% Distances of force from 0 
%         zShaftLength
%         supportDist1
%         
%         % Distances corresponding to mass of components
%         casingDist1
%         retainingRingDist1
%         keyDist
%         springDist
%         comOfShaftDist
%         bearingDist
%         exoLegDist
%         retainingRingDist2
%         casingDist2
%         
%         %% Forces acting at those distances
%         % Weight of components
%         Fg1
%         Fg2
%         Fg3
%         Fg4
%         Fg5
%         Fg6
%         Fg7
%         Fg8
%         Fg9
%         
%         % Reaction force
%         Fy2
%         
%     end
%     methods 
%         function obj = Shaft_Length_Anthropometric(patientHeight, diameterHipTorsionSpring)
%             %Total length of the shaft
%             patientHeight = 1.1;
%             zt = (0.069/1.78)*patientHeight;
%             obj.zShaftLength = zt;
%             
%             % Different points along shaft based on a percentage
%             z1 = 0;
%             z2 = 0.07246376812*zt;
%             obj.casingDist1 = (z1+z2)/2;
%             
%             z3 = 0.08695652174*zt;
%             obj.retainingRingDist1 = (z2+z3)/2;
%             
%             z4 = 0.2318840580*zt;
%             obj.keyDist = (z3+z4)/2;
%             
%             z5 = 0.2898550725*zt;
%             obj.supportDist1 = (z3+z5)/2;
%             
%             z6 = 0.3188405797*zt;
%             z7 = 0.6376811594*zt;
%             z8 = 0.6666666667*zt;
%             obj.springDist = (z8+z6)/2;
%             
%             z9 = 0.7391304348*zt;
%             z10 = 0.768115942*zt;
%             z11 = 0.9130434783*zt;
%             obj.bearingDist = (z10+z11)/2;
%             obj.exoLegDist = (z10+z11)/2;
%             z12 = 0.9275362319*zt;
%             obj.retainingRingDist2 = (z11+z12)/2;
%             z13 = 1.0000000000*zt;
%             obj.casingDist2 = (z12+z13)/2;
%             
%             %Different diameters along shaft based on a percentage
%             dp1 = (0.02/1.78)*patientHeight;
%             dp2 = (0.017/1.78)*patientHeight;
%             dp3 = (0.02/1.78)*patientHeight;
%             dp4 = (0.0282/1.78)*patientHeight;
%             dp5 = (0.02/1.78)*patientHeight;
%             dp6 = (0.017/1.78)*patientHeight;
%             dp7 = (0.02/1.78)*patientHeight;
%             
%             distFromZ2_Z1 = z2-z1;
%             distFromZ3_Z2 = z3-z2;
%             distFromZ6_Z3 = z6-z3;
%             %% We need stuff from torsion spring to build this -- from Em
%             distFromZ6_Z9 = z9-z6;
%             distFromZ9_Z11 = z11-z9;
%             distFromZ11_Z12 = z12-z11;
%             distFromZ12_Z13 = z13-z12;
%             
%             %% More calcs
%             %Summation of masses and there centers of mass
%             mizi = (obj.DensityAl*pi/4)*(((dp1.^2)*(distFromZ2_Z1)*(z1+((distFromZ2_Z1)/2)) + (dp2.^2)*(z3-z2)*(z2+((z3-z2)/2)) + (dp3.^2)*(z5-z3)*(z3+((z5-z3)/2))+ (dp4.^2)*(z9-z6)*(z6+((z9-z6)/2))+(dp5.^2)*(z11-z10)*(z10+((z11-z10)/2))+(dp6.^2)*(z12-z11)*(z11+((z12-z11)/2))+(dp7.^2)*(z13-z12)*(z12+((z13-z12)/2))));
%             %total mass of the shaft
%             mtot = (obj.DensityAl*pi/4)*((dp1.^2)*(distFromZ2_Z1) + (dp2.^2)*(z3-z2) + (dp3.^2)*(z5-z3)+ (dp4.^2)*(z9-z6)+ (dp5.^2)*(z11-z10)+ (dp6.^2)*(z12-z11)+ (dp7.^2)*(z13-z12));
%             %volume of the shaft
%             vtot = (pi/4) * ((dp1.^2)*(z2-z1) + (dp2.^2)*(z3-z2) + (dp3.^2)*(z5-z3)+ (dp4.^2)*(z9-z6)+ (dp5.^2)*(z11-z10)+ (dp6.^2)*(z12-z11)+ (dp7.^2)*(z13-z12));
%             %Center of mass for entire shaft
%             ztot = mizi/mtot;
%             obj.comOfShaftDist = ztot;
% 
%             % dimensions of retaining rings
%             lRetainingRing1 = (0.1/178)*patientHeight; % the thickness of the retaing ring in the z direction
%             rRetainingRing1Out = 0.5*dp2 + (0.15/178)*patientHeight; % outer radius retaining ring 1 is 2mm larger than shaft radius
%             vRetainingRing1 = lRetainingRing1 * pi * (rRetainingRing1Out.^2 - (0.5 * dp2).^2) % volume of retaining ring 1
%             lRetainingRing2 = (0.1/178)*patientHeight; % the thickness of the retaing ring in the z direction
%             rRetainingRing2Out = 0.5*dp6 + (0.15/178)*patientHeight; % outer radius retaining ring 2 is 2mm larger than shaft radius
%             vRetainingRing2 = lRetainingRing2 * pi * (rRetainingRing2Out.^2 - (0.5 * dp6).^2) % volume of retaining ring 1
%             mRetainingRing1 = vRetainingRing1 * obj.DensitySt; % mass of retaining ring 1
%             mRetainingRing2 = vRetainingRing2 * obj.DensitySt; % mass of retaining ring 2
%              % dimensions of the key
%             lShaftKeyHip = z4 - z3; % the length of the key in the z direction along the shaft
%             wShaftKeyHip = (0.5/178)*patientHeight; % the width of the key in the x direction
%             hShaftKeyHip = (0.5/178)*patientHeight; % the height of the key in the y direction
%             vShaftKeyHip = lShaftKeyHip * wShaftKeyHip * hShaftKeyHip; % volume of the key
%             mShaftKeyHip = vShaftKeyHip * obj.DensitySt; % mass of the key
% 
%             % dimensions of the torsional hip spring
%             mHipSpring = 0.059764821; % the mass of torsional hip spring
%             ExoskeletonMassvar = Exoskeleton_Mass_Anthropometric(patientHeight);
% 
%             % acceleration caused by gravity 
%             g = 9.81; 
%             % forces acting on shaft
%             Fg1 = - 0.5*ExoskeletonMassvar.MdiscCase * g; % the reaction force at the case support...this support holds up half the weight of case
%             obj.Fg1 = Fg1;
%             Fg2 = -mRetainingRing1 * g; % the downward force caused by the weight of the retaining ring
%             obj.Fg2 = Fg2;
%             Fg3 = -mShaftKeyHip * g; %the downward force caused by the weight of the key
%             obj.Fg3 = Fg3;
%             Fg4 = - mHipSpring * g; % the downward force on the shaft from the weight of the spring
%             obj.Fg4 = Fg4;
%             Fg5 = - mtot * g; % the downward force caused by the weight of the shaft itself
%             obj.Fg5 = Fg5;
%             Fg9 = - 0.5*ExoskeletonMassvar.MdiscCase * g; % the reaction force at the case support...this support holds up half the weight of case
%             obj.Fg9 = Fg9;
%             Fg7 = -ExoskeletonMassvar.mBelowDiscShaft * g; % the force on the shaft caused by the weight of the leg
%             obj.Fg7 = Fg7;
%             Fg8 = -mRetainingRing2 * g; % the downward force caused by the mass of the second retaining ring 
%             obj.Fg8 = Fg8;
%             Fg6 = -ExoskeletonMassvar.Mbearing1 * g; % the force on the shaft caused by the weight of the bearing
%             obj.Fg6 = Fg6;
%             % summation of forces
%             Fy2 = (-Fg1 - Fg2 - Fg3 - Fg4 - Fg5 - Fg6 - Fg7 - Fg8 - Fg9);
%             obj.Fy2 = Fy2;
%             % check
%             Rty = Fg1+ Fg2 + Fg3 + Fg4 +Fg5 + Fg6 + Fg7 + Fy2;
% 
%             % summation of moments and forces on 2 DOF pin joint
%             r2DOFPin = 0.005; % the diameter of the 2DOF joint pin
%             l2DOFPin = 0.03; % the length of the 2 DOF joint pin
%             v2DOFPin = pi * r2DOFPin.^2 * l2DOFPin; % the volume of the 2 DOF joint pin
%             m2DOFPin = obj.DensitySt * v2DOFPin; % the mass of the 2 DOF joint pin
%             mBelow2DOFJoint = ExoskeletonMassvar.mBelow2DOFJoint;
% 
%             F1pin = ExoskeletonMassvar.mBelow2DOFJoint*g + m2DOFPin*g; % the reaction force on the 2 DOF pin joint
% 
% 
%             % Plantarflexion cam design parameters
%             lPlantarSpring = (5/178)*patientHeight; % the length of the plantarflexion spring
%             lPlantarString = (27.59/178)*patientHeight - lPlantarSpring; % the length of the string minus the spring
%             rPlantarString = (0.1/178)*patientHeight; % the radius of the plantar flexion string
%             vPlantarString = lPlantarString*pi*rPlantarString.^2; % the volume of the plantar flexion string
%             mPlantarString = vPlantarString * obj.DensitySt; % mass of the plantar flexion string
% 
%             rPlantarCamSpring = (0.05/178)*patientHeight; % the radius of the torsional spring wire
%             RPlantarCamSpring = (2/178)*patientHeight; % the mean radius of the torsional spring coil
%             nPlantarCamSpring = 2; % the number of body turns of the torsional spring
%             vPlantarCamSpring = pi*rPlantarCamSpring.^2*2*pi*nPlantarCamSpring*RPlantarCamSpring; % the volume of the torsional spring
%             mPlantarCamSpring = obj.DensitySt * vPlantarCamSpring; % the mass of the torsional spring

            mPlantarCamCase = 0.005713; % the mass of the casing around the cam and cam shaft

            mPlantarCam = 0.0064341; % the mass of the plantar flexion cam

            PlantarCamZ1 = 0; % the beginning of the cam shaft
            PlantarCamZ2 = (.5/178)*patientHeight; % the distance to the first step down (circlip) of the the shaft
            PlantarCamZ3 = (.6/178)*patientHeight; % the distance to the first step up (bearing) after the circlip 
            PlantarCamZ4 = (1.1/178)*patientHeight; % the distance to the second step up after the bearing
            PlantarCamZspring = PlantarCamZ4 + (2/178)*patientHeight;
            PlantarCamZ5 = PlantarCamZspring + (0.7/178)*patientHeight; % the distance to the edge of the cam
            PlantarCamZ6 = PlantarCamZ5 + (0.1/178)*patientHeight; % the distance to the end of the cam
            PlantarCamZ7 = PlantarCamZ6 + (0.5/178)*patientHeight; % the distance to the end of the shaft

            PlantarCamDpSpring = (1.4/178)*patientHeight;
            PlantarCamDp1 = PlantarCamDpSpring-(0.4/178)*patientHeight; % the diamater of the shaft up to the circlip
            PlantarCamDp2 = PlantarCamDpSpring-(0.6/178)*patientHeight; % the diameter of the shaft at the circlip
            PlantarCamDp3 = PlantarCamDpSpring-(0.4/178)*patientHeight; % the diameter of the shaft after the circlip/diameter of inside of bearing
            PlantarCamDp5 = PlantarCamDpSpring-(0.4/178)*patientHeight; 
            PlantarCamDp6 = PlantarCamDpSpring-(0.6/178)*patientHeight; 
            PlantarCamDp7 = PlantarCamDpSpring-(0.4/178)*patientHeight; 

%             PlantarCamShaftMiZi = (obj.DensityAl*pi/4) * (PlantarCamDp1.^2 * (PlantarCamZ2-PlantarCamZ1)*((PlantarCamZ2+PlantarCamZ1)/2) + PlantarCamDp2.^2 * (PlantarCamZ3-PlantarCamZ2)*((PlantarCamZ3+PlantarCamZ2)/2) +PlantarCamDp3.^2 * (PlantarCamZ4-PlantarCamZ3)* ((PlantarCamZ4+PlantarCamZ3)/2) +PlantarCamDpSpring.^2 * (PlantarCamZspring-PlantarCamZ4)* ((PlantarCamZ4+PlantarCamZspring)/2) +PlantarCamDp5.^2 * (PlantarCamZ5-PlantarCamZspring)* ((PlantarCamZ5+PlantarCamZspring)/2) +PlantarCamDp6.^2 * (PlantarCamZ6-PlantarCamZ5)* ((PlantarCamZ6+PlantarCamZ5)/2) +PlantarCamDp7.^2 * (PlantarCamZ7-PlantarCamZ6)* ((PlantarCamZ6+PlantarCamZ7)/2) ); % the summation of masses and their centres of mass
%             mPlantarCamShaft = (obj.DensityAl*pi/4) * (PlantarCamDp1.^2 * (PlantarCamZ2-PlantarCamZ1)+ PlantarCamDp2.^2 * (PlantarCamZ3-PlantarCamZ2) +PlantarCamDp3.^2 * (PlantarCamZ4-PlantarCamZ3) +PlantarCamDpSpring.^2 * (PlantarCamZspring-PlantarCamZ4) +PlantarCamDp5.^2 * (PlantarCamZ5-PlantarCamZspring) +PlantarCamDp6.^2 * (PlantarCamZ6-PlantarCamZ5) +PlantarCamDp7.^2 * (PlantarCamZ7-PlantarCamZ6) ); % the total mass of the plantar flexion cam shaft
%             PlantarCamZtot = PlantarCamShaftMiZi/mPlantarCamShaft; % the center of mass of the plantar cam shaft
% 
%             Fy1 = g * (mPlantarCamShaft + mPlantarCam + mPlantarCamCase + mPlantarCamSpring);
%                         
            
%             distFromZ6_Z9 = z9-z6;
%             distFromZ9_Z11 = z11-z9;
%             distFromZ11_Z12 = z12-z11;
%             distFromZ12_Z13 = z13-z12;
%             
            % Bot bar dimensions 
            
            WbotBar = (0.04/1.78)*patientHeight;
            HbotBarKnee = (0.03/1.78)*patientHeight;
            HbotBarCOM = (0.05960204/1.78)*patientHeight;
            botBarAngle = 75;
            TbotBar = (0.01/1.78)*patientHeight;
            HbotBarAngle = (0.116408/1.78)*patientHeight;
            LbotBarCut1 = (0.015/1.78)*patientHeight;
            LbotBarCut2 = (0.055/1.78)*patientHeight;
            WbotBarKnee = (0.015/1.78)*patientHeight;
            WbotBarCOMcut = (0.01/1.78)*patientHeight;
            botBarChamfer = (0.005/1.78)*patientHeight;
            halfLink1 = 0.5*(0.0445/1.78)*patientHeight;
            LinkPinDiameter = (0.0055/1.78)*patientHeight;
            BotBarCut3 = (0.008/1.78)*patientHeight;
            BotBarCut4 = (0.0005/1.78)*patientHeight;
            Link1Angle = 19.5;
            FilletBotBarDimension = (0.005/1.78)*patientHeight;
            DistancetoExtrudePlaneBotBar=TbotBar/2; 
            ExtraExtrudeForFourBar= (0.03/1.78)*patientHeight;
            HCutBotBarForFourBat = HbotBarKnee/2;
            WCutBotBarForFourBat = (0.025/1.78)*patientHeight;
            DistanceToPulley2 = (0.09926034/1.78)*patientHeight;
            LengthToPlaneOfPulley=(0.025/1.78)*patientHeight; %needs to be driven off of dorsiflexion cam
            
            % Link dimensions 
            
            Llink2 = (0.0516/1.78)*patientHeight;
            Llink4 = (0.0472/1.78)*patientHeight;
            tLinks = (0.005/1.78)*patientHeight;
            wLinks = (0.01/1.78)*patientHeight;
            LinkEndRadius = (0.005/1.78)*patientHeight;
            LinkPinDiameter= (0.0055/1.78)*patientHeight;
            OuterConnectionPin = (tLinks)+(TbotBar);
            
            % Top bar dimensions
            
            WtopBar = (0.04/1.78)*patientHeight;
            HtopBarKnee = (0.05/1.78)*patientHeight;
            HtopBarHip = (0.107687/1.78)*patientHeight;
            topBarAngle = 71.48304
            TtopBar = (0.01/1.78)*patientHeight;
            HtopBarAngle = (0.09194892/1.78)*patientHeight;
            LtopBarCut1 = (0.015/1.78)*patientHeight;
            LtopBarCut2 = (0.055/1.78)*patientHeight;
            WtopBarKnee = (0.015/1.78)*patientHeight;
            WtopBarCOMcut = (0.01/1.78)*patientHeight;
            topBarChamfer = (0.005/1.78)*patientHeight;
            halfLink3 = 0.5*(0.0409/1.78)*patientHeight;
            LinkPinDiameter = (0.0055/1.78)*patientHeight;
            Link3Angle = 27.5;
            TopBarCut3 = (0.0313719/1.78)*patientHeight;
            ExtrudeCutWidth1=(0.008/1.78)*patientHeight;
            ExtrudeTopBarLength=(0.002/1.78)*patientHeight;
            ExtraExtrudeForFourBarTopBar= (0.015/1.78)*patientHeight;
            HCutForFourBar = HtopBarKnee/2;
            DistanceToPulley1= (0.160049/1.78)*patientHeight;
            
            % dimensions of the calf strap case
            
            calfInnerCaseDiameter = (0.10/1.78)*patientHeight;
            calfOuterCaseDiameter = (0.12/1.78)*patientHeight;
            calfCaseThickness = (0.01/1.78)*patientHeight;
            calfCaseHeight = (0.12/1.78)*patientHeight;
            distToCutZ = (0.07878462/1.78)*patientHeight;
            distToCutX = (0.01389195/1.78)*patientHeight;
            HalfcalfCaseHeight = 0.5*calfCaseHeight;
            QuartercalfCaseHeight = 0.5*HalfcalfCaseHeight;
            calfSupportRadius = (0.1/1.78)*patientHeight;
            
             % dimensions of the calf strap padding
            
            calfInnerPaddingDiameter = (0.08/1.78)*patientHeight;
            calfOuterPaddingDiameter = (0.10/1.78)*patientHeight;
            calfPaddingThickness = (0.01/1.78)*patientHeight;
            calfPaddingHeight = (0.12/1.78)*patientHeight;
            distToCutZPadding = (0.06893654/1.78)*patientHeight;
            distToCutXPadding = (0.01215537/1.78)*patientHeight;
            HalfcalfPaddingHeight = 0.5*calfCaseHeight;
            QuartercalfPaddingHeight = 0.5*HalfcalfCaseHeight;
            PaddingFillet = (0.003/1.78)*patientHeight;
            DistanceToCalfPlane = (0.08/1.78)*patientHeight;
            
             % dimensions of the thigh strap case
            
            thighInnerCaseDiameter = (0.16/1.78)*patientHeight;
            thighOuterCaseDiameter = (0.18/1.78)*patientHeight;
            thighCaseThickness = (0.01/1.78)*patientHeight; %
            thighCaseHeight = (0.12/1.78)*patientHeight;
            thighDistToCutZ = (0.10832885/1.78)*patientHeight;
            thighDistToCutX = (0.0191013/1.78)*patientHeight;
            thighDistToCutY = (0.006/1.78)*patientHeight;
            HalfthighCaseHeight = 0.5*thighCaseHeight;
            QuarterthighCaseHeight = 0.5*HalfthighCaseHeight;
            thighSupportRadius = (0.1/1.78)*patientHeight;
            DistancetoThighPlane=(0.12/1.78)*patientHeight;
            
             % dimensions of the thigh strap padding
            
            thighInnerPaddingDiameter = (0.14/1.78)*patientHeight;
            thighOuterPaddingDiameter = (0.16/1.78)*patientHeight;
            thighPaddingThickness = (0.01/1.78)*patientHeight;
            thighPaddingHeight = (0.12/1.78)*patientHeight;
            thighDistToCutZPadding = (0.09848078/1.78)*patientHeight;
            thighDistToCutXPadding = (0.01736482/1.78)*patientHeight;
            HalfthighPaddingHeight = 0.5*thighCaseHeight;
            QuarterthighPaddingHeight = 0.5*HalfthighCaseHeight;
            PaddingFillet = (0.003/1.78)*patientHeight;
            
            % dimensions of retaining ring
%             retainingRingInnerDiameter = dp2; %dp2
%             retainingRingOuterDiameter = dp2 + (0.003/1.78)*patientHeight; %dp2
%             retainingRingThickness = distFromZ3_Z2;
%             retainingRingArmLength = (0.005/1.78)*patientHeight;
%             retainingRingArmWidth = (0.003/1.78)*patientHeight;
%             retainingRingHolediameter = (0.002/1.78)*patientHeight;
%             HoledistX = 0.5*retainingRingArmWidth;
%             HoledistY = 0.5*retainingRingArmLength;
%             CircleOffset = (0.0007/1.78)*patientHeight;
%             radiusOfarms = (0.01039742/1.78)*patientHeight;
%             distToHole = (0.00083077/1.78)*patientHeight;
%             reatiningRingFillet = (0.0001/1.78)*patientHeight;

            %%This needs to be done properly cause right now its cheated
            % plantar cam shaft dimensions to print
            PlantarCamZ1_Z2 = PlantarCamZ2 - PlantarCamZ1;
            PlantarCamZ2_Z3 = PlantarCamZ3 - PlantarCamZ2;
            PlantarCamZ3_Z4 = PlantarCamZ4 - PlantarCamZ3;
            PlantarCamZspring = PlantarCamZspring;
            PlantarCamZ5_spring = PlantarCamZ5 - PlantarCamZspring;
            PlantarCamZ6_Z5 = PlantarCamZ6 - PlantarCamZ5;
            PlantarCamZ7_Z6 = PlantarCamZ7 - PlantarCamZ6;
            PlantarKeyWidth = (0.002/1.78)*patientHeight;
            PlantarKeyLength = PlantarCamZ5_spring - (0.002/1.78)*patientHeight;
            CaseThicknessZ8 = (0.012/1.78)*patientHeight;
            CaseThicknessCam = (0.011/1.78)*patientHeight;
            CaseThicknessRing = (0.004/1.78)*patientHeight;
            CaseThicknessZ1 = (0.006/1.78)*patientHeight;
            CaseLength = (0.033/1.78)*patientHeight;
            CaseHeight = (0.02/1.78)*patientHeight;
            CaseToCam = (0.028/1.78)*patientHeight;
            CaseCamToBearing = (0.018/1.78)*patientHeight;
            CaseBearingHeight = (0.01041041/1.78)*patientHeight;
            Z1ToCam = (0.017/1.78)*patientHeight;
            Z1ToBearing = (0.013/1.78)*patientHeight;
            BoltCaseWidth = (0.003/1.78)*patientHeight;
            DistToCamCut = (0.016/1.78)*patientHeight;
            
            % plantar cam dimesnions
            PlantarCamInnerDiameter = PlantarCamDp5;
            PlantarCamOuterDiameter = PlantarCamDp5 + (0.02/1.78)*patientHeight;
            PlantarCamWidth = PlantarCamZ5_spring;
            PlantarCamEdges = (0.001/1.78)*patientHeight;
            PlantarCamCenter = (PlantarCamWidth - 2*PlantarCamEdges)/2;
            PlantarCamInnerRadius = 0.5*PlantarCamInnerDiameter;
            PlantarCamOuterRadius = 0.5*PlantarCamOuterDiameter;
            CutInnerDimeter = PlantarCamInnerDiameter + (0.004/1.78)*patientHeight;
            CutOuterDiameter = PlantarCamInnerDiameter + (0.012/1.78)*patientHeight;
            CutLength = (0.004/1.78)*patientHeight;
            ShallowCutDiameter = (0.0255/1.78)*patientHeight;
            CutInnerRadius = 0.5*CutInnerDimeter;
            CutOuterRadius = 0.5*CutOuterDiameter;
            RadToArm = (0.01275/1.78)*patientHeight;
            CamFillet = (0.0003/1.78)*patientHeight;
            
            
            % dimensions of cam retaining ring
            CamretainingRingInnerDiameter = PlantarCamDp2;
            CamretainingRingOuterDiameter = PlantarCamDp2 + (0.002/1.78)*patientHeight;
            CamretainingRingThickness = PlantarCamZ2_Z3;
            CamretainingRingArmLength = (0.003/1.78)*patientHeight;
            CamretainingRingArmWidth = (0.002/1.78)*patientHeight;
            CamretainingRingHolediameter = (0.001/1.78)*patientHeight;
            CamHoledistX = 0.5*CamretainingRingArmWidth;
            CamHoledistY = 0.5*CamretainingRingArmLength;
            CamCircleOffset = (0.0005/1.78)*patientHeight;
            CamradiusOfarms = (0.006/1.78)*patientHeight;
            CamdistToHole = (0.0007/1.78)*patientHeight;
            CamreatiningRingFillet = (0.0001/1.78)*patientHeight;
            ArmExtrude = (0.00480864/1.78)*patientHeight;
            ArmCutRadius = 0.5*CamretainingRingOuterDiameter;
            
                       %%
            %PlantarCamBearing.txt Variables 
            notchLength1=(0.000016666666667/1.78)*patientHeight;
            notchAngle1=(45.0);
            revolve1Distance1=(0.00006837620297/1.78)*patientHeight;
            cylindricalRevolveDistance=(0.001481480315/1.78)*patientHeight;
            revolve1Length=(0.018888889/1.78)*patientHeight;
            revolve1Length2=(0.01/1.78)*patientHeight;
            revolve1Width1=(0.005/1.78)*patientHeight;

                fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\PlantarCamBearing.txt','w');
                    fprintf(fileID, '"notchLength1"= %f\n', notchLength1);
                    fprintf(fileID, '"notchAngle1"= %f\n', notchAngle1);
                    fprintf(fileID, '"revolve1Distance1"= %f\n', revolve1Distance1);
                    fprintf(fileID, '"cylindricalRevolveDistance"= %f\n', cylindricalRevolveDistance);
                    fprintf(fileID, '"revolve1Length"= %f\n', revolve1Length);
                    fprintf(fileID, '"revolve1Length2"= %f\n', revolve1Length2);
                    fprintf(fileID, '"revolve1Width1"= %f\n', revolve1Width1);
                fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\CamRetainingRingDimensions.txt','w');
                fprintf(fileID, '"CamretainingRingInnerDiameter"= %f\n', CamretainingRingInnerDiameter);
                fprintf(fileID, '"CamretainingRingOuterDiameter"= %f\n', CamretainingRingOuterDiameter);
                fprintf(fileID, '"CamretainingRingThickness"= %f\n', CamretainingRingThickness);
                fprintf(fileID, '"CamretainingRingArmLength"= %f\n', CamretainingRingArmLength);
                fprintf(fileID, '"CamretainingRingArmWidth"= %f\n', CamretainingRingArmWidth);
                fprintf(fileID, '"CamretainingRingHolediameter"= %f\n', CamretainingRingHolediameter);
                fprintf(fileID, '"CamHoledistX"= %f\n', CamHoledistX);
                fprintf(fileID, '"CamHoledistY"= %f\n', CamHoledistY);
                fprintf(fileID, '"CamCircleOffset"= %f\n', CamCircleOffset);
                fprintf(fileID, '"CamradiusOfarms"= %f\n', CamradiusOfarms);
                fprintf(fileID, '"CamdistToHole"= %f\n', CamdistToHole);
                fprintf(fileID, '"CamreatiningRingFillet"= %f\n', CamreatiningRingFillet);
                fprintf(fileID, '"ArmExtrude"= %f\n', ArmExtrude);
                fprintf(fileID, '"ArmCutRadius"= %f\n', ArmCutRadius);
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\PlantarCamDimensions.txt','w');
            fprintf(fileID, '"PlantarCamInnerDiameter"= %f\n', PlantarCamInnerDiameter);
            fprintf(fileID, '"PlantarCamOuterDiameter"= %f\n', PlantarCamOuterDiameter);
            fprintf(fileID, '"PlantarCamWidth"= %f\n', PlantarCamWidth);
            fprintf(fileID, '"PlantarCamEdges"= %f\n', PlantarCamEdges);
            fprintf(fileID, '"PlantarCamCenter"= %f\n', PlantarCamCenter);
            fprintf(fileID, '"PlantarCamInnerRadius"= %f\n', PlantarCamInnerRadius);
            fprintf(fileID, '"PlantarCamOuterRadius"= %f\n', PlantarCamOuterRadius);
            fprintf(fileID, '"CutInnerDimeter"= %f\n', CutInnerDimeter);
            fprintf(fileID, '"CutOuterDiameter"= %f\n', CutOuterDiameter);
            fprintf(fileID, '"CutLength"= %f\n', CutLength);
            fprintf(fileID, '"ShallowCutDiameter"= %f\n', ShallowCutDiameter);
            fprintf(fileID, '"PlantarKeyWidth"= %f\n', PlantarKeyWidth);
            fprintf(fileID, '"PlantarKeyLength"= %f\n', PlantarKeyLength);
            fprintf(fileID, '"CutInnerRadius"= %f\n', CutInnerRadius);
            fprintf(fileID, '"CutOuterRadius"= %f\n', CutOuterRadius);
            fprintf(fileID, '"RadToArm"= %f\n', RadToArm);
            fprintf(fileID, '"CamFillet"= %f\n', CamFillet);
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\PlantarCamShaftDimensions.txt','w');
                fprintf(fileID, '"PlantarCamZ1_Z2"= %f\n', PlantarCamZ1_Z2);
                fprintf(fileID, '"PlantarCamZ2_Z3"= %f\n', PlantarCamZ2_Z3);
                fprintf(fileID, '"PlantarCamZ3_Z4"= %f\n', PlantarCamZ3_Z4);
                fprintf(fileID, '"PlantarCamZspring"= %f\n', PlantarCamZspring);
                fprintf(fileID, '"PlantarCamZ5_spring"= %f\n', PlantarCamZ5_spring);
                fprintf(fileID, '"PlantarCamZ6_Z5"= %f\n', PlantarCamZ6_Z5);
                fprintf(fileID, '"PlantarCamZ7_Z6"= %f\n', PlantarCamZ7_Z6);
                fprintf(fileID, '"PlantarCamDpSpring"= %f\n', PlantarCamDpSpring);
                fprintf(fileID, '"PlantarCamDp1"= %f\n', PlantarCamDp1);
                fprintf(fileID, '"PlantarCamDp2"= %f\n', PlantarCamDp2);
                fprintf(fileID, '"PlantarCamDp3"= %f\n', PlantarCamDp3);
                fprintf(fileID, '"PlantarCamDp5"= %f\n', PlantarCamDp5);
                fprintf(fileID, '"PlantarCamDp6"= %f\n', PlantarCamDp6);
                fprintf(fileID, '"PlantarCamDp7"= %f\n', PlantarCamDp7);
                fprintf(fileID, '"PlantarKeyWidth"= %f\n', PlantarKeyWidth);
                fprintf(fileID, '"PlantarKeyLength"= %f\n', PlantarKeyLength);
                fprintf(fileID, '"CaseThicknessZ8"= %f\n', CaseThicknessZ8);
                fprintf(fileID, '"CaseThicknessCam"= %f\n', CaseThicknessCam);
                fprintf(fileID, '"CaseThicknessRing"= %f\n', CaseThicknessRing);
                fprintf(fileID, '"CaseThicknessZ1"= %f\n', CaseThicknessZ1);
                fprintf(fileID, '"CaseLength"= %f\n', CaseLength);
                fprintf(fileID, '"CaseHeight"= %f\n', CaseHeight);
                fprintf(fileID, '"CaseToCam"= %f\n', CaseToCam);
                fprintf(fileID, '"CaseCamToBearing"= %f\n', CaseCamToBearing);
                fprintf(fileID, '"CaseBearingHeight"= %f\n', CaseBearingHeight);
                fprintf(fileID, '"Z1ToCam"= %f\n', Z1ToCam);
                fprintf(fileID, '"Z1ToBearing"= %f\n', Z1ToBearing);
                fprintf(fileID, '"BoltCaseWidth"= %f\n', BoltCaseWidth);
                fprintf(fileID, '"DistToCamCut"= %f\n', DistToCamCut);
            fclose(fileID);
            
            
%              fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\retainingRingDimensions.txt','w');
%                 fprintf(fileID, '"retainingRingInnerDiameter"= %f\n', retainingRingInnerDiameter);
%                 fprintf(fileID, '"retainingRingOuterDiameter"= %f\n', retainingRingOuterDiameter);
%                 fprintf(fileID, '"retainingRingThickness"= %f\n', retainingRingThickness);
%                 fprintf(fileID, '"retainingRingArmLength"= %f\n', retainingRingArmLength);
%                 fprintf(fileID, '"retainingRingArmWidth"= %f\n', retainingRingArmWidth);
%                 fprintf(fileID, '"retainingRingHolediameter"= %f\n', retainingRingHolediameter);
%                 fprintf(fileID, '"HoledistX"= %f\n', HoledistX);
%                 fprintf(fileID, '"HoledistY"= %f\n', HoledistY);
%                 fprintf(fileID, '"CircleOffset"= %f\n', CircleOffset);
%                 fprintf(fileID, '"radiusOfarms"= %f\n', radiusOfarms);
%                 fprintf(fileID, '"distToHole"= %f\n', distToHole);
%                 fprintf(fileID, '"reatiningRingFillet"= %f\n', reatiningRingFillet);
%             fclose(fileID);
            
%             fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\retainingRingDimensions.txt','w');
%                 fprintf(fileID, '"retainingRingInnerDiameter"= %f\n', retainingRingInnerDiameter);
%                 fprintf(fileID, '"retainingRingOuterDiameter"= %f\n', retainingRingOuterDiameter);
%                 fprintf(fileID, '"retainingRingThickness"= %f\n', retainingRingThickness);
%                 fprintf(fileID, '"retainingRingArmLength"= %f\n', retainingRingArmLength);
%                 fprintf(fileID, '"retainingRingArmWidth"= %f\n', retainingRingArmWidth);
%                 fprintf(fileID, '"retainingRingHolediameter"= %f\n', retainingRingHolediameter);
%                 fprintf(fileID, '"HoledistX"= %f\n', HoledistX);
%                 fprintf(fileID, '"HoledistY"= %f\n', HoledistY);
%                 fprintf(fileID, '"CircleOffset"= %f\n', CircleOffset);
%                 fprintf(fileID, '"radiusOfarms"= %f\n', radiusOfarms);
%                 fprintf(fileID, '"distToHole"= %f\n', distToHole);
%                 fprintf(fileID, '"reatiningRingFillet"= %f\n', reatiningRingFillet);
%             fclose(fileID);
            
%             fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\ShaftKeyDimensions.txt','w');
%                 fprintf(fileID, '"lShaftKeyHip"= %f\n', lShaftKeyHip);
%                 fprintf(fileID, '"wShaftKeyHip"= %f\n', wShaftKeyHip);
%                 fprintf(fileID, '"hShaftKeyHip"= %f\n', hShaftKeyHip);
%             fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\botBarDimensions.txt','w');
            fprintf(fileID, '"WbotBar"= %f\n', WbotBar);
            fprintf(fileID, '"HbotBarKnee"= %f\n', HbotBarKnee);
            fprintf(fileID, '"HbotBarCOM"= %f\n', HbotBarCOM);
            fprintf(fileID, '"botBarAngle"= %f\n', botBarAngle);
            fprintf(fileID, '"TbotBar"= %f\n', TbotBar);
            fprintf(fileID, '"HbotBarAngle"= %f\n', HbotBarAngle);
            fprintf(fileID, '"LbotBarCut1"= %f\n', LbotBarCut1);
            fprintf(fileID, '"LbotBarCut2"= %f\n', LbotBarCut2);
            fprintf(fileID, '"WbotBarKnee"= %f\n', WbotBarKnee);
            fprintf(fileID, '"WbotBarCOMcut"= %f\n', WbotBarCOMcut);
            fprintf(fileID, '"botBarChamfer"= %f\n', botBarChamfer);
            fprintf(fileID, '"halfLink1"= %f\n', halfLink1);
            fprintf(fileID, '"LinkPinDiameter"= %f\n', LinkPinDiameter);
            fprintf(fileID, '"Link1Angle"= %f\n', Link1Angle);
            fprintf(fileID, '"BotBarCut3"= %f\n', BotBarCut3);
            fprintf(fileID, '"BotBarCut4"= %f\n', BotBarCut4);
            fprintf(fileID, '"FilletBotBarDimension"= %f\n', FilletBotBarDimension); 
            fprintf(fileID, '"OuterConnectionPin"= %f\n', OuterConnectionPin);          
            fprintf(fileID, '"DistancetoExtrudePlaneBotBar"= %f\n', DistancetoExtrudePlaneBotBar);          
            fprintf(fileID, '"ExtraExtrudeForFourBar"= %f\n', ExtraExtrudeForFourBar);
            fprintf(fileID, '"HCutBotBarForFourBat"= %f\n', HCutBotBarForFourBat);
            fprintf(fileID, '"WCutBotBarForFourBat"= %f\n', WCutBotBarForFourBat);
            fprintf(fileID, '"DistanceToPulley2"= %f\n', DistanceToPulley2);
            fprintf(fileID, '"LengthToPlaneOfPulley"= %f\n', LengthToPlaneOfPulley);
            fprintf(fileID, '"PulleyFilletRadius1"= %f\n', PulleyFilletRadius1);
            fprintf(fileID, '"PulleyFilletRadius2"= %f\n', PulleyFilletRadius2);
            fclose(fileID);
            
             fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\fourBarDimensions.txt','w');
            fprintf(fileID, '"Llink2"= %f\n', Llink2);
            fprintf(fileID, '"Llink4"= %f\n', Llink4);
            fprintf(fileID, '"tLinks"= %f\n', tLinks);
            fprintf(fileID, '"wLinks"= %f\n', wLinks);
            fprintf(fileID, '"LinkPinDiameter"= %f\n', LinkPinDiameter);
            fclose(fileID);
            
             fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\topBarDimensions.txt','w');
            fprintf(fileID, '"WtopBar"= %f\n', WtopBar);
            fprintf(fileID, '"HtopBarHip"= %f\n', HtopBarHip);        
            fprintf(fileID, '"HtopBarKnee"= %f\n', HtopBarKnee);
            fprintf(fileID, '"topBarAngle"= %f\n', topBarAngle);
            fprintf(fileID, '"TtopBar"= %f\n', TtopBar);
            fprintf(fileID, '"HtopBarAngle"= %f\n', HtopBarAngle);
            fprintf(fileID, '"LtopBarCut1"= %f\n', LtopBarCut1);
            fprintf(fileID, '"LtopBarCut2"= %f\n', LtopBarCut2);
            fprintf(fileID, '"WtopBarKnee"= %f\n', WtopBarKnee);
            fprintf(fileID, '"WtopBarCOMcut"= %f\n', WtopBarCOMcut);
            fprintf(fileID, '"topBarChamfer"= %f\n', topBarChamfer);
            fprintf(fileID, '"halfLink3"= %f\n', halfLink3);
            fprintf(fileID, '"LinkPinDiameter"= %f\n', LinkPinDiameter);
            fprintf(fileID, '"Link3Angle"= %f\n', Link3Angle);
            fprintf(fileID, '"TopBarCut3"= %f\n', TopBarCut3);
            fprintf(fileID, '"ExtrudeCutWidth1"= %f\n', ExtrudeCutWidth1);
            fprintf(fileID, '"ExtrudeTopBarLength"= %f\n', ExtrudeTopBarLength);
            fprintf(fileID, '"ExtraExtrudeForFourBarTopBar"= %f\n', ExtraExtrudeForFourBarTopBar);
            fprintf(fileID, '"DistancetoExtrudePlaneBotBar"= %f\n', DistancetoExtrudePlaneBotBar);
            fprintf(fileID, '"HCutForFourBar"= %f\n', HCutForFourBar);          
            fprintf(fileID, '"DistanceToPulley1"= %f\n', DistanceToPulley1);
            fprintf(fileID, '"LengthToPlaneOfPulley"= %f\n', LengthToPlaneOfPulley);
            fprintf(fileID, '"PulleyFilletRadius1"= %f\n', PulleyFilletRadius1);
            fprintf(fileID, '"PulleyFilletRadius2"= %f\n', PulleyFilletRadius2);            
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\calfCaseDimensions.txt','w');
                fprintf(fileID, '"calfInnerCaseDiameter"= %f\n', calfInnerCaseDiameter);
                fprintf(fileID, '"calfOuterCaseDiameter"= %f\n', calfOuterCaseDiameter);
                fprintf(fileID, '"calfCaseThickness"= %f\n', calfCaseThickness);
                fprintf(fileID, '"calfCaseHeight"= %f\n', calfCaseHeight);
                fprintf(fileID, '"distToCutZ"= %f\n', distToCutZ);
                fprintf(fileID, '"distToCutX"= %f\n', distToCutX);             
                fprintf(fileID, '"HalfcalfCaseHeight"=%f\n', HalfcalfCaseHeight);
                fprintf(fileID, '"QuartercalfCaseHeight"=%f\n', QuartercalfCaseHeight);
                fprintf(fileID, '"calfSupportRadius"=%f\n', calfSupportRadius);
                fprintf(fileID, '"DistanceToCalfPlane"=%f\n', DistanceToCalfPlane);  
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\calfPaddingDimensions.txt','w');
                fprintf(fileID, '"calfInnerPaddingDiameter"= %f\n', calfInnerPaddingDiameter);
                fprintf(fileID, '"calfOuterPaddingDiameter"= %f\n', calfOuterPaddingDiameter);
                fprintf(fileID, '"calfPaddingThickness"= %f\n', calfPaddingThickness);
                fprintf(fileID, '"calfPaddingHeight"= %f\n', calfPaddingHeight);
                fprintf(fileID, '"distToCutZPadding"= %f\n', distToCutZPadding);
                fprintf(fileID, '"distToCutXPadding"= %f\n', distToCutXPadding);
                fprintf(fileID, '"HalfcalfPaddingHeight"=%f\n', HalfcalfPaddingHeight);
                fprintf(fileID, '"QuartercalfPaddingHeight"=%f\n', QuartercalfPaddingHeight);
                fprintf(fileID, '"PaddingFillet"=%f\n', PaddingFillet);
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\thighCaseDimensions.txt','w');
                fprintf(fileID, '"thighInnerCaseDiameter"= %f\n', thighInnerCaseDiameter);
                fprintf(fileID, '"thighOuterCaseDiameter"= %f\n', thighOuterCaseDiameter);
                fprintf(fileID, '"thighCaseThickness"= %f\n', thighCaseThickness);
                fprintf(fileID, '"thighCaseHeight"= %f\n', thighCaseHeight);
                fprintf(fileID, '"thighDistToCutZ"= %f\n', thighDistToCutZ);
                fprintf(fileID, '"thighDistToCutX"= %f\n', thighDistToCutX);
                fprintf(fileID, '"thighDistToCutY"= %f\n', thighDistToCutY);                              
                fprintf(fileID, '"HalfthighCaseHeight"=%f\n', HalfthighCaseHeight);
                fprintf(fileID, '"QuarterthighCaseHeight"=%f\n', QuarterthighCaseHeight);
                fprintf(fileID, '"thighSupportRadius"=%f\n', thighSupportRadius);
                fprintf(fileID, '"DistancetoThighPlane"=%f\n', DistancetoThighPlane);  
            fclose(fileID);
            
            fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\thighPaddingDimensions.txt','w');
                fprintf(fileID, '"thighInnerPaddingDiameter"= %f\n', thighInnerPaddingDiameter);
                fprintf(fileID, '"thighOuterPaddingDiameter"= %f\n', thighOuterPaddingDiameter);
                fprintf(fileID, '"thighPaddingThickness"= %f\n', thighPaddingThickness);
                fprintf(fileID, '"thighPaddingHeight"= %f\n', thighPaddingHeight);
                fprintf(fileID, '"thighDistToCutZPadding"= %f\n', thighDistToCutZPadding);
                fprintf(fileID, '"thighDistToCutXPadding"= %f\n', thighDistToCutXPadding);
                fprintf(fileID, '"HalfthighPaddingHeight"=%f\n', HalfthighPaddingHeight);
                fprintf(fileID, '"QuarterthighPaddingHeight"=%f\n', QuarterthighPaddingHeight);
                fprintf(fileID, '"PaddingFillet"=%f\n', PaddingFillet);
            fclose(fileID);
            
            
            
 %% macks foot code
  
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
%             v1 = (1/4)*(4/3)*pi*((rRigidHeel^3)-(rInnerHeel^3));
%             v2 = (1/2)*pi*((rRigidHeel^2)-(rInnerHeel^2))*(hBackHeelPieceRigid);
%             v3 = 0.005*dRigidHeel*dFromZ2_Z3;
%             v4 = 2*0.005*(0.0025^2)+(1/2)*(loftingDimension1+0.01)*0.0075*0.0025;
%             v5 = 0.005*rRigidHeel*dFromZ3_Z4;
%             v6 = 2*0.01*0.0025*dFromZ2_Z3;
%             v7 = 2*(0.005^2)*dFromZ2_Z3;
%             v8 = 2*(0.015^2)*0.01;
%             v9 = -2*0.005*0.015*0.02;
%             v10 = -4*pi*(0.0025^2)*0.005;
%             v11 = 2*(0.05^2)*0.005+(pi/2)*((rRigidHeel^2)-(rInnerHeel^2))*0.05;
%             v12 = (1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2));
%             %v13 = 0.005*wPiece*0.001-(1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2));
%             v14 = 0; %volume of the loft, not sure how  to calculate yet
%             
%             %% Outer Piece Volume Calculations
%             v15 = (1/4)*(4/3)*pi*((rSoftHeel^3)-(rInnerHeel^3));
%             v16 = (1/2)*pi*((rSoftHeel^2)-(rRigidHeel^2))*hBackHeelPieceOuter;
%             v17 = dSoftHeel*0.005*dFromZ2_Z4;
%             v18 = 2*0.005*(0.0025^2)+(1/2)*(loftingDimension2+0.01)*0.0075*0.0025;
%             v19 = 2*(0.005^2)*0.0025;
%             v20 = 0.005*0.002;
%             v21 = dFromZ2_Z4*dSoftHeel*0.05;
%             v22 = -(dFromZ2_Z3*dRigidHeel+0.0025*dRigidHeel+dFromZ3_Z4*rRigidHeel)*0.0049;
%             v23 = 0.01*dFromZ4_Z5*dSoftHeel;
%             v24 = -0.015*0.005*dSoftHeel;
%             v25 = -2*0.01*0.015*0.005;
%             v26 = (1/2)*pi*dFromZ5_Z6^2*0.01;
%             
%             %% Strap Connector Piece Volume Calculations
%             v27 = 0.005*0.015*0.35;
%             v28 = -0.002*0.012*0.35;
%             v29 = -2*pi*0.0015*0.0025^2;
%             v30 = -2*0.0015*pi*0.001^2;
%             
%             %% Strap Insert Piece Volume Calculations
%             v31 = 0.012*0.002*0.04;
%             v32 = -0.002*pi*(0.0025^2);
%             v33 = -7*0.002*pi*0.001^2;
%             
%             %% Strap Piece Volume Calculations
%             v34 = 2*0.025*0.005+(pi/2)*0.005^2;
%             v35 = 2*pi*0.005*0.0025^2;
%             
%             %% Toe Insert Piece Volume Calculations
%             v36 = dSoftHeel*0.015*0.005;
%             v37 = 2*0.002*0.01*0.015;
%             v38 = -2*0.02*0.005*0.015;
%             v39 = -2*0.005*pi*0.0025^2;
%             
%             %% Total Volume of the Foot Mechanism
%             vTotal = v1+v2+v3+v4+v5+v6+v7+v8+v9+v10+v11+v12+v15+v16 ...
%                 +v17+v18+v19+v20+v21+v22+v23+v24+v25+v26+v27+v28+v29+v30 ...
%                 +v31+v32+v33+v34+v35+v36+v37+v38+v39; %missing v13
            
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

