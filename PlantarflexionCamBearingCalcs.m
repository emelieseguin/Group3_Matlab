function PlantarflexionCamBearingCalcs(fRadial, fThrust)
%% Setting up the initial variables
gaitPercentage = 0.195; %found with spring length graphs
gaitCycleTime = 1.48478;
thighAngularVelocity = (pi/2)/(gaitPercentage*gaitCycleTime);
shaftRPM = thighAngularVelocity * 9.5493; %converting rads/sec to rpm
Ka = 1.5; %Light impact application, picked value at top of range for safety
designLife = 40000; %Inbetween 8-hour service every working day (30000 hours) and continuous 24-hour service (50000 hours)
life = shaftRPM*designLife*60;
Kr = 1; %from standard 90% reliability
Lr = (9.6)*10^6; %life corresponding to rated capacity

%% Determing fEquivalent
% the fEquivalent formulas below are for radial ball bearing since,
% equation can be updated if we use an angular bearing instead
if ((fThrust/fRadial)<=0.35)
    fEquivalent = fRadial;
elseif ((fThrust/fRadial)>0.35 && (fThrust/fRadial)<10)
    fEquivalent = fRadial * ((1+1.115)*((fThrust/fRadial)-0.35));
elseif ((fThrust/fRadial)>=10)
    fEquivalent = 1.176*fThrust;
end

%% Determining requiredC to be compared with chosen C
requiredC = fEquivalent*Ka*((life/(Kr*Lr))^0.3); %calculate the requiredC to be compared with the chosenC of the bearing
% doing so ensures the bearings we picked actually worked

%% Determining load life to ensure bearing lasts
radialLoadLife = Kr*Lr*((chosenC/(fEquivalent*Ka))^3.33); % we can further prove our bearings work by determining it's life based on radial load
% doing so can show that the life of our bearing will be long enough

end