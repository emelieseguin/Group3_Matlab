function HipJointBearingCalcs(fThrust, fRadial, angularVelocity, chosenC)

% so in this case, it's very much the same calculations as the hip shaft,
% but the radial force may not be calculated yet. If it is known where the
% force is located on the pin shaft, then the radial force on the bearing
% can be determined using the following equation

% Frn = -Fn + (ln/lt)*Fn if the force Fn is negative
% Frn = Fn - (ln/lt)*Fn if the force is positive
% ie Fr1 = F1 - (l1/lt)*F1 where F1 is the force at location l1 from the
% bearing, and lt is the total length of the shaft

% then add up all the Frn values to get the overall radial force fRadial
% ie Fr = Fn1+Fn2+Fn3

pinRPM = angularVelocity * 9.5493; %converting rads/sec to rpm
Ka = 1.5; %Light impact application, picked value at top of range for safety
designLife = 40000; %Inbetween 8-hour service every working day (30000 hours) and continuous 24-hour service (50000 hours)
life = pinRPM*designLife*60;
Kr = 1; %from standard 90% reliability
Lr = (9.6)*10^6; %life corresponding to rated capacity

if ((fThrust/fRadial)<=0.35)
    fEquivalent = fRadial;
elseif ((fThrust/fRadial)>0.35 && (fThrust/fRadial)<10)
    fEquivalent = fRadial * ((1+1.115)*((fThrust/fRadial)-0.35));
elseif ((fThrust/fRadial)>=10)
    fEquivalent = 1.176*fThrust;
end

requiredC = fEquivalent*Ka*((life/(Kr*Lr))^0.3); %calculate the requiredC to be compared with the chosenC of the bearing
% doing so ensures the bearings we picked actually worked

radialLoadLife = Kr*Lr*((chosenC/(fEquivalent*Ka))^3.33); % we can further prove our bearings work by determining it's life based on radial load
% doing so can show that the life of our bearing will be long enough



end