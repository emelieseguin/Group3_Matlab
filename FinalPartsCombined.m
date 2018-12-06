classdef FinalPartsCombined 
    properties
        %% Volumes
        vMetalHipAttachmemtsDimension
        vHipPadding
        vHip2DOFJointBearing
        vHip2DOFJointShaft
        vHip2DOFJointOutputShaft
        vHip2DOFJointCasing
        vMedialDiscBallBearing
        vHipMedialDisc
        vParametrizedPulley

        vDorsiCamDimensions
        vDorsiCamShaft
        vPlantarCamBearing
        vDorsiCamBearing
        vCamRetainingRing
        vDorsiRetainingRing1
        vDorsiRetainingRing2
        vPlantarCam
        vPlantarCamShaft
        vBotBar
        vLink4
        vLink2
        v4BarBolts
        vTopBar
        vCalfCase
        vCalfPadding
        vThighCase
        vThighPadding

        vRigidPiece
        vOuterPiece
        vSidePiece
        vStrapInsertPiece
        vToeInsertPiece
        vAnkleStrapPiece
        vToeStrapPiece
        vFootPins
        
        %% Masses of exoskeleton needed for calcs
        totalMassOfExoskeleton
        thighExoMass
        shankExoMass
        footExoMass
        hipBoltsLeftMass
        hipBoltsRightMass
        thighBoltsLeftMass
        thighBoltsRightMass
        shankBoltsLeftMass
        shankBotlsRightMass
    end
    methods
        function obj = FinalPartsCombined(patientHeight, hipShaft, dorsiCablePosition, plantarFlexionPosition, plantarTorsionSpring, dorsiTorsionSpring, plantarSpring, dorsiSpring)
%% Set Up Equations for Length of Segments in final assembly 
 
    % init variables
    obj.totalMassOfExoskeleton = 0;
    obj.thighExoMass = 0;
    obj.shankExoMass = 0;
    obj.footExoMass = 0;

    ThighLength= (0.245*patientHeight); %??read in from main?? 
    ShankLength= (0.246*patientHeight); %??read in from main??
    FootHeight = (0.039*patientHeight);

    percentDownThigh = dorsiCablePosition.thighPulleyPercentDownThigh;
    percentDownShank = dorsiCablePosition.shankPullyPercentDownShank;

    lowerAttachmentDistUpShank= plantarFlexionPosition.lowerAttachmentDistUpShank;
    lowerAttachmentDistFromCenterLine = plantarFlexionPosition.lowerAttachmentDistFromCenterLine;

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
    lengthCenterlineToPlane=(lengthBackBar/2) + (hipInnerRadius - ((0.065/1.78)*patientHeight));%
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
    
    obj.vMetalHipAttachmemtsDimension = (pi/8)*(hipOuterDiameter^2 - hipInnerDiameter^2) * hipBeltThickness...
        + lengthBackBar*heightOfAttachmentBar*(0.5*(hipOuterDiameter-hipInnerDiameter)) + heightOfAttachmentBar*radiusOfAttachmentBar*...
        (lengthCenterlineToPlane-0.5*hipOuterDiameter) - 4* (pi/4)*(boltAttachmentDiameter^2)*(lengthCenterlineToPlane-0.5*hipOuterDiameter);     

    
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
    
    obj.vHipPadding = lengthBackBar*(paddingOuterDiameter-paddingInnerDiameter)*hipPaddingThickness + ...
        pi*(((paddingOuterDiameter/2)^2)-(paddingInnerDiameter/2)^2)*hipPaddingThickness + ...
        2*lengthBackBar*heightExtrudeCut1*metalHipAttachmentsThickness;
        
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
    
    obj.vHip2DOFJointBearing = pi*(((0.0269875/1.78)*patientHeight)^2 - ((0.0225925/1.78)*patientHeight)^2)*(0.008573/1.78)*patientHeight + ...
        pi*(((0.0186835/1.78)*patientHeight)^2 - ((0.0147635/1.78)*patientHeight)^2)*(0.008573/1.78)*patientHeight + ...
        12*(4/3)*pi*(((0.00288057/2)/1.78)*patientHeight)^3;
 
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
    
    obj.vHip2DOFJointShaft = pi*((shaftDiameter1/2)^2)*shaftLength + ...
        pi*((shaftShoulderDiameter/2)^2)*shaftShoulderLength - ...
        connectorLength*shaftDiameter1*cutWidth - ...
        pi*((pinDiameter/2)^2)*(shaftDiameter1-cutWidth);
    
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
    
    %obj.vHip2DOFJointOutputShaft = cutWidth*(connectorLength+taperLength+(2*radiusHipCylinder))*shaftDiameter1 + pi*radiusHipCylinder^2*shaftDiameter1 + ...
     %   2*pi*((pinDiameter/2)^2)*pinLength - ...
      %  connectorLength*((0.00694951/1.78)*patientHeight)*cutWidth + ...
       % (taperLength+(2*radiusHipCylinder))*(cutWidth^2) +  pi*radiusHipCylinder^2*cutWidth - ...
        %2*radiusHipCylinder*shaftDiameter1 - taperLength*(shaftDiameter1/2)*((0.08699092/1.78)*patientHeight)*(shaftDiameter1-outputShaftSupportWidth) - ...
        %pi*cutRadiusOuter^2*lengthOfCut - (2*cutRadiusOuter)*((0.14713174/1.78)*patientHeight)*lengthOfCut - ...
        %pi*(connectingShaftDiameter1/2)^2*((0.014/1.78)*patientHeight) - keyWayWidth*keyWayHeight*((0.014/1.78)*patientHeight) + ...
        %(pi/2)*cutRadiusOuter*extrudeDepth + taperLength*(2*cutRadiusOuter)*extrudeDepth - (pi/2)*(((0.0294318/1.78)*patientHeight)^2 - ((0.01986784/1.78)*patientHeight)^2)*extrudeDepth - ...
        %(pi/2)*(((0.01873319/1.78)*patientHeight)^2)*((0.14713174/1.78)*patientHeight) - cutRadius^2*((0.14713174/1.78)*patientHeight);

    obj.vHip2DOFJointOutputShaft = (pi/2)*((0.05204985/1.78)*patientHeight)^2*((0.014/1.78)*patientHeight) - ...
        (pi/2)*(((0.0294318/1.78)*patientHeight)^2-((0.01986784/1.78)*patientHeight)^2)*((0.007/1.78)*patientHeight) - ...
        keyWayWidth*keyWayHeight*((0.014/1.78)*patientHeight) - pi*(connectingShaftDiameter1/2)^2*((0.0014/1.78)*patientHeight) + ...
        ((0.01795015/1.78)*patientHeight)*((0.035/1.78)*patientHeight)*((0.007/1.78)*patientHeight) + ...
        ((0.005/1.78)*patientHeight)*((0.015/1.78)*patientHeight)*((0.007/1.78)*patientHeight) + ...
        ((0.005/1.78)*patientHeight)*((0.007/1.78)*patientHeight)*((0.007/1.78)*patientHeight) + ...
        outputShaftSupportWidth*((0.00699092/1.78)*patientHeight)*cutWidth + ...
        cutWidth*(connectorLength+taperLength)*shaftDiameter1 - ...
        ((0.025/1.78)*patientHeight)*((0.00694951/1.78)*patientHeight)*cutWidth + ...
        2*pi*((pinDiameter/2)^2)*pinLength;
        
    
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
    distanceToPlane= (casingOuterDiameter/2) + ((0.01/1.78)*patientHeight);
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
    
    obj.vHip2DOFJointCasing = pi*(casingOuterDiameter/2)^2*casingExtrudeLength - ...
        pi*(revolve1Length/2)^2*extrudeCutLength1 - ...
        pi*(((0.05851025/1.78)*patientHeight)^2 - (((0.05851025-taperLength2)/1.78)*patientHeight)^2)*revolve1Width1 + ...
        radiusOfAttachmentBar*heightOfAttachmentBar*distanceToPlane - ...
        2*(boltAttachmentDiameter/2)^2*(distanceToPlane-(casingOuterDiameter/2));
    
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
    
    obj.vMedialDiscBallBearing = pi*(((0.0269875/1.78)*patientHeight)^2 - ((0.01918775/1.78)*patientHeight)^2)*(0.01/1.78)*patientHeight + ...
        pi*(((0.01527975/1.78)*patientHeight)^2 - ((0.01380113/1.78)*patientHeight)^2)*(0.01/1.78)*patientHeight + ...
        12*(4/3)*pi*(((0.00576114/2)/1.78)*patientHeight)^3;
    
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
    
    obj.vHipMedialDisc =  pi*(((0.035512/1.78)*patientHeight)^2 - ((0.018512/1.78)*patientHeight)^2)*medialDiskWidth + ...
        femurConnectorWidth*medialDiskWidth*((0.15618942/1.78)*patientHeight) + ...
        ((0.0138162/1.78)*patientHeight)*((0.003333/1.78)*patientHeight)*plungerExtrudeLength;
    
%% Paramaterized Pulley 
    WbotBar = (0.04/1.78)*patientHeight;
    pullyDistanceFromTheCenterLine= dorsiCablePosition.pullyDistanceFromTheCenterLine;
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
    PulleyFilletRadius3 = (0.000635/1.78)*patientHeight;PulleyExtrudeDiameter2 = (0.005715/1.78)*patientHeight;
    PulleyAttachWidth = (0.01778/1.78)*patientHeight; 
    PulleyAttachHeight=pullyDistanceFromTheCenterLine - WbotBar;
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
        fprintf(fileID, '"pullyDistanceFromTheCenterLine"= %f\n', pullyDistanceFromTheCenterLine);          
    fclose(fileID);
        
    obj.vParametrizedPulley = 2*pi*((0.015875/1.78)*patientHeight)^2*((0.001924/1.78)*patientHeight) + ...
        pi*((0.0087305/1.78)*patientHeight)^2*((0.005677/1.78)*patientHeight) + ...
        2*((pi/2)*(PulleyAttachRadius^2)*PulleyExtrudeDepth2 + ((2*PulleyAttachRadius+PulleyAttachWidth)/2)*((0.01981353/1.78)*patientHeight)*PulleyExtrudeDepth2) + ...
        PulleyAttachWidth*Sketch4ExtrudeDepth*((0.01396274/1.78)*patientHeight) - ...
        2*pi*PulleyFilletRadius2^2*Sketch4ExtrudeDepth + ...
        pi*(PulleyExtrude2/2)^2*PulleyExtrudeDepth2 + ...
        pi*(PulleyExtrudeDiameter2/2)^2*Sketch4ExtrudeDepth - ...
        pi*(PulleyExtrudeDiameter2/2)^2*(((0.013893-(2*0.000762))/1.78)*patientHeight);
    
        
%% Parts By Sheldon
% Dorsi  
    dorsiTorsionSpringDiam = dorsiTorsionSpring.diameterNeededForShaft; 
    dorsiTorsionSpringLengthOnShaft = dorsiTorsionSpring.originalLengthOfSpringOnShaft; 
    dorsiTorsionSpringRadiusCam = dorsiTorsionSpring.rCam;  
    DorsiWireDiameter = dorsiTorsionSpring.wireDiameterSpring; 

% Plantar    
    plantarTorsionSpringDiam =  plantarTorsionSpring.diameterNeededForShaft; 
    plantarTorsionSpringLengthOnShaft = plantarTorsionSpring.originalLengthOfSpringOnShaft; 
    plantarTorsionSpringRadiusCam = plantarTorsionSpring.rCam;
    mPlantarCamCase = 0.005713; % the mass of the casing around the cam and cam shaft
    mPlantarCam = 0.0064341; % the mass of the plantar flexion cam

    PlantarCamZ1 = 0; % the beginning of the cam shaft
    PlantarCamZ2 = (.5/178)*patientHeight; % the distance to the first step down (circlip) of the the shaft
    PlantarCamZ3 = (.6/178)*patientHeight; % the distance to the first step up (bearing) after the circlip 
    PlantarCamZ4 = (1.1/178)*patientHeight; % the distance to the second step up after the bearing
    PlantarCamZspring = PlantarCamZ4 + plantarTorsionSpringDiam;
    PlantarCamZ5 = PlantarCamZspring + (0.7/178)*patientHeight; % the distance to the edge of the cam
    PlantarCamZ6 = PlantarCamZ5 + (0.1/178)*patientHeight; % the distance to the end of the cam
    PlantarCamZ7 = PlantarCamZ6 + (0.5/178)*patientHeight; % the distance to the end of the shaft
                  
    PlantarCamDpSpring = plantarTorsionSpringDiam;
    PlantarCamDp1 = PlantarCamDpSpring-(0.4/178)*patientHeight; % the diamater of the shaft up to the circlip
    PlantarCamDp2 = PlantarCamDpSpring-(0.6/178)*patientHeight; % the diameter of the shaft at the circlip
    PlantarCamDp3 = PlantarCamDpSpring-(0.4/178)*patientHeight; % the diameter of the shaft after the circlip/diameter of inside of bearing
    PlantarCamDp5 = PlantarCamDpSpring-(0.4/178)*patientHeight; 
    PlantarCamDp6 = PlantarCamDpSpring-(0.6/178)*patientHeight; 
    PlantarCamDp7 = PlantarCamDpSpring-(0.4/178)*patientHeight; 

            
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
    LengthToPlaneOfPulley=(0.016/1.78)*patientHeight; %needs to be driven off of dorsiflexion cam

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
    topBarAngle = 71.48304;
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
    upperAttachmentDistFromCenterLine = plantarFlexionPosition.upperAttachmentDistFromCenterLine;
    lowerAttachmentDistFromCenterLine = plantarFlexionPosition.lowerAttachmentDistFromCenterLine;
    calfInnerCaseDiameter = (0.10/1.78)*patientHeight;
    calfOuterCaseDiameter = (0.12/1.78)*patientHeight;
    calfCaseThickness = (0.01/1.78)*patientHeight;
    calfCaseHeight = (0.12/1.78)*patientHeight;
    distToCutZ = (0.07878462/1.78)*patientHeight;
    distToCutX = (0.01389195/1.78)*patientHeight;
    HalfcalfCaseHeight = 0.5*calfCaseHeight;
    QuartercalfCaseHeight = 0.5*HalfcalfCaseHeight;
                        
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
    
 % dimensions of the thigh strapping
             
    ThighStrapInnerRad = 0.5*thighOuterCaseDiameter; %%%%%
    ThighStrapOuterRad = ThighStrapInnerRad + (0.002/1.78)*patientHeight; %%%%%%%
    ThighStrapFoldInnerRad = ThighStrapOuterRad + (0.0005/1.78)*patientHeight; %%%%%%
    ThighStrapFoldOuterRad = ThighStrapFoldInnerRad + (0.002/1.78)*patientHeight; %%%%
    ThighFoldDifference = (0.00225/1.78)*patientHeight;%%%%
    ThighFoldDifference2 = (0.00025/1.78)*patientHeight;%%%%
    ThighFoldWidth = (0.004481/1.78)*patientHeight;%%%%
    ThighFoldLipThickness = (0.001481/1.78)*patientHeight;%%%%
    BeltEndCut = (0.01/1.78)*patientHeight;%%%%
    ThighExcessStrap = (0.01888833/1.78)*patientHeight;%%%%
    ThighExcessStrap2 = (0.02128551/1.78)*patientHeight;%%%%
    ExcessStrapY = (0.00086891/1.78)*patientHeight;%%%%
    ExcessStrapY2 = (0.00136794/1.78)*patientHeight;%%%%
    ThighCutRad = (0.06419354/1.78)*patientHeight; %%%%
    MedialThighStrapInnerRad = (0.088/1.78)*patientHeight;
    MedialThighStrapOuterRad = MedialThighStrapInnerRad - (0.002/1.78)*patientHeight;
            

% dorsiflexion torsional cam shaft dimensions        
    DorsiCamZ2 = (0.002/1.78)*patientHeight; 
    DorsiCamZ3 = (0.003/1.78)*patientHeight; 
    DorsiCamZ4 = DorsiCamZ3 + TtopBar; 
    DorsiCamZ6 = DorsiCamZ4 + (0.01/1.78)*patientHeight + dorsiTorsionSpringLengthOnShaft; % Calls in dorsi torsional spring Length 
    DorsiCamZ7 = DorsiCamZ6 + (0.001/1.78)*patientHeight; 
    DorsiCamZ8 = DorsiCamZ7 + (0.002/1.78)*patientHeight; 
    DorsiCamZ3_Z2 = DorsiCamZ3 - DorsiCamZ2; 
    DorsiCamZ4_Z3 = TtopBar; 
    DorsiCamZ6_Z4 = dorsiTorsionSpringLengthOnShaft + (0.01/1.78)*patientHeight + 2*DorsiWireDiameter; % Calls in torsional spring length 
    DorsiCamZ6_Z5 = (0.01/1.78)*patientHeight; 
    DorsiCamZ7_Z6 = (0.001/1.78)*patientHeight; 
    DorsiCamZ8_Z7 = (0.002/1.78)*patientHeight; 
    DorsiCamShaftDpSpring = dorsiTorsionSpringDiam; % Calls in torsional spring diameter 
    DorsiCamShaftDp1 = DorsiCamShaftDpSpring - (0.002/1.78)*patientHeight; 
    DorsiCamShaftDp2 = DorsiCamShaftDpSpring - (0.004/1.78)*patientHeight; 
    DorsiCamShaftDp3 = DorsiCamShaftDpSpring - (0.002/1.78)*patientHeight; 
    DorsiCamShaftDp5 = DorsiCamShaftDpSpring - (0.002/1.78)*patientHeight; 
    DorsiCamShaftDp6 = DorsiCamShaftDpSpring; 
    DorsiCamShaftBearingZ = 0.5*DorsiCamZ4_Z3; 

% dorsiflexion torsional cam dimensions  
    InnerDorsiCamDiameter = DorsiCamShaftDpSpring; 
    DorsiCamRadius = dorsiTorsionSpringRadiusCam; % radius to where the cable sits 
    OuterDorsiCamRadius = DorsiCamRadius + (0.002/1.78)*patientHeight; 
    DorsiCamWidth = (0.01/1.78)*patientHeight; 
    DorsiCamCutDiam = 2*OuterDorsiCamRadius - (0.015/1.78)*patientHeight; 
    DorsiCamCutDepth = (0.001/1.78)*patientHeight; 
    DorsiKeyWidth = (0.0025/1.78)*patientHeight; 
    DorsiKeyLength = DorsiCamZ4_Z3 - (0.002/1.78)*patientHeight; 
    InnerCutDiameter = InnerDorsiCamDiameter + (0.005/1.78)*patientHeight; 
    OuterCutDiameter = 2*DorsiCamRadius - (0.01/1.78)*patientHeight; 
    CutLength = 0.5*(OuterCutDiameter-InnerCutDiameter); 
    DorsiArm = OuterDorsiCamRadius + (0.003/1.78)*patientHeight; 
    HorizantalDorsiCut = (0.00593904/1.78)*patientHeight; 
    SpringArmCaseOffsetY = (0.005985253318492/1.99)*patientHeight; 
    SpringArmCaseOffsetX = (0.0059779030723618/1.78)*patientHeight; 
    SpringArmCaseWidth = DorsiWireDiameter + (0.001/1.78)*patientHeight; 
    SpringArmCaseLength = (0.007846809662613/1.78)*patientHeight; 
    SpringArmCaseBotThickness = (0.00357788944723618/1.78)*patientHeight; 
    SpringArmCaseTopThickness = (0.0032834408007035/1.78)*patientHeight; 
    SpringArmCaseHoleDiameter = DorsiWireDiameter + (0.0001/1.78)*patientHeight; 
    SpringArmCaseDistToHole = (0.001918108044/1.78)*patientHeight; 
    
 
 
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\DorsiCamDimensions.txt','w'); 
        fprintf(fileID, '"InnerDorsiCamDiameter"= %f\n', InnerDorsiCamDiameter); 
        fprintf(fileID, '"DorsiCamRadius"= %f\n', DorsiCamRadius); 
        fprintf(fileID, '"OuterDorsiCamRadius"= %f\n', OuterDorsiCamRadius); 
        fprintf(fileID, '"DorsiCamWidth"= %f\n', DorsiCamWidth); 
        fprintf(fileID, '"DorsiCamCutDiam"= %f\n', DorsiCamCutDiam); 
        fprintf(fileID, '"DorsiCamCutDepth"= %f\n', DorsiCamCutDepth); 
        fprintf(fileID, '"DorsiKeyWidth"= %f\n', DorsiKeyWidth); 
        fprintf(fileID, '"DorsiKeyLength"= %f\n', DorsiKeyLength); 
        fprintf(fileID, '"InnerCutDiameter"= %f\n', InnerCutDiameter); 
        fprintf(fileID, '"OuterCutDiameter"= %f\n', OuterCutDiameter); 
        fprintf(fileID, '"CutLength"= %f\n', CutLength); 
        fprintf(fileID, '"DorsiArm"= %f\n', DorsiArm); 
        fprintf(fileID, '"HorizantalDorsiCut"= %f\n', HorizantalDorsiCut); 
        fprintf(fileID, '"SpringArmCaseOffsetY"= %f\n', SpringArmCaseOffsetY); 
        fprintf(fileID, '"SpringArmCaseOffsetX"= %f\n', SpringArmCaseOffsetX); 
        fprintf(fileID, '"SpringArmCaseWidth"= %f\n', SpringArmCaseWidth); 
        fprintf(fileID, '"SpringArmCaseLength"= %f\n', SpringArmCaseLength); 
        fprintf(fileID, '"SpringArmCaseBotThickness"= %f\n', SpringArmCaseBotThickness); 
        fprintf(fileID, '"SpringArmCaseTopThickness"= %f\n', SpringArmCaseTopThickness); 
        fprintf(fileID, '"SpringArmCaseHoleDiameter"= %f\n', SpringArmCaseHoleDiameter); 
        fprintf(fileID, '"SpringArmCaseDistToHole"= %f\n', SpringArmCaseDistToHole); 
    fclose(fileID);
    
    obj.vDorsiCamDimensions = 2*pi*(OuterDorsiCamRadius^2 - ((0.01057813/1.78)*patientHeight)^2)*DorsiCamCutDepth + ...
        pi*(DorsiCamRadius^2 - ((0.01057813/1.78)*patientHeight)^2)*(DorsiCamWidth-(2*DorsiCamCutDepth)) + ...
        pi*(((0.00819986/1.78)*patientHeight)^2-((0.005829/1.78)*patientHeight)^2)*(DorsiCamWidth+(2*DorsiCamCutDepth)) + ...
        4*((0.0022855/1.78)*patientHeight)*((0.00145184/1.78)*patientHeight)*(DorsiCamWidth+(2*DorsiCamCutDepth)) + ...
        SpringArmCaseLength*(2*SpringArmCaseOffsetX)*SpringArmCaseBotThickness + ...
        DorsiKeyWidth*(DorsiCamWidth+(2*DorsiCamCutDepth))*(DorsiArm-OuterDorsiCamRadius);
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\DorsiCamShaftDimensions.txt','w'); 
        fprintf(fileID, '"DorsiCamZ2"= %f\n', DorsiCamZ2); 
        fprintf(fileID, '"DorsiCamZ3"= %f\n', DorsiCamZ3); 
        fprintf(fileID, '"DorsiCamZ4"= %f\n', DorsiCamZ4); 
        fprintf(fileID, '"DorsiCamZ6"= %f\n', DorsiCamZ6); 
        fprintf(fileID, '"DorsiCamZ7"= %f\n', DorsiCamZ7); 
        fprintf(fileID, '"DorsiCamZ8"= %f\n', DorsiCamZ8); 
        fprintf(fileID, '"DorsiCamZ3_Z2"= %f\n', DorsiCamZ3_Z2); 
        fprintf(fileID, '"DorsiCamZ4_Z3"= %f\n', DorsiCamZ4_Z3); 
        fprintf(fileID, '"DorsiCamZ6_Z4"= %f\n', DorsiCamZ6_Z4); 
        fprintf(fileID, '"DorsiCamZ6_Z5"= %f\n', DorsiCamZ6_Z5); 
        fprintf(fileID, '"DorsiCamZ7_Z6"= %f\n', DorsiCamZ7_Z6); 
        fprintf(fileID, '"DorsiCamZ8_Z7"= %f\n', DorsiCamZ8_Z7); 
        fprintf(fileID, '"DorsiCamShaftDpSpring"= %f\n', DorsiCamShaftDpSpring); 
        fprintf(fileID, '"DorsiCamShaftDp1"= %f\n', DorsiCamShaftDp1); 
        fprintf(fileID, '"DorsiCamShaftDp2"= %f\n', DorsiCamShaftDp2); 
        fprintf(fileID, '"DorsiCamShaftDp3"= %f\n', DorsiCamShaftDp3); 
        fprintf(fileID, '"DorsiCamShaftDp5"= %f\n', DorsiCamShaftDp5); 
        fprintf(fileID, '"DorsiCamShaftDp6"= %f\n', DorsiCamShaftDp6); 
        fprintf(fileID, '"DorsiKeyWidth"= %f\n', DorsiKeyWidth); 
        fprintf(fileID, '"DorsiKeyLength"= %f\n', DorsiKeyLength); 
        fprintf(fileID, '"DorsiCamShaftBearingZ"= %f\n', DorsiCamShaftBearingZ); 
    fclose(fileID); 
    
    obj.vDorsiCamShaft = pi*(DorsiCamShaftDp1/2)^2*DorsiCamZ2 + ...
        pi*(DorsiCamShaftDp1/2)^2*DorsiCamZ3_Z2 + ...
        pi*(DorsiCamShaftDp2/2)*DorsiCamZ4_Z3 + ...
        pi*(DorsiCamShaftDpSpring/2)^2*DorsiCamZ6_Z4 + ...
        pi*(DorsiCamShaftDp5/2)^2*DorsiCamZ7_Z6 + ...
        pi*(DorsiCamShaftDp6/2)^2*DorsiCamZ8_Z7 - ...
        DorsiKeyWidth^2*DorsiKeyLength;
   
% plantar cam shaft dimensions to print
    PlantarCamZ1_Z2 = PlantarCamZ2 - PlantarCamZ1;
    PlantarCamZ2_Z3 = PlantarCamZ3 - PlantarCamZ2;
    PlantarCamZ3_Z4 = PlantarCamZ4 - PlantarCamZ3;
    PlantarCamZspring = PlantarCamZ4 + plantarTorsionSpringLengthOnShaft; 
    PlantarCamZspring_Z4 = PlantarCamZspring - PlantarCamZ4; 
    PlantarCamZ5_spring = PlantarCamZ5 - PlantarCamZspring;
    PlantarCamZ6_Z5 = PlantarCamZ6 - PlantarCamZ5;
    PlantarCamZ7_Z6 = PlantarCamZ7 - PlantarCamZ6;
    PlantarKeyWidth = (0.002/1.78)*patientHeight;
    PlantarKeyLength = PlantarCamZ5_spring - (0.002/1.78)*patientHeight;
    CaseThicknessZ8 = (0.012/1.78)*patientHeight;
    CaseThicknessCam = (0.011/1.78)*patientHeight;
    CaseThicknessRing = (0.004/1.78)*patientHeight;
    CaseThicknessZ1 = 0.5*PlantarCamDp1 + (0.001/1.78)*patientHeight;
    CaseLength = (0.03825/1.78)*patientHeight;
    CaseHeight = (0.02/1.78)*patientHeight;
    CaseToCam = (0.028/1.78)*patientHeight;
    CaseCamToBearing = (0.018/1.78)*patientHeight;
    CaseBearingHeight = (0.01041041/1.78)*patientHeight;
    Z1ToCam = (0.017/1.78)*patientHeight;
    Z1ToBearing = (0.013/1.78)*patientHeight;
    BoltCaseWidth = (0.003/1.78)*patientHeight;
    DistToCamCut = (0.016/1.78)*patientHeight;
    CaseToZ6 = PlantarCamZ6 + (0.002/1.78)*patientHeight; 
            
% plantar cam dimesnions
    PlantarCamInnerDiameter = PlantarCamDp5;
    PlantarCamOuterDiameter = 2*plantarTorsionSpringRadiusCam;
    PlantarCamWidth = PlantarCamZ5_spring;
    PlantarCamEdges = (0.001/1.78)*patientHeight;
    PlantarCamCenter = (PlantarCamWidth - 2*PlantarCamEdges)/2;
    PlantarCamInnerRadius = 0.5*PlantarCamInnerDiameter;
    PlantarCamOuterRadius = 0.5*PlantarCamOuterDiameter;
    CutInnerDimeter = PlantarCamInnerDiameter + (0.007/1.78)*patientHeight; 
    CutOuterDiameter = PlantarCamInnerDiameter + (0.02/1.78)*patientHeight; 
    CutLength = (0.004/1.78)*patientHeight;
    ShallowCutDiameter = PlantarCamOuterRadius + (0.01/1.78)*patientHeight; 
    CutInnerRadius = 0.5*CutInnerDimeter;
    CutOuterRadius = 0.5*CutOuterDiameter;
    RadToArm = (0.01275/1.78)*patientHeight;
    CamFillet = (0.0003/1.78)*patientHeight;
    PlantarCamGrooveRadius = (0.00606/1.78)*patientHeight; 
    PlantarCamGroove = PlantarCamGrooveRadius + PlantarCamOuterRadius; 
    CaseHeight = PlantarCamGroove + (0.006/1.78)*patientHeight; 
                 
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
            
% dimensions of dorsi cam retaining ring 
    DorsiretainingRingInnerDiameter1 = DorsiCamShaftDp2; 
    DorsiretainingRingOuterDiameter1 = DorsiCamShaftDp2 + (0.002/1.78)*patientHeight; 
    DorsiretainingRingInnerDiameter2 = DorsiCamShaftDp5; 
    DorsiretainingRingOuterDiameter2 = DorsiCamShaftDp5 + (0.002/1.78)*patientHeight; 
    DorsiretainingRingThickness = DorsiCamZ3_Z2; 
    DorsiretainingRingArmLength = (0.003/1.78)*patientHeight; 
    DorsiretainingRingArmWidth = (0.002/1.78)*patientHeight; 
    DorsiretainingRingHolediameter = (0.001/1.78)*patientHeight; 
    DorsiHoledistX = 0.5*CamretainingRingArmWidth; 
    DorsiHoledistY = 0.5*CamretainingRingArmLength; 
    DorsiCircleOffset = (0.0005/1.78)*patientHeight; 
    DorsiradiusOfarms = (0.006/1.78)*patientHeight; 
    DorsidistToHole = (0.0007/1.78)*patientHeight; 
    DorsireatiningRingFillet = (0.0001/1.78)*patientHeight; 
    DorsiArmExtrude = (0.00480864/1.78)*patientHeight;  
    DorsiArmCutRadius = 0.5*CamretainingRingOuterDiameter; 

                       %%
%PlantarCamBearing.txt Variables 
    notchLength3=(0.000016666666667/1.78)*patientHeight; 
    notchAngle3=(45.0); 
    revolve1Distance3=(0.00006837620297/1.78)*patientHeight; 
    cylindricalRevolveDistance3=(0.001481480315/1.78)*patientHeight; 
    revolve3Length2=PlantarCamDp3; 
    revolve3Length=PlantarCamDp3 + (0.0109888889/1.78)*patientHeight; 
    revolve3Width=PlantarCamZ3_Z4;  
    CaseBearingHeight = 0.5*(revolve3Length+(0.002/1.78)*patientHeight); 

%DorsiCamBearing dimensions 
    notchLength4=(0.000016666666667/1.78)*patientHeight; 
    notchAngle4=(45.0); 
    revolve1Distance4=(0.00006837620297/1.78)*patientHeight; 
    cylindricalRevolveDistance4=(0.001481480315/1.78)*patientHeight; 
    revolve4Length2=DorsiCamShaftDp3; 
    revolve4Length=DorsiCamShaftDp3 + (0.0109888889/1.78)*patientHeight; 
    revolve4Width= 0.5*DorsiCamZ4_Z3; 
    CaseBearingHeightDorsi = 0.5*(revolve3Length+(0.002/1.78)*patientHeight); 
    InnerDorsiCamDiamaterInShaft= revolve4Length - ((0.005/1.78)*patientHeight);
            
% dimensions of the calf strap case
    upperAttachmentDistFromCenterLine = plantarFlexionPosition.upperAttachmentDistFromCenterLine;
    calfInnerCaseDiameter = (0.10/1.78)*patientHeight;
    calfOuterCaseDiameter = (0.12/1.78)*patientHeight;
    calfCaseThickness = (0.01/1.78)*patientHeight;
    calfCaseHeight = (0.12/1.78)*patientHeight;
    distToCutZ = (0.07878462/1.78)*patientHeight;
    distToCutX = (0.01389195/1.78)*patientHeight;
    HalfcalfCaseHeight = 0.5*calfCaseHeight;
    QuartercalfCaseHeight = 0.5*HalfcalfCaseHeight;
    calfSupportRadius = upperAttachmentDistFromCenterLine - PlantarCamOuterDiameter ; %needs to define point in space of upper point plantarflexion
    StrapCutMidWidth = (0.0015/1.78)*patientHeight; %%%%%
    StrapCutHoleWidth = (0.003/1.78)*patientHeight; %%%%
    StrapHeight = (0.028/1.78)*patientHeight; %%%%%
    StrapCutDepth = (0.004/1.78)*patientHeight; %%%%
            
     % Calf strapping dimensions %%%%%
             
     CalfStrapInnerRad = 0.5*calfOuterCaseDiameter; %%%%
     CalfStrapOuterRad = CalfStrapInnerRad + (0.002/1.78)*patientHeight; %%%%%%%
     CalfStrapFoldInnerRad = CalfStrapOuterRad + (0.0005/1.78)*patientHeight; %%%%%%
     CalfStrapFoldOuterRad = CalfStrapFoldInnerRad + (0.002/1.78)*patientHeight; %%%%%%%%
     StrapThickness = (0.002/1.78)*patientHeight; %%%%%
     StrapFoldDepth = (0.013/1.78)*patientHeight; %%%%%%
     StrapLength = (0.015/1.78)*patientHeight; %%%%
     
% 4-bar bolt dimensions
    boltDiameter = LinkPinDiameter;
    boltHeadDiameter = LinkPinDiameter + (0.0025/1.78)*patientHeight;
    boltHeadLength = (0.0025/1.78)*patientHeight;
    bolt1Length = ExtraExtrudeForFourBarTopBar + (2*tLinks) + boltHeadLength;
    bolt2Length = ExtraExtrudeForFourBarTopBar - boltHeadLength;
    bolt3Length = ExtraExtrudeForFourBar + boltHeadLength;
    bolt4Length = ExtraExtrudeForFourBar + boltHeadLength;
    bolt5Length = ((0.0025/1.78)*patientHeight) + tLinks; 
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\PlantarCamBearing.txt','w');
        fprintf(fileID, '"notchLength3"= %f\n', notchLength3); 
        fprintf(fileID, '"notchAngle3"= %f\n', notchAngle3); 
        fprintf(fileID, '"revolve1Distance3"= %f\n', revolve1Distance3); 
        fprintf(fileID, '"cylindricalRevolveDistance3"= %f\n', cylindricalRevolveDistance3); 
        fprintf(fileID, '"revolve3Length"= %f\n', revolve3Length); 
        fprintf(fileID, '"revolve3Length2"= %f\n', revolve3Length2); 
        fprintf(fileID, '"revolve1Width3"= %f\n', revolve3Width); 
    fclose(fileID); 

    obj.vPlantarCamBearing = pi*(((0.009777/1.78)*patientHeight)^2-((0.00711475/1.78)*patientHeight)^2)*((0.004983/1.78)*patientHeight) + ...;
        pi*(((0.00697875/1.78)*patientHeight)^2-((0.0043165/1.78)*patientHeight)^2)*((0.004983/1.78)*patientHeight) + ...
        12*(4/3)*pi*(((0.00148723/2)/1.78)*patientHeight)^3;
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\DorsiCamBearing.txt','w'); 
        fprintf(fileID, '"notchLength4"= %f\n', notchLength4); 
        fprintf(fileID, '"notchAngle4"= %f\n', notchAngle4); 
        fprintf(fileID, '"revolve1Distance4"= %f\n', revolve1Distance4); 
        fprintf(fileID, '"cylindricalRevolveDistance4"= %f\n', cylindricalRevolveDistance4); 
        fprintf(fileID, '"revolve4Length"= %f\n', revolve4Length); 
        fprintf(fileID, '"revolve4Length2"= %f\n', revolve4Length2); 
        fprintf(fileID, '"revolve1Width4"= %f\n', revolve4Width); 
    fclose(fileID); 
            
    obj.vDorsiCamBearing = pi*(((0.00985/1.78)*patientHeight)^2-((0.00718906/1.78)*patientHeight)^2)*((0.004983/1.78)*patientHeight) + ...;
        pi*(((0.00705175/1.78)*patientHeight)^2-((0.0043895/1.78)*patientHeight)^2)*((0.004983/1.78)*patientHeight) + ...
        12*(4/3)*pi*(((0.00148723/2)/1.78)*patientHeight)^3;
    
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
        
    obj.vCamRetainingRing = 2*(pi*(CamretainingRingOuterDiameter^2-CamretainingRingInnerDiameter^2)*CamretainingRingThickness + ...
        2*CamretainingRingHolediameter*((0.0026096/1.78)*patientHeight)*CamretainingRingThickness - ...
        2*(CamCircleOffset^2)*CamretainingRingThickness);
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\DorsiRetainingRingDimensions.txt','w'); 
        fprintf(fileID, '"DorsiretainingRingInnerDiameter1"= %f\n', DorsiretainingRingInnerDiameter1); 
        fprintf(fileID, '"DorsiretainingRingOuterDiameter1"= %f\n', DorsiretainingRingOuterDiameter1); 
        fprintf(fileID, '"DorsiretainingRingInnerDiameter2"= %f\n', DorsiretainingRingInnerDiameter2); 
        fprintf(fileID, '"DorsiretainingRingOuterDiameter2"= %f\n', DorsiretainingRingOuterDiameter2); 
        fprintf(fileID, '"DorsiretainingRingThickness"= %f\n', DorsiretainingRingThickness); 
        fprintf(fileID, '"DorsiretainingRingArmLength"= %f\n', DorsiretainingRingArmLength); 
        fprintf(fileID, '"DorsiretainingRingArmWidth"= %f\n', DorsiretainingRingArmWidth); 
        fprintf(fileID, '"DorsiretainingRingHolediameter"= %f\n', DorsiretainingRingHolediameter); 
        fprintf(fileID, '"DorsiHoledistX"= %f\n', DorsiHoledistX); 
        fprintf(fileID, '"DorsiHoledistY"= %f\n', DorsiHoledistY); 
        fprintf(fileID, '"DorsiCircleOffset"= %f\n', DorsiCircleOffset); 
        fprintf(fileID, '"DorsiradiusOfarms"= %f\n', DorsiradiusOfarms); 
        fprintf(fileID, '"DorsidistToHole"= %f\n', DorsidistToHole); 
        fprintf(fileID, '"DorsireatiningRingFillet"= %f\n', DorsireatiningRingFillet); 
        fprintf(fileID, '"DorsiArmExtrude"= %f\n', DorsiArmExtrude); 
        fprintf(fileID, '"DorsiArmCutRadius"= %f\n', DorsiArmCutRadius); 
    fclose(fileID); 
        
    obj.vDorsiRetainingRing1 = 2*(pi*(DorsiretainingRingOuterDiameter1^2-DorsiretainingRingInnerDiameter1^2)*CamretainingRingThickness + ...
        2*DorsiretainingRingHolediameter*((0.0026096/1.78)*patientHeight)*DorsiretainingRingThickness - ...
        2*(DorsiCircleOffset^2)*DorsiretainingRingThickness);
    
    obj.vDorsiRetainingRing2 = 2*(pi*(DorsiretainingRingOuterDiameter2^2-DorsiretainingRingInnerDiameter2^2)*CamretainingRingThickness + ...
        2*DorsiretainingRingHolediameter*((0.0026096/1.78)*patientHeight)*DorsiretainingRingThickness - ...
        2*(DorsiCircleOffset^2)*DorsiretainingRingThickness);
    
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
        fprintf(fileID, '"PlantarCamGrooveRadius"= %f\n', PlantarCamGrooveRadius); 
        fprintf(fileID, '"PlantarCamGroove"= %f\n', PlantarCamGroove); 
    fclose(fileID);
          
    obj.vPlantarCam = 2*(pi*(((0.02292/1.78)*patientHeight)^2-((0.01429556/1.78)*patientHeight)^2)*(0.001/1.78)*patientHeight) + ...
        pi*(PlantarCamGroove-PlantarCamInnerRadius)^2*(PlantarCamCenter+(2*PlantarCamEdges)) + ...
        pi*(((0.00778418/1.78)*patientHeight)^2-((0.0043/1.78)*patientHeight)^2)*(((0.001/1.78)*patientHeight)+PlantarCamCenter+(2*PlantarCamEdges))- ...
        PlantarKeyWidth^2*PlantarKeyLength;
    
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
        fprintf(fileID, '"CutInnerRadius"= %f\n', CutInnerRadius); 
        fprintf(fileID, '"CutOuterRadius"= %f\n', CutOuterRadius); 
        fprintf(fileID, '"RadToArm"= %f\n', RadToArm); 
        fprintf(fileID, '"CamFillet"= %f\n', CamFillet); 
        fprintf(fileID, '"PlantarCamGrooveRadius"= %f\n', PlantarCamGrooveRadius); 
        fprintf(fileID, '"PlantarCamGroove"= %f\n', PlantarCamGroove); 
        fprintf(fileID, '"PlantarCamZ1"= %f\n', PlantarCamZ1); 
        fprintf(fileID, '"PlantarCamZ2"= %f\n', PlantarCamZ2); 
        fprintf(fileID, '"PlantarCamZ3"= %f\n', PlantarCamZ3); 
        fprintf(fileID, '"PlantarCamZ4"= %f\n', PlantarCamZ4); 
        fprintf(fileID, '"PlantarCamZ5"= %f\n', PlantarCamZ5); 
        fprintf(fileID, '"PlantarCamZ6"= %f\n', PlantarCamZ6); 
        fprintf(fileID, '"PlantarCamZ7"= %f\n', PlantarCamZ7); 
        fprintf(fileID, '"CaseToZ6"= %f\n', CaseToZ6); 
    fclose(fileID);   
          
    obj.vPlantarCamShaft = pi*(PlantarCamDp1/2)^2*PlantarCamZ1_Z2 + ...
        pi*(PlantarCamDp2/2)^2*PlantarCamZ2_Z3 + ...
        pi*(PlantarCamDp3/2)^2*PlantarCamZ3_Z4 + ...
        pi*(PlantarCamDpSpring/2)^2*PlantarCamZspring_Z4 + ...
        pi*(PlantarCamDp5/2)^2*PlantarCamZ5_spring + ...
        pi*(PlantarCamDp6/2)^2*PlantarCamZ6_Z5 + ...
        pi*(PlantarCamDp7/2)^2*PlantarCamZ7_Z6 - ...
        PlantarKeyWidth^2*PlantarKeyLength;
    
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
        fprintf(fileID, '"ShankLength"= %f\n', ShankLength);        
    fclose(fileID);
         
    obj.vBotBar = TbotBar*(HbotBarKnee+HbotBarAngle+HbotBarCOM)*WbotBar + ...
        WbotBar*HbotBarAngle*TbotBar - ...
        2*((((2*WbotBarCOMcut)*(HbotBarAngle/2))/2)*(2*TbotBar)) - ...
        2*(LinkPinDiameter/2)^2*TbotBar + ...
        HCutBotBarForFourBat*WCutBotBarForFourBat*TbotBar - ...
        2*(pi*(PulleyFilletRadius2/2)^2*HCutBotBarForFourBat);
    
	fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\fourBarDimensions.txt','w');
        fprintf(fileID, '"Llink2"= %f\n', Llink2);
        fprintf(fileID, '"Llink4"= %f\n', Llink4);
        fprintf(fileID, '"tLinks"= %f\n', tLinks);
        fprintf(fileID, '"wLinks"= %f\n', wLinks);
        fprintf(fileID, '"LinkPinDiameter"= %f\n', LinkPinDiameter);
        fprintf(fileID, '"boltHeadDiameter" = %f\n', boltHeadDiameter);       
        fprintf(fileID, '"boltHeadLength" = %f\n', boltHeadLength);

	fclose(fileID);
    
    obj.vLink4 = wLinks*Llink4*tLinks + ...
        pi*((0.005/1.78)*patientHeight)^2*tLinks - ...
        2*pi*(LinkPinDiameter/2)^2*tLinks;
    
    obj.vLink2 = wLinks*Llink2*tLinks + ...
        pi*((0.005/1.78)*patientHeight)^2*tLinks - ...
        2*pi*(LinkPinDiameter/2)^2*tLinks;
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\4BarPinDimensions.txt', 'w');
        fprintf(fileID, '"boltDiameter" = %f\n', boltDiameter);
        fprintf(fileID, '"boltHeadDiameter" = %f\n', boltHeadDiameter);
        fprintf(fileID, '"boltHeadLength" = %f\n', boltHeadLength);
        fprintf(fileID, '"bolt1Length" = %f\n', bolt1Length);
        fprintf(fileID, '"bolt2Length" = %f\n', bolt2Length);
        fprintf(fileID, '"bolt3Length" = %f\n', bolt3Length);
        fprintf(fileID, '"bolt4Length" = %f\n', bolt4Length);
        fprintf(fileID, '"bolt5Length" = %f\n', bolt5Length);       
    fclose(fileID);
         
    obj.v4BarBolts = pi*(boltDiameter/2)^2*bolt1Length + ...
        pi*(boltDiameter/2)^2*bolt2Length + ...
        pi*(boltDiameter/2)^2*bolt3Length + ...
        pi*(boltDiameter/2)^2*bolt4Length + ...
        8*(pi*(boltHeadDiameter/2)^2*boltHeadLength);
    
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
        fprintf(fileID, '"revolve4Length"= %f\n', revolve4Length);
        fprintf(fileID, '"revolve1Width4"= %f\n', revolve4Width);
    	fprintf(fileID, '"InnerDorsiCamDiamaterInShaft"= %f\n', InnerDorsiCamDiamaterInShaft);
        fprintf(fileID, '"boltHeadDiameter" = %f\n', boltHeadDiameter);
        fprintf(fileID, '"boltHeadLength" = %f\n', boltHeadLength);
	fclose(fileID);
          
    obj.vTopBar = TtopBar*(HtopBarHip+HtopBarAngle+HtopBarKnee)*WtopBar + ...
        WtopBar*HtopBarAngle*TtopBar + ...
        2*(LtopBarCut1^2*+(1/2)*(HtopBarKnee-LtopBarCut1)*LtopBarCut1) + ...
        ((0.04917251/1.78)*patientHeight)*((0.02423668/1.78)*patientHeight)*ExtraExtrudeForFourBarTopBar + ... 
        (1/2*((0.01880189/1.78)*patientHeight)*((0.03588578/1.78)*patientHeight))*ExtraExtrudeForFourBarTopBar + ...
        ((0.01924764/1.78)*patientHeight)*((0.01328673/1.78)*patientHeight)*ExtraExtrudeForFourBarTopBar - ...
        2*TtopBar*HtopBarAngle/2*WtopBar - ...
        HCutForFourBar*DistancetoExtrudePlaneBotBar*TtopBar - ...
        2*pi*(LinkPinDiameter/2)^2*TtopBar + ...
        ExtraExtrudeForFourBarTopBar*HCutForFourBar*TtopBar - ...
        2*pi*(PulleyFilletRadius2/2)^2*ExtraExtrudeForFourBarTopBar - ...
        pi*(revolve4Length/2)^2*TtopBar;
    
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
        fprintf(fileID, '"lowerAttachmentDistFromCenterLine"=%f\n', lowerAttachmentDistFromCenterLine);
        fprintf(fileID, '"StrapCutMidWidth"=%f\n', StrapCutMidWidth); %%%%
        fprintf(fileID, '"StrapCutHoleWidth"=%f\n', StrapCutHoleWidth); %%%%
        fprintf(fileID, '"StrapHeight"=%f\n', StrapHeight); %%%%
        fprintf(fileID, '"StrapCutDepth"=%f\n', StrapCutDepth); %%%%
	fclose(fileID);
          
    obj.vCalfCase = 0.65*(pi/2)*(calfOuterCaseDiameter^2-calfInnerCaseDiameter^2)*calfCaseHeight + ...
        QuartercalfCaseHeight*(2*distToCutX)*(0.02110317/1.78)*patientHeight + ...
        QuartercalfCaseHeight^2*((0.00805474/1.78)*patientHeight);
    
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\calfCaseStrappingDimensions.txt','w');  %%%%
                fprintf(fileID, '"StrapCutMidWidth"=%f\n', StrapCutMidWidth); %%%%
                fprintf(fileID, '"StrapCutHoleWidth"=%f\n', StrapCutHoleWidth); %%%%
                fprintf(fileID, '"StrapHeight"=%f\n', StrapHeight); %%%%
                fprintf(fileID, '"CalfStrapInnerRad"=%f\n', CalfStrapInnerRad); %%%%
                fprintf(fileID, '"CalfStrapOuterRad"=%f\n', CalfStrapOuterRad); %%%%
                fprintf(fileID, '"CalfStrapFoldInnerRad"=%f\n', CalfStrapFoldInnerRad); %%%%
                fprintf(fileID, '"CalfStrapFoldOuterRad"=%f\n', CalfStrapFoldOuterRad); %%%%
                fprintf(fileID, '"StrapThickness"=%f\n', StrapThickness); %%%%
                fprintf(fileID, '"StrapFoldDepth"=%f\n', StrapFoldDepth); %%%%
                fprintf(fileID, '"StrapLength"=%f\n', StrapLength); %%%%
    fclose(fileID); %%%%
    
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
            
    obj.vCalfPadding = (pi/2)*((calfOuterPaddingDiameter/2)^2-(calfInnerPaddingDiameter/2))^2*calfPaddingHeight - ...
        (1/2)*calfInnerPaddingDiameter*HalfcalfPaddingHeight*(calfOuterPaddingDiameter/2);
    
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\ThighCaseStrappingDimensions.txt','w');  %%%%
                fprintf(fileID, '"StrapCutMidWidth"=%f\n', StrapCutMidWidth); %%%%
                fprintf(fileID, '"StrapCutHoleWidth"=%f\n', StrapCutHoleWidth); %%%%
                fprintf(fileID, '"StrapHeight"=%f\n', StrapHeight); %%%%
                fprintf(fileID, '"ThighStrapInnerRad"=%f\n', ThighStrapInnerRad); %%%%
                fprintf(fileID, '"ThighStrapOuterRad"=%f\n', ThighStrapOuterRad); %%%%
                fprintf(fileID, '"ThighStrapFoldInnerRad"=%f\n', ThighStrapFoldInnerRad); %%%%
                fprintf(fileID, '"ThighStrapFoldOuterRad"=%f\n', ThighStrapFoldOuterRad); %%%%
                fprintf(fileID, '"StrapThickness"=%f\n', StrapThickness); %%%%
                fprintf(fileID, '"StrapFoldDepth"=%f\n', StrapFoldDepth); %%%%
                fprintf(fileID, '"StrapLength"=%f\n', StrapLength); %%%%
                fprintf(fileID, '"ThighFoldDifference"=%f\n', ThighFoldDifference); %%%%
                fprintf(fileID, '"ThighFoldDifference2"=%f\n', ThighFoldDifference2); %%%%
                fprintf(fileID, '"ThighFoldWidth"=%f\n', ThighFoldWidth); %%%%
                fprintf(fileID, '"ThighFoldLipThickness"=%f\n', ThighFoldLipThickness); %%%%
                fprintf(fileID, '"BeltEndCut"=%f\n', BeltEndCut); %%%%
                fprintf(fileID, '"ThighExcessStrap"=%f\n', ThighExcessStrap); %%%%
                fprintf(fileID, '"ThighExcessStrap2"=%f\n', ThighExcessStrap2); %%%%
                fprintf(fileID, '"ExcessStrapY"=%f\n', ExcessStrapY); %%%%
                fprintf(fileID, '"ExcessStrapY2"=%f\n', ExcessStrapY2); %%%%
                fprintf(fileID, '"ThighCutRad"=%f\n', ThighCutRad); %%%%
                fprintf(fileID, '"MedialThighStrapInnerRad"=%f\n', MedialThighStrapInnerRad); %%%%
                fprintf(fileID, '"MedialThighStrapOuterRad"=%f\n', MedialThighStrapOuterRad); %%%%
    fclose(fileID); %%%%
    
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
        fprintf(fileID, '"StrapCutMidWidth"=%f\n', StrapCutMidWidth); %%%%
        fprintf(fileID, '"StrapCutHoleWidth"=%f\n', StrapCutHoleWidth); %%%%
        fprintf(fileID, '"StrapHeight"=%f\n', StrapHeight); %%%%
        fprintf(fileID, '"StrapCutDepth"=%f\n', StrapCutDepth); %%%%
	fclose(fileID);
       
    obj.vThighCase = (0.6)*(pi/2)*((thighOuterCaseDiameter/2)^2-(thighInnerCaseDiameter/2)^2)*thighCaseHeight + ...
        QuarterthighCaseHeight*QuarterthighCaseHeight*(DistancetoThighPlane - (thighOuterCaseDiameter/2));
    
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
            
    obj.vThighPadding = (0.6)*(pi/2)*((thighOuterPaddingDiameter/2)^2-(thighInnerPaddingDiameter/2)^2)*thighPaddingHeight;    
            
 %% macks foot code
  
    lFoot = round(0.152*patientHeight, 6);
    wFoot = round(0.055*patientHeight, 6);
    wShoe = 0; %a value of how much a shoe could
    %increase the width of the foot

 %% Rigid Foot Piece Dimensions 
 % D1@Sketch2
    dInnerHeel = wFoot + wShoe; %could be inside diameter of rigid heel cup
    rInnerHeel = wFoot/2;
    
    dRigidHeel = wFoot+((0.01/1.78)*patientHeight); %outer diameter of rigid heel cup, set to 1cm at 1.78m
    rRigidHeel = dRigidHeel/2;
    
    rHalfRigid = rRigidHeel/2; %used in sketch 10 as the width of the the smaller rigid extrusion
  
    hBackHeelPieceRigid = (0.02047/1.78)*patientHeight;
    hBackHeelPieceOuter = hBackHeelPieceRigid - (0.005/1.78)*patientHeight;
    
    dFromZ1_Z6 = round(lFoot - rInnerHeel, 6); %
    dFromZ1_Z2 = ((0.15*dFromZ1_Z6)/1.78)*patientHeight; %the horizonal distance for the loft, its between the heel cup and rectangular rigid piece
    dFromZ2_Z3 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight; %length of wider rectangular rigid piece
    dFromZ3_Z4 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight; %length of the narrower rectangular rigid piece
    dFromZ4_Z5 = ((0.25*dFromZ1_Z6)/1.78)*patientHeight; %length from the end of the narrow piece to the flat edge at the end of the outer piece
    dFromZ5_Z6 = ((0.10*dFromZ1_Z6)/1.78)*patientHeight; %length between flat edge and tip of curved edge at the front of the outer piece       
    dFromZ2_Z4 = dFromZ2_Z3 + dFromZ3_Z4;
    dFromZ2_Z4_wEdge = dFromZ2_Z4+(0.0025/1.78)*patientHeight;
    
    % Used in Sketch 7
    rigidFootPlateThickness = (0.005/1.78)*patientHeight;
    
    % Used in Sketch 12, the sketch the heel cup lofts too
    loftingDimension1 = dRigidHeel-(0.01/1.78)*patientHeight; %it's the distance between the two tips of the sketch used to create a shape the cup can loft too
    wLoftingDimensionTip = (0.005/1.78)*patientHeight; % the dimensions of the tips between loftingDimension
    lLoftingDimensionTip = (0.0025/1.78)*patientHeight;
    dLoftingTipToSemiCircleApex = (0.0075/1.78)*patientHeight;
    lExtrusion6 = (0.0025/1.78)*patientHeight;
    
    % Sketch 16 Extrusion dimensions
    wExtrusion11 = (0.01/1.78)*patientHeight;
    lExtrusion11 = dFromZ2_Z3;
    
    lExtrusion12 = (0.005/1.78)*patientHeight;
    lExtrusion13 = (0.005/1.78)*patientHeight;
    
    % Rigid piece strap connector location (Extrude 14)
    dFromZ2_Z3_Over2 = dFromZ2_Z3/2; %distance from edge of wide piece to centre of the extrusion
    halfLStrapConnector = (0.0075/1.78)*patientHeight; %half the length of the strap connector extrusion
    hStrapConnector = (0.015/1.78)*patientHeight; %height of the extrusion
    
    wConnectorCut = (0.005/1.78)*patientHeight;
    wHalfConnectorCut = (0.0025/1.78)*patientHeight;
    depthConnectorCut = (0.02/1.78)*patientHeight;
    
    % With regards to pin hole at the connector
    depthPinHole = (0.0075/1.78)*patientHeight; %how far down the connect the centre of the pin hole is
    dPinHole = (0.005/1.78)*patientHeight; %diamter of the pin hole
    
    % With regards to sketch23 and extrude15
    lengthToOuterSemiCircle = (0.05/1.78)*patientHeight; %in sketch 23, this is the straight length up until the semicircle
    lExtrusion15 = (0.02/1.78)*patientHeight; %extrusion length for extrusion15
    
    % With regards to sketch30 and extrusion20
    lPlantarSpringAttachmentPiece = (0.05/1.78)*patientHeight; %length of the attachment piece
    dExtrusion20 = (0.02/1.78)*patientHeight; %depth of the spring attachment piece
    
    % With regards to sketch 32
    lPlantarAttachmentEdgeToHookCutEdge = (0.01/1.78)*patientHeight;
    
    % With regards to sketch33
    rOuterHookCut = (0.01/1.78)*patientHeight;
    rInnerHookCut = (0.0025/1.78)*patientHeight;
    
    % With regards to planes and fillets
    dPlane8 = (0.05/1.78)*patientHeight;
    rFillet1 = (0.01/1.78)*patientHeight;
    distanceToLoftPlane= (0.0332415/1.78)*patientHeight;
    %PlantarSpringAttachRadius
    %LenghtOfSpringAttachmentBar = lowerAttachmentDistFromCenterLine - PlantarSpringAttachRadius; 
    
    dLargePinHoleToePiece = (0.005/1.78)*patientHeight;
    dLargePinHead = dLargePinHoleToePiece+(0.0025/1.78)*patientHeight;
    lLargePin = (0.00125/1.78)*patientHeight;
    R1PlantarSpring=plantarSpring.R1PlantarSpring;
    dPlantarSpringWire=plantarSpring.dPlantarSpringWire;
    %=dorsiSpring. 
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footRigidPieceDimensionsUpdated.txt', 'w');
         fprintf(fileID, '"dInnerHeel" = %7.7f\n', dInnerHeel);
         fprintf(fileID, '"rInnerHeel" = %7.7f\n', dInnerHeel/2);
         fprintf(fileID, '"dRigidHeel" = %7.7f\n', dRigidHeel);
         fprintf(fileID, '"rRigidHeel" = %7.7f\n', dRigidHeel/2);
         fprintf(fileID, '"hBackHeelPieceRigid" = %7.7f\n', hBackHeelPieceRigid);
         fprintf(fileID, '"loftingDimension1" = %7.7f\n', loftingDimension1);
         fprintf(fileID, '"rigidFootPlateThickness" = %7.7f\n', rigidFootPlateThickness);
         fprintf(fileID, '"wLoftingDimensionTip" = %7.7f\n', wLoftingDimensionTip);
         fprintf(fileID, '"lLoftingDimensionTip" = %7.7f\n', lLoftingDimensionTip);
         fprintf(fileID, '"dLoftingTipToSemiCircle" = %7.7f\n', dLoftingTipToSemiCircleApex);
         fprintf(fileID, '"lExtrusion6" = %7.7f\n', lExtrusion6);
         fprintf(fileID, '"wExtrusion11" = %7.7f\n', wExtrusion11);
         fprintf(fileID, '"lExtrusion12" = %7.7f\n', lExtrusion12);
         fprintf(fileID, '"lExtrusion13" = %7.7f\n', lExtrusion13);
         fprintf(fileID, '"halfLStrapConnector" = %7.7f\n', halfLStrapConnector);
         fprintf(fileID, '"hStrapConnector" = %7.7f\n', hStrapConnector);
         fprintf(fileID, '"wConnectorCut" = %7.7f\n', wConnectorCut);
         fprintf(fileID, '"wHalfConnectorCut" = %7.7f\n', wHalfConnectorCut);
         fprintf(fileID, '"depthConnectorCut" = %7.7f\n', depthConnectorCut);
         fprintf(fileID, '"depthPinHole" = %7.7f\n', depthPinHole);
         fprintf(fileID, '"dPinHole" = %7.7f\n', dPinHole);
         fprintf(fileID, '"lengthToOuterSemiCircle" = %7.7f\n', lengthToOuterSemiCircle);
         fprintf(fileID, '"lExtrusion15" = %7.7f\n', lExtrusion15);
         fprintf(fileID, '"lPlantarSpringAttachmentPiece" = %7.7f\n', lPlantarSpringAttachmentPiece);
         fprintf(fileID, '"dExtrusion20" = %7.7f\n', dExtrusion20);
         fprintf(fileID, '"lPlantarAttachmentEdgeToHookCutEdge" = %7.7f\n', lPlantarAttachmentEdgeToHookCutEdge);
         fprintf(fileID, '"rOuterHookCut" = %7.7f\n', rOuterHookCut);
         fprintf(fileID, '"rInnerHookCut" = %7.7f\n', rInnerHookCut);
         fprintf(fileID, '"rHalfRigid" = %7.7f\n', rHalfRigid);
         fprintf(fileID, '"dFromZ1_Z2" = %7.7f\n', dFromZ1_Z2);
         fprintf(fileID, '"dFromZ2_Z3" = %7.7f\n', dFromZ2_Z3);
         fprintf(fileID, '"dFromZ3_Z4" = %7.7f\n', dFromZ3_Z4);
         fprintf(fileID, '"dFromZ4_Z5" = %7.7f\n', dFromZ4_Z5);
         fprintf(fileID, '"dFromZ5_Z6" = %7.7f\n', dFromZ5_Z6);
         fprintf(fileID, '"dFromZ2_Z3_Over2" = %7.7f\n', dFromZ2_Z3_Over2);
         fprintf(fileID, '"dPlane8" = %7.7f\n', dPlane8);
         fprintf(fileID, '"rFillet1" = %7.7f\n', rFillet1);
         fprintf(fileID, '"distanceToLoftPlane" = %7.7f\n', distanceToLoftPlane);
         fprintf(fileID, '"lowerAttachmentDistUpShank" = %7.7f\n', lowerAttachmentDistUpShank);
         fprintf(fileID, '"lowerAttachmentDistFromCenterLine" = %7.7f\n', lowerAttachmentDistFromCenterLine);       
         fprintf(fileID, '"dLargePinHead" = %7.7f\n', dLargePinHead);
         fprintf(fileID, '"lLargePin" = %7.7f\n', lLargePin);
         fprintf(fileID, '"R1PlantarSpring" = %7.7f\n', R1PlantarSpring);
         fprintf(fileID, '"dPlantarSpringWire" = %7.7f\n', dPlantarSpringWire);
         
         
    fclose(fileID);
     
     %% Rigid Piece Volume Calculations
	obj.vRigidPiece = (1/4)*(4/3)*pi*((rRigidHeel^3)-(rInnerHeel^3)) + ...
        (1/2)*pi*((rRigidHeel^2)-(rInnerHeel^2))*(hBackHeelPieceRigid) + ...
        rigidFootPlateThickness*dRigidHeel*dFromZ2_Z3 + ...
        2*wLoftingDimensionTip*lLoftingDimensionTip*lExtrusion6+(1/2)*(loftingDimension1+(2*wLoftingDimensionTip)*(dLoftingTipToSemiCircleApex-wLoftingDimensionTip))*lExtrusion6 + ...
        rigidFootPlateThickness*rRigidHeel*dFromZ3_Z4 + ...
        2*wExtrusion11*(rigidFootPlateThickness/2)*dFromZ2_Z3 + ...
        2*((wExtrusion11/2)^2)*dFromZ2_Z3 + ...
        2*(wExtrusion11)*(halfLStrapConnector*2)*hStrapConnector - ...
        2*wConnectorCut*(halfLStrapConnector*2)*depthConnectorCut - ...
        4*pi*(dPinHole^2)*((0.005/1.78)*patientHeight) + ...
        2*(lengthToOuterSemiCircle^2)*rigidFootPlateThickness+(pi/2)*((rRigidHeel^2)-(rInnerHeel^2))*0.05 + ...
        (1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2)) + ...
        0.005*0.001^2-(1/4)*pi*((rRigidHeel^2)-(rInnerHeel^2)) + ...
        (1/2)*pi*((rOuterHookCut^2)-(rInnerHookCut^2))*((0.015/1.78)*patientHeight);
     
     %% Outer Foot Piece Dimensions
     dSoftHeel = wFoot+((0.02/1.78)*patientHeight);
     rSoftHeel = dSoftHeel/2;
     
     % sketch6 and Extrude3 - shape outer heel lofts to
     outerFootPlateThickness = (0.01/1.78)*patientHeight;
     halfOuterFootPlateThickness = outerFootPlateThickness/2;
     loftingDimension2 = dSoftHeel-((0.01/1.78)*patientHeight);
     outer_lExtrusion3 = (0.0025/1.78)*patientHeight;
     
     outer_lExtrusion4 = (0.005/1.78)*patientHeight;
     outer_lExtrusion5and6 = (0.005/1.78)*patientHeight;
     LengthOfExtrusion6= outer_lExtrusion4 + lLoftingDimensionTip;
     
     %outer_lCut5 = (0.00485/1.78)*patientHeight;
     outer_lCut5 = outerFootPlateThickness/2;
     
     %With regards to sketch19, the toe piece cut through the side of the outer piece
     wToePieceCut = (0.015/1.78)*patientHeight;
     hToePieceCut = (0.005/1.78)*patientHeight;
     dFromEdgetoToePieceCutEdge = (0.01/1.78)*patientHeight;
     
     % With regards to sketch21, the cut for the toe piece on the top of the outer piece
     lToePieceCutTop = (0.015/1.78)*patientHeight;
     wToePieceCutTop = (0.01/1.78)*patientHeight;
     dFromEdgetoToePieceCutEdgeTop = (0.01/1.78)*patientHeight;
     outer_lCut8 = (0.005/1.78)*patientHeight;
     
     fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footOuterPieceDimensionsUpdated.txt', 'w');
        fprintf(fileID, '"dSoftHeel" = %7.7f\n', dSoftHeel);
        fprintf(fileID, '"rSoftHeel" = %7.7f\n', dSoftHeel/2);
        fprintf(fileID, '"dRigidHeel" = %7.7f\n', dRigidHeel);
        fprintf(fileID, '"rRigidHeel" = %7.7f\n', dRigidHeel/2);
        fprintf(fileID, '"hBackHeelPieceOuter" = %7.7f\n', hBackHeelPieceOuter);
        fprintf(fileID, '"loftingDimension2" = %7.7f\n', loftingDimension2);
        fprintf(fileID, '"outerFootPlateThickness" = %7.7f\n', outerFootPlateThickness);
        fprintf(fileID, '"halfOuterFootPlateThickness" = %7.7f\n', outerFootPlateThickness/2);
        fprintf(fileID, '"wLoftingDimensionTip" = %7.7f\n', wLoftingDimensionTip);
        fprintf(fileID, '"lLoftingDimensionTip" = %7.7f\n', lLoftingDimensionTip);
        fprintf(fileID, '"outer_lExtrusion3" = %7.7f\n', outer_lExtrusion3);
        fprintf(fileID, '"outer_lExtrusion4" = %7.7f\n', outer_lExtrusion4);
        fprintf(fileID, '"outer_lExtrusion5and6" = %7.7f\n', outer_lExtrusion5and6);
        fprintf(fileID, '"outer_lCut5" = %7.7f\n', outer_lCut5);
        fprintf(fileID, '"wToePieceCut" = %7.7f\n', wToePieceCut);
        fprintf(fileID, '"hToePieceCut" = %7.7f\n', hToePieceCut);
        fprintf(fileID, '"dFromEdgetoToePieceCutEdge" = %7.7f\n', dFromEdgetoToePieceCutEdge);
        fprintf(fileID, '"wToePieceCutTop" = %7.7f\n', wToePieceCutTop);
        fprintf(fileID, '"lToePieceCutTop" = %7.7f\n', lToePieceCutTop);
        fprintf(fileID, '"dFromEdgetoToePieceCutEdgeTop" = %7.7f\n', dFromEdgetoToePieceCutEdgeTop);
        fprintf(fileID, '"outer_lCut8" = %7.7f\n', outer_lCut8);
        fprintf(fileID, '"dFromZ1_Z2" = %7.7f\n', dFromZ1_Z2);
        fprintf(fileID, '"dFromZ2_Z3" = %7.7f\n', dFromZ2_Z3);
        fprintf(fileID, '"dFromZ3_Z4" = %7.7f\n', dFromZ3_Z4);
    	fprintf(fileID, '"dFromZ4_Z5" = %7.7f\n', dFromZ4_Z5);
        fprintf(fileID, '"dFromZ5_Z6" = %7.7f\n', dFromZ5_Z6);
     	fprintf(fileID, '"dFromZ2_Z4" = %f\n', dFromZ2_Z4);
        fprintf(fileID, '"distanceToLoftPlane" = %f\n', distanceToLoftPlane);
     	fprintf(fileID, '"LengthOfExtrusion6" = %f\n', LengthOfExtrusion6);
     fclose(fileID);
     
%% Outer Piece Volume Calculations
     obj.vOuterPiece = (1/4)*(4/3)*pi*((rSoftHeel^3)-(rInnerHeel^3)) + ...
    	(1/2)*pi*((rSoftHeel^2)-(rRigidHeel^2))*hBackHeelPieceOuter + ...
     	dSoftHeel*halfOuterFootPlateThickness*dFromZ2_Z4 + ...
        2*wLoftingDimensionTip*lLoftingDimensionTip*lExtrusion6+(1/2)*(loftingDimension2+(2*wLoftingDimensionTip)*(dLoftingTipToSemiCircleApex-wLoftingDimensionTip)*lExtrusion6 + ...
      	2*wLoftingDimensionTip*lLoftingDimensionTip*outer_lExtrusion4 + ...
       	((0.005/1.78)*patientHeight)*((0.002/1.78)*patientHeight) + ...
       	dFromZ2_Z4*dSoftHeel*halfOuterFootPlateThickness - ...
       	dFromZ2_Z3*dRigidHeel+outer_lExtrusion3*dRigidHeel+dFromZ3_Z4*rRigidHeel)*outer_lCut5 + ...
       	outerFootPlateThickness*dFromZ4_Z5*dSoftHeel - ...
       	wToePieceCut*hToePieceCut*dSoftHeel - ...
       	2*wToePieceCutTop*lToePieceCutTop*outer_lCut8 + ...
      	(1/2)*pi*dFromZ5_Z6^2*outerFootPlateThickness;
      
%% Side Piece Dimensions
    lSidePiece = (0.005/1.78)*patientHeight;
    wSidePiece = (0.015/1.78)*patientHeight;
    hSidePiece = (0.035/1.78)*patientHeight;
    dFromSidePieceOuterEdgeToInnerCutEdge= (0.0015/1.78)*patientHeight;
    dLargePinHoleSidePiece = (0.005/1.78)*patientHeight;
    dFromEdgeToLargePinHoleCentre = (0.005/1.78)*patientHeight;
    dSmallPinHoleSidePiece = (0.002/1.78)*patientHeight;
    dFromEdgeToSmallPinHoleCentre = (0.0035/1.78)*patientHeight;
    LengthFromExtrude=(0.0035/1.78)*patientHeight;
    dSmallPinHoleInsertPiece = (0.002/1.78)*patientHeight;
    dSmallPin = dSmallPinHoleInsertPiece + (0.00075/1.78)*patientHeight;
    lSmallPin = (0.00075/1.78)*patientHeight;
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footSidePieceDimensionsUpdated.txt', 'w');
        fprintf(fileID, '"lSidePiece" = %7.7f\n', lSidePiece);
        fprintf(fileID, '"wSidePiece" = %7.7f\n', wSidePiece);
        fprintf(fileID, '"hSidePiece" = %7.7f\n', hSidePiece);
        fprintf(fileID, '"dFromSidePieceOuterEdgeToInnerCutEdge" = %7.7f\n', dFromSidePieceOuterEdgeToInnerCutEdge);
        fprintf(fileID, '"dLargePinHoleSidePiece" = %7.7f\n', dLargePinHoleSidePiece);
        fprintf(fileID, '"dFromEdgeToLargePinHoleCentre" = %7.7f\n', dFromEdgeToLargePinHoleCentre);
        fprintf(fileID, '"dSmallPinHoleSidePiece" = %7.7f\n', dSmallPinHoleSidePiece);
        fprintf(fileID, '"dFromEdgeToSmallPinHoleCentre" = %7.7f\n', dFromEdgeToSmallPinHoleCentre);
        fprintf(fileID, '"LengthFromExtrude" = %7.7f\n', LengthFromExtrude);
        fprintf(fileID, '"dSmallPin" = %f\n', dSmallPin);
        fprintf(fileID, '"lSmallPin" = %f\n', lSmallPin);
    fclose(fileID);
      
%% Side Piece Piece Volume Calculations
    obj.vSidePiece = lSidePiece*wSidePiece*hSidePiece - ...
        hSidePiece*(lSidePiece-(2*dFromSidePieceOuterEdgeToInnerCutEdge))*(wSidePiece-(2*dFromSidePieceOuterEdgeToInnerCutEdge)) - ...
        2*pi*dFromSidePieceOuterEdgeToInnerCutEdge*dLargePinHoleSidePiece^2 - ...
        2*dFromSidePieceOuterEdgeToInnerCutEdge*pi*dSmallPinHoleSidePiece^2;
            
%% Strap Insert Piece Dimensions
     
     lInsertPiece = (0.012/1.78)*patientHeight;
     wInsertPiece = (0.002/1.78)*patientHeight;
     hInsertPiece = (0.04/1.78)*patientHeight;
     
     dLargePinHoleInsertPiece = (0.005/1.78)*patientHeight;
     dSmallPinHoleInsertPiece = (0.002/1.78)*patientHeight;
     dFromEdgeToLargePinHoleCentre = (0.005/1.78)*patientHeight;
     dBetweenSmallPinHoleCentres = (0.004/1.78)*patientHeight;
     insertPiece_fillet1 = (0.0005/1.78)*patientHeight;
     
     fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footInsertPieceDimensionsUpdated.txt', 'w');
        fprintf(fileID, '"lInsertPiece" = %7.7f\n', lInsertPiece);
        fprintf(fileID, '"wInsertPiece" = %7.7f\n', wInsertPiece);
        fprintf(fileID, '"hInsertPiece" = %7.7f\n', hInsertPiece);
        fprintf(fileID, '"dLargePinHoleInsertPiece" = %7.7f\n', dLargePinHoleInsertPiece);
    	fprintf(fileID, '"dSmallPinHoleInsertPiece" = %7.7f\n', dSmallPinHoleInsertPiece);
    	fprintf(fileID, '"dFromEdgeToLargePinHoleCentre" = %7.7f\n', dFromEdgeToLargePinHoleCentre);
     	fprintf(fileID, '"dBetweenSmallPinHoleCentres" = %7.7f\n', dBetweenSmallPinHoleCentres);
        fprintf(fileID, '"dBetweenSmallPinHoleCentresTimesTwo" = %7.7f\n', dBetweenSmallPinHoleCentres*2);
     	fprintf(fileID, '"insertPiece_fillet1" = %f\n', insertPiece_fillet1);
     fclose(fileID);
            
%% Strap Insert Piece Volume Calculations
     obj.vStrapInsertPiece = wInsertPiece*hInsertPiece*lInsertPiece - ...
        wInsertPiece*pi*(dLargePinHoleInsertPiece^2) - ...
        7*wInsertPiece*pi*dSmallPinHoleInsertPiece^2;
            
%% Toe Insert Piece Dimensions
   	lBase = dSoftHeel;
   	wBase = (0.015/1.78)*patientHeight;
  	hBase = (0.005/1.78)*patientHeight;
  	lToeStrapConnector = (0.01/1.78)*patientHeight;
   	hToeStrapConnector = (0.02/1.78)*patientHeight;
  	wToeStrapCut = (0.005/1.78)*patientHeight;
 	hToeStrapCut = (0.02/1.78)*patientHeight;
  	dLargePinHoleToePiece = (0.005/1.78)*patientHeight;
	dFromEdgeToLargeHolePinCentreToePiece = (0.0075/1.78)*patientHeight;
    dLargePinHead = dLargePinHoleToePiece+(0.0025/1.78)*patientHeight;
    lLargePin = (0.00125/1.78)*patientHeight;
      
	fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footToeInsertPieceDimensionsUpdated.txt', 'w');
        fprintf(fileID, '"lBase" = %7.7f\n', lBase);
        fprintf(fileID, '"wBase" = %7.7f\n', wBase);
        fprintf(fileID, '"hBase" = %7.7f\n', hBase);
    	fprintf(fileID, '"lToeStrapConnector" = %7.7f\n', lToeStrapConnector);
        fprintf(fileID, '"hToeStrapConnector" = %7.7f\n', hToeStrapConnector);
      	fprintf(fileID, '"wToeStrapCut" = %7.7f\n', wToeStrapCut);
       	fprintf(fileID, '"wHalfToeStrapCut" = %7.7f\n', wToeStrapCut/2);
     	fprintf(fileID, '"hToeStrapCut" = %7.7f\n', hToeStrapCut);
     	fprintf(fileID, '"dLargePinHoleToePiece" = %7.7f\n', dLargePinHoleToePiece);
     	fprintf(fileID, '"dFromEdgeToLargeHolePinCentreToePiece" = %7.7f\n', dFromEdgeToLargeHolePinCentreToePiece);
        fprintf(fileID, '"dLargePinHead" = %7.7f\n', dLargePinHead);
        fprintf(fileID, '"lLargePin" = %7.7f\n', lLargePin);
    fclose(fileID);
            
%% Toe Insert Piece Volume Calculations
    obj.vToeInsertPiece = wBase*lBase*hBase + ...
        2*wBase*lToeStrapConnector*hToeStrapConnector - ...
        2*wToeStrapCut*lToeStrapConnector*hToeStrapCut - ...
        2*(wBase-wToeStrapCut)*pi*dLargePinHoleToePiece^2;
            
%% Ankle Strap Piece Dimensions
	ankleStrapRadius = (0.1/1.78)*patientHeight;
	ankleStrapInnerLength = (0.02/1.78)*patientHeight;
	ankleStrapOuterLength = (0.025/1.78)*patientHeight;
   	ankleStrapWidth = dRigidHeel - (0.002/1.78)*patientHeight;
  	ankleStrapThickness = (0.005/1.78)*patientHeight;
	ankleStrapExtrusion = (0.02/1.78)*patientHeight;
  	dLargePinHoleAnkleStrapPiece = (0.005/1.78)*patientHeight;
   	dFromEdgeToLargeHolePinCentreAnkleStrapPiece = (0.0075/1.78)*patientHeight;
       
        
	fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footAnkleStrapPieceDimensionsUpdated.txt', 'w');
        fprintf(fileID, '"ankleStrapRadius" = %7.7f\n', ankleStrapRadius);
       	fprintf(fileID, '"ankleStrapInnerLength" = %7.7f\n', ankleStrapInnerLength);
       	fprintf(fileID, '"ankleStrapOuterLength" = %7.7f\n', ankleStrapOuterLength);
      	fprintf(fileID, '"ankleStrapWidth" = %7.7f\n', ankleStrapWidth);
       	fprintf(fileID, '"ankleStrapThickness" = %7.7f\n', ankleStrapThickness);
       	fprintf(fileID, '"ankleStrapExtrusion" = %7.7f\n', ankleStrapExtrusion);
      	fprintf(fileID, '"dLargePinHoleAnkleStrapPiece" = %7.7f\n', dLargePinHoleAnkleStrapPiece);
       	fprintf(fileID, '"dFromEdgeToLargeHolePinCentreAnkleStrapPiece" = %7.7f\n', dFromEdgeToLargeHolePinCentreAnkleStrapPiece);     
        fprintf(fileID, '"dLargePinHead" = %7.7f\n', dLargePinHead);
        fprintf(fileID, '"lLargePin" = %7.7f\n', lLargePin);
    fclose(fileID);
            
%% Ankle Strap Piece Volume Calculations
    %obj.vAnkleStrapPiece = 2*ankleStrapInnerLength*ankleStrapThickness+(pi/2)*((ankleStrapRadius^2)-((ankleStrapRadius-(2*ankleStrapThickness))^2)) - ...
        %2*pi*ankleStrapThickness*dLargePinHoleAnkleStrapPiece^2;
    
    obj.vAnkleStrapPiece = 2*ankleStrapThickness*ankleStrapInnerLength*ankleStrapExtrusion + ...
        (ankleStrapWidth-(2*ankleStrapThickness))*(ankleStrapOuterLength-ankleStrapInnerLength)*ankleStrapExtrusion - ...
        2*pi*dLargePinHoleAnkleStrapPiece^2*ankleStrapThickness;
            
%% Toe Strap Piece Dimensions
    toeStrapRadius = (0.15/1.78)*patientHeight;
	toeStrapExtrusion = (0.02/1.78)*patientHeight;
	toeStrapWidth = dRigidHeel - (0.002/1.78)*patientHeight;
	toeStrapThickness = (0.005/1.78)*patientHeight;
	toeStrapInnerLength = (0.02/1.78)*patientHeight;
	toeStrapOuterLength = (0.04/1.78)*patientHeight;
	dLargePinHoleToeStrapPiece = (0.005/1.78)*patientHeight;
	dFromEdgeToLargeHolePinCentreToeStrapPiece = (0.0075/1.78)*patientHeight;
	rToeHookOuterCut = (0.01/1.78)*patientHeight;
	rToeHookInnerCut = (0.0025/1.78)*patientHeight;
	dToeHookCutExtrude = (0.015/1.78)*patientHeight;
	rToeStrapFillet = (0.01/1.78)*patientHeight;
    r1DorsiSpring = dorsiSpring.r1DorsiSpring;
    dDorsiSpringWire = dorsiSpring.dDorsiSpringWire;
    LengthToCutPlane3 = (0.05/1.78)* patientHeight;
       
	fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footToeStrapPieceDimensionsUpdated.txt', 'w');
       fprintf(fileID, '"toeStrapRadius" = %7.7f\n', toeStrapRadius);
       fprintf(fileID, '"toeStrapInnerLength" = %7.7f\n', toeStrapInnerLength);
       fprintf(fileID, '"toeStrapOuterLength" = %7.7f\n', toeStrapOuterLength);
       fprintf(fileID, '"toeStrapWidth" = %7.7f\n', toeStrapWidth);
       fprintf(fileID, '"toeStrapThickness" = %7.7f\n', toeStrapThickness);
       fprintf(fileID, '"toeStrapExtrusion" = %7.7f\n', toeStrapExtrusion);
       fprintf(fileID, '"dLargePinHoleToeStrapPiece" = %7.7f\n', dLargePinHoleToeStrapPiece);
       fprintf(fileID, '"dFromEdgeToLargeHolePinCentreToeStrapPiece" = %7.7f\n', dFromEdgeToLargeHolePinCentreToeStrapPiece);
       fprintf(fileID, '"rToeHookOuterCut" = %7.7f\n', rToeHookOuterCut);
       fprintf(fileID, '"rToeHookInnerCut" = %7.7f\n', rToeHookInnerCut);
       fprintf(fileID, '"dToeHookCutExtrude" = %7.7f\n', dToeHookCutExtrude);
       fprintf(fileID, '"rToeStrapFillete" = %7.7f\n', rToeStrapFillet);
       fprintf(fileID, '"dLargePinHead" = %7.7f\n', dLargePinHead);
       fprintf(fileID, '"lLargePin" = %7.7f\n', lLargePin);
       fprintf(fileID, '"r1DorsiSpring" = %7.7f\n', r1DorsiSpring);
       fprintf(fileID, '"dDorsiSpringWire" = %7.7f\n', dDorsiSpringWire); 
       fprintf(fileID, '"LengthToCutPlane3" = %7.7f\n', LengthToCutPlane3); 
       
    fclose(fileID);
            
%% Toe Strap Volume Calculations
    obj.vToeStrapPiece = 2*toeStrapThickness*toeStrapInnerLength*toeStrapExtrusion + ...
        (toeStrapWidth-(2*toeStrapThickness))*(toeStrapOuterLength - toeStrapInnerLength)*toeStrapExtrusion - ...
        2*pi*dLargePinHoleAnkleStrapPiece^2*toeStrapThickness - ...
        (pi/2)*(rToeHookOuterCut^2-rToeHookInnerCut^2)*dToeHookCutExtrude;
    
    largePinBodyLength = lToeStrapConnector;
    smallPinBodyLength = lSidePiece - lSmallPin;
    largeStrapPinBodyLength = wInsertPiece + toeStrapThickness;
    
    fileID = fopen('C:\MCG4322B\Group3\Solidworks\Equations\footPinDimensions.txt', 'w');
        fprintf(fileID, '"dLargePinHead" = %7.7f\n', dLargePinHead);
        fprintf(fileID, '"lLargePin" = %7.7f\n', lLargePin);
        fprintf(fileID, '"dSmallPin" = %7.7f\n', dSmallPin);
        fprintf(fileID, '"lSmallPin" = %7.7f\n', lSmallPin);
        fprintf(fileID, '"largePinBodyLength" = %7.7f\n', largePinBodyLength);
        fprintf(fileID, '"smallPinBodyLength" = %7.7f\n', smallPinBodyLength);
        fprintf(fileID, '"largeStrapPinBodyLength" = %7.7f\n', largeStrapPinBodyLength);
        fprintf(fileID, '"dLargePinHoleToeStrapPiece" = %7.7f\n', dLargePinHoleToeStrapPiece);
        fprintf(fileID, '"dSmallPinHoleInsertPiece" = %7.7f\n', dSmallPinHoleInsertPiece);
    fclose(fileID);
 
    obj.vFootPins = 4*pi*(dLargePinHead/2)^2*lLargePin + 4*pi*(dLargePinHoleToeStrapPiece/1)^2*largePinBodyLength + ...
        4*pi*(dLargePinHead/2)^2*lLargePin + 4*pi*(dLargePinHoleToeStrapPiece/1)^2*largeStrapPinBodyLength + ...
        4*pi*(dSmallPin/2)^2*lSmallPin + 4*pi*(dSmallPinHoleInsertPiece/2)^2*smallPinBodyLength;
        end   
        
        function obj = SetAllMassesOfComponents(obj)
            densityOfAluminum = 2700; % kg/m^3
            densityOfMemoryFoam = 48.06; %kg/m^3
            densityOfHardDrawnSteel = 7850; %kg/m^3
            densityOfStainlessSteel = 7700; %kg/m^3
            densityOfHDPE = 950; % kg/m^3
            densityOfPVC = 1467; % kg/m^3
            densityOfRubber = 1522; % kg/m^3
            
            mMetalHipAttachmemtsDimension = obj.vMetalHipAttachmemtsDimension * densityOfAluminum;
            mHipPadding = obj.vHipPadding* densityOfMemoryFoam;
            mHip2DOFJointBearing = obj.vHip2DOFJointBearing * densityOfStainlessSteel;
            mHip2DOFJointShaft = obj.vHip2DOFJointShaft * densityOfAluminum;
            mHip2DOFJointOutputShaft = obj.vHip2DOFJointOutputShaft * densityOfAluminum;
            mHip2DOFJointCasing = obj.vHip2DOFJointCasing * densityOfHDPE; 
            mMedialDiscBallBearing = obj.vMedialDiscBallBearing * densityOfStainlessSteel;
            mHipMedialDisc = obj.vHipMedialDisc * densityOfAluminum;
            mParametrizedPulley = obj.vParametrizedPulley * densityOfAluminum;

            mDorsiCamDimensions = obj.vDorsiCamDimensions * densityOfPVC;
            mDorsiCamShaft = obj.vDorsiCamShaft * densityOfAluminum;
            mPlantarCamBearing = obj.vPlantarCamBearing * densityOfStainlessSteel;
            mDorsiCamBearing = obj.vDorsiCamBearing * densityOfStainlessSteel;
            mCamRetainingRing = obj.vCamRetainingRing * densityOfHardDrawnSteel;
            mDorsiRetainingRing1 = obj.vDorsiRetainingRing1 * densityOfHardDrawnSteel;
            mDorsiRetainingRing2 = obj.vDorsiRetainingRing2 * densityOfHardDrawnSteel;
            mPlantarCam = obj.vPlantarCam * densityOfPVC;
            mPlantarCamShaft = obj.vPlantarCamShaft * densityOfAluminum;
            mBotBar = obj.vBotBar * densityOfAluminum;
            mLink4 = obj.vLink4 * densityOfAluminum;
            mLink2 = obj.vLink2 * densityOfAluminum;
            m4BarBolts = obj.v4BarBolts * densityOfHDPE;
            mTopBar = obj.vTopBar * densityOfAluminum;
            mCalfCase = obj.vCalfCase * densityOfPVC;
            mCalfPadding = obj.vCalfPadding * densityOfMemoryFoam;
            mThighCase = obj.vThighCase * densityOfPVC;
            mThighPadding = obj.vThighPadding * densityOfMemoryFoam;

            mRigidPiece = obj.vRigidPiece * densityOfPVC; % could be carbon fiber
            mOuterPiece = obj.vOuterPiece * densityOfRubber; 
            mSidePiece = obj.vSidePiece * densityOfPVC;
            mStrapInsertPiece = obj.vStrapInsertPiece * densityOfPVC;
            mToeInsertPiece = obj.vToeInsertPiece * densityOfPVC;
            mAnkleStrapPiece = obj.vAnkleStrapPiece * densityOfPVC;
            mToeStrapPiece = obj.vToeStrapPiece * densityOfPVC;
            mFootPins = obj.vFootPins * densityOfHDPE;
            
            %% Calculate masses
            obj.totalMassOfExoskeleton = mMetalHipAttachmemtsDimension + mHipPadding ...
                + 2*mHip2DOFJointBearing + 2*mHip2DOFJointShaft + 2*mHip2DOFJointOutputShaft + ...
                2*mHip2DOFJointCasing + 2*mMedialDiscBallBearing + 2*mHipMedialDisc + 4*mParametrizedPulley + ...
                2*mDorsiCamDimensions + 2*mDorsiCamShaft + 2*mPlantarCamBearing + 2*mDorsiCamBearing + ... 
                2*mCamRetainingRing + 2*mDorsiRetainingRing1 + 2*mDorsiRetainingRing2 + 2*mPlantarCam +...
                2*mPlantarCamShaft + 2*mBotBar + 4*mLink4 + 2*mLink2 + 8*m4BarBolts + 2*mTopBar + 2*mCalfCase + ...
                2*mCalfPadding + 2*mThighCase + 2*mThighPadding + 2*mRigidPiece + 2*mOuterPiece + 8*mSidePiece + ...
                8*mStrapInsertPiece + 2*mToeInsertPiece + 2*mAnkleStrapPiece + 2*mToeStrapPiece + 16*mFootPins; 
            % add the small pins - 8 small pins total
            
            obj.thighExoMass = mMetalHipAttachmemtsDimension*(1/2) + mHipPadding*(1/2) ...
                + mHip2DOFJointBearing + mHip2DOFJointShaft + mHip2DOFJointOutputShaft + ...
                mHip2DOFJointCasing + mMedialDiscBallBearing + mHipMedialDisc + mThighCase + mThighPadding;
            obj.shankExoMass = 2*mParametrizedPulley + mDorsiCamDimensions + mDorsiCamShaft + ...
                mPlantarCamBearing + mDorsiCamBearing + mCamRetainingRing + mDorsiRetainingRing1 + ...
                mDorsiRetainingRing2 + mPlantarCam + mPlantarCamShaft + mBotBar + 2*mLink4 + ...
                mLink2 + 4*m4BarBolts + mTopBar + mCalfCase + mCalfPadding;
            obj.footExoMass = mRigidPiece + mOuterPiece + 4*mSidePiece + ...
                4*mStrapInsertPiece + mToeInsertPiece + mAnkleStrapPiece + mToeStrapPiece + ...
                8*mFootPins;
            % add 4 little pins into this design
            
            obj.hipBoltsLeftMass = + mHip2DOFJointBearing + mHip2DOFJointShaft + mHip2DOFJointOutputShaft + ...
                mHip2DOFJointCasing + mMedialDiscBallBearing + mHipMedialDisc + mThighCase + mThighPadding + ...
                2*mParametrizedPulley + mDorsiCamDimensions + mDorsiCamShaft + ...
                mPlantarCamBearing + mDorsiCamBearing + mCamRetainingRing + mDorsiRetainingRing1 + ...
                mDorsiRetainingRing2 + mPlantarCam + mPlantarCamShaft + mBotBar + 2*mLink4 + ...
                mLink2 + 4*m4BarBolts + mTopBar + mCalfCase + mCalfPadding + ...
                mRigidPiece + mOuterPiece + 4*mSidePiece + ...
                4*mStrapInsertPiece + mToeInsertPiece + mAnkleStrapPiece + mToeStrapPiece + ...
                8*mFootPins;
            
            obj.hipBoltsRightMass = mMetalHipAttachmemtsDimension*(1/2) + mHipPadding*(1/2);
            
            obj.thighBoltsLeftMass =  2*mParametrizedPulley + mDorsiCamDimensions + mDorsiCamShaft + ...
                mPlantarCamBearing + mDorsiCamBearing + mCamRetainingRing + mDorsiRetainingRing1 + ...
                mDorsiRetainingRing2 + mPlantarCam + mPlantarCamShaft + mBotBar + 2*mLink4 + ...
                mLink2 + 4*m4BarBolts + mTopBar + mCalfCase + mCalfPadding + ...
                mRigidPiece + mOuterPiece + 4*mSidePiece + ...
                4*mStrapInsertPiece + mToeInsertPiece + mAnkleStrapPiece + mToeStrapPiece + ...
                8*mFootPins;
            
            obj.thighBoltsRightMass = mThighCase + mThighPadding;
            
            obj.shankBoltsLeftMass = (mBotBar/2) + mRigidPiece + mOuterPiece + 4*mSidePiece + ...
                4*mStrapInsertPiece + mToeInsertPiece + mAnkleStrapPiece + mToeStrapPiece + ...
                8*mFootPins;
            
            obj.shankBotlsRightMass = mCalfCase + mCalfPadding;
        end
    end
end

    
