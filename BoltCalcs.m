function BoltCalcs(hipWeightOfPartsLeft, hipWeightOfPartsRight, thighWeightOfPartsLeft, thighWeightOfPartsRight, ...
    shankWeightOfPartsLeft, shankWeightOfPartsRight)
    %% Determining Tensile Stress of the Thread
    % Determing At allows for the proper selection of screws
    % Screw selection is based on table 10.2 (pg 414) in machine component design textbook
    Sp = 380; %from table 10.5 of same book, is in N/mm^2
    %SF = 4; %SF of 2.5 is acceptable, textbook uses 4 to be safe though
    %At = (fBolt*SF)/Sp; %tensile stress of the thread but not using this particular equation

    %% Initial Tensile Force and Tightening Torque
    % Not necessarily needed, just something else to determine
    %d = 0.035; %d relies on the screw's picked based on the At result, so not sure if it can be here
    %Fi = 0.9*At*Sp; %initial tensile force
    %T = 0.2*Fi*d; %tightening torque

    %% Machine Screws Calcs at the Hip Interface
    % Attachs entire limb to the waist attachment
    % Two bolts boths side, total 4
    % Bolts on same transverse plane

    theoreticalHipSF = 1.5; % A safety factor we can pick, set to 1.5 at top of range?
    hipNumScrews = 2; % Number of screws used at the interface, can be changed based on forces experienced
    hipFScrewLeftSide = hipWeightOfPartsLeft*9.81; % Full weight of one entire limb portion of the exo
    hipFScrewRightSide = hipWeightOfPartsRight*9.81; % Half the weight of the waste attachment bar
    hipFBolt = (hipFScrewLeftSide + hipFScrewRightSide)/hipNumScrews;
    theotricalHipAt = (hipFBolt*theoreticalHipSF)/Sp; % This would then be At at the top of range, so if we pick a bolt that works here,
    % And we keep the same bolt, it should then always work

    actualHipAt = 1.7;
    actualHipSF = (actualHipAt*Sp)/hipFBolt;

    %% Bolt Calcs at the Thigh Attachment Interface
    % Attaches thigh to the exoskeleton
    % Two bolts both sides, total 4
    % Bolts on same sagittal plane 

    theoreticalThighSF = 1.5;
    thighNumScrews = 1;
    thighFScrewLeftSide = thighWeightOfPartsLeft*9.81; %will be the weight of the upper limb portion and everything below
    thighFScrewRightSide = thighWeightOfPartsRight*9.81; %will be the weight of the thigh attachment piece
    thighFBolt = (thighFScrewLeftSide + thighFScrewRightSide)/thighNumScrews;
    theoreticalThighAt = (thighFBolt*theoreticalThighSF)/Sp;

    % ThighAt at top of height range ensures we pick the right bolt with an At > larger than what was calculated
    % Then we used the At of the screw we picked, along with the force on the bolt and its Sp to solve for the safety factor
    % FBolt will change when the weights change due to height changes, so we can see how the SF flucuates through our height range
    actualThighAt = 1.7; %tentatively set to 1.0
    actualThighSF = (actualThighAt*Sp)/thighFBolt;

    %% Bolt Calcs at the Shank Attachment Interface
    % Attaches shank to the exoskeleton
    % Two bolts on both sides, total 4

    theoreticalShankSF = 1.5;
    shankNumScrews = 1;
    shankFScrewLeftSide = shankWeightOfPartsLeft*9.81; % Will be the weight of the lower limb portion of the exo
    shankFScrewRightSide = shankWeightOfPartsRight*9.81; % Will be the weight of the shank attachment piece
    shankFBolt = (shankFScrewLeftSide + shankFScrewRightSide)/shankNumScrews;
    shankAt = (shankFBolt*theoreticalShankSF)/Sp;

    actualShankAt = 1.7;
    actualShankSF = (actualShankAt*Sp)/shankFBolt;
end