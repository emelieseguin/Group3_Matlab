function BoltCalcs(hipWeightOfPartsLeft, hipWeightOfPartsRight, thighWeightOfPartsLeft, thighWeightOfPartsRight, ...
    shankWeightOfPartsLeft, shankWeightOfPartsRight)
    %% Determining Tensile Stress of the Thread
    %determing At allows for the proper selection of screws
    %screw selection is based on table 10.2 (pg 414) in machine component design textbook
    Sp = 380; %from table 10.5 of same book, is in N/mm^2
    %SF = 4; %SF of 2.5 is acceptable, textbook uses 4 to be safe though
    %At = (fBolt*SF)/Sp; %tensile stress of the thread but not using this particular equation

    %% Initial Tensile Force and Tightening Torque
    % not necessarily needed, just something else to determine
    %d = 0.035; %d relies on the screw's picked based on the At result, so not sure if it can be here
    %Fi = 0.9*At*Sp; %initial tensile force
    %T = 0.2*Fi*d; %tightening torque

    %% Machine Screws Calcs at the Hip Interface
    %attachs entire limb to the waist attachment
    %two bolts boths side, total 4
    %bolts on same transverse plane

    Sp = 380; %changes based on screw material picked, 380 refers to SAE 5.8 steel
    theoreticalHipSF = 1.5; %a safety factor we can pick, set to 1.5 at top of range?
    hipNumScrews = 2; %number of screws used at the interface, can be changed based on forces experienced
    hipFScrewLeftSide = hipWeightOfPartsLeft*9.81; %full weight of one entire limb portion of the exo
    hipFScrewRightSide = hipWeightOfPartsRight*9.81; %half the weight of the waste attachment bar
    hipFBolt = (hipFScrewLeftSide + hipFScrewRightSide)/hipNumScrews;
    theotricalHipAt = (hipFBolt*theoreticalHipSF)/Sp; %this would then be At at the top of range, so if we pick a bolt that works here,
    %and we keep the same bolt, it should then always work

    actualHipAt = 0.3;
    actualHipSF = (actualHipAt*Sp)/hipFBolt;

    %% Bolt Calcs at the Thigh Attachment Interface
    % attaches thigh to the exoskeleton
    % two bolts both sides, total 4
    % bolts on same sagittal plane 

    Sp = 380;
    theoreticalThighSF = 1.5;
    thighNumScrews = 2;
    thighFScrewLeftSide = thighWeightOfPartsLeft*9.81; %will be the weight of the upper limb portion and everything below
    thighFScrewRightSide = thighWeightOfPartsRight*9.81; %will be the weight of the thigh attachment piece
    thighFBolt = (thighFScrewLeftSide + thighFScrewRightSide)/thighNumScrews;
    theoreticalThighAt = (thighFBolt*theoreticalThighSF)/Sp;

    %thighAt at top of height range ensures we pick the right bolt with an At > larger than what was calculated
    %then we used the At of the screw we picked, along with the force on the bolt and its Sp to solve for the safety factor
    %fBolt will change when the weights change due to height changes, so we can see how the SF flucuates through our height range
    actualThighAt = 1.0; %tentatively set to 1.0
    actualThighSF = (actualThighAt*Sp)/thighFBolt;

    %% Bolt Calcs at the Shank Attachment Interface
    % attaches shank to the exoskeleton
    % two bolts on both sides, total 4

    Sp = 380;
    theoreticalShankSF = 1.5;
    shankNumScrews = 2;
    shankFScrewLeftSide = shankWeightOfPartsLeft*9.81; %will be the weight of the lower limb portion of the exo
    shankFScrewRightSide = shankWeightOfPartsRight*9.81; %will be the weight of the shank attachment piece
    shankFBolt = (shankFScrewLeftSide + shankFScrewRightSide)/shankNumScrews;
    shankAt = (shankFBolt*theoreticalShankSF)/Sp;

    actualShankAt = 1.0;
    actualShankSF = (actualShankAt*Sp)/shankFBolt;
end