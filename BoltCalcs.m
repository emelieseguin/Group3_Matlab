function BoltCalcs(fBolt)
%% Determining Tensile Stress of the Thread
%determing At allows for the proper selection of screws
%screw selection is based on table 10.2 (pg 414) in machine component design textbook
Sp = 380; %from table 10.5 of same book, is based on the class of steel we pick, currently SAE 5.8
SF = 4; %SF of 2.5 is acceptable, textbook uses 4 to be safe though
At = (fBolt*SF)/Sp; %tensile stress of the thread
%getting At allows us to pick screws that work for the situation
%screwAt\>calculatedAt
%we can also pick a screw before this with a certain At, and then prove it
%works with the same calculation

%% Initial Tensile Force and Tightening Torque
% not necessarily needed, just something else to determine
d = 0.035; %d relies on the screw's picked based on the At result, so not sure if it can be here
Fi = 0.9*At*Sp; %initial tensile force
T = 0.2*Fi*d; %tightening torque
end