classdef NormalizeCopData
   properties
       % Percentage in gait
       HealStrikePercentage
       ToeOffPercentage
       % Normalized COP array as a percentage of foot length from the heel
       NormalizedCopArray_FromHeel
   end
   
   methods 
      function obj = NormalizeCopData(rawCopDataCsv, ...
          heelStrikePercentage, toeOffPercentage, patientFootLengthInMm)
        
        obj.HealStrikePercentage = heelStrikePercentage;
        obj.ToeOffPercentage = toeOffPercentage;
     
        csvArray=csvread(rawCopDataCsv, 1);
        % Select the raw Com X data
        rawCopX = csvArray(:, 4);
        numberCopFrames = length(rawCopX);
        
        % Percent gait to average the COM values over
        numberGaitFrames = toeOffPercentage - heelStrikePercentage;
        %forceInLeftLegGaitTime = numberGaitFrames*timeSamplingRate;
        
        mmCopArray = obj.GetNormalizedCop(rawCopX, numberCopFrames, numberGaitFrames);
        % Get the array in terms of mm from the heel
        obj.NormalizedCopArray_FromHeel = obj.GetCopArrayAsPercentageFootLengthFromHeel(mmCopArray, patientFootLengthInMm);
      end 
      
      function normalizedCopArray = GetNormalizedCop(~, rawCopX, numberCopFrames, ...
              numberGaitFrames)
          
          % Number of frames from Cop that must be averaged into 1 gait frame
          framesToAvg = round(numberCopFrames/numberGaitFrames);
          % Index of rawComx array to access points in groups of 3, to
          % be put into the gait positions
          singleCopFrameInterval = (numberCopFrames/numberGaitFrames)/framesToAvg;
          
          normalizedCopArray = zeros(1, numberGaitFrames);
          % Average out the values
          currentFramePosition = singleCopFrameInterval;
          gaitFrameCount = 1;
          while(gaitFrameCount <= numberGaitFrames)
              % Get the averageCop from the next # of frames to average
             totalCom = 0;
              for i=1:framesToAvg
                  % Only add the COP if the currentFrame does not go past the end of the array
                  if(currentFramePosition < length(rawCopX))
                    totalCom = totalCom+ rawCopX(round(currentFramePosition));  
                    currentFramePosition = currentFramePosition + singleCopFrameInterval;
                  end
              end
              % Divide the totalCop value by the # of frames to avg
              normalizedCopArray(gaitFrameCount) = totalCom/framesToAvg;
              gaitFrameCount = gaitFrameCount + 1;
          end
      end
      % Take the position on the force plate in mm, subtract heel contact
      % position from all values - gives the distance from heel in mm
      % Then divide by the length of the foot in mm, to give the percentage
      % distance in terms of foot length from heel, the COP is at
      function copArray = GetCopArrayAsPercentageFootLengthFromHeel(~, mmCopArray, ... 
              patientFootLengthInMm)
          % Initialize the copArray
          copArray = zeros(1, length(mmCopArray));
          
          % Smallest position in the array (furtherest back on the force)
          % is at heel strike or at position 1
          heelContactPosition = mmCopArray(1);
          
          for i=1:length(mmCopArray)
              distanceAlongFootFromInitialContact = mmCopArray(i) - heelContactPosition;
              copArray(i) = distanceAlongFootFromInitialContact/patientFootLengthInMm;
          end
      end
   end    
end