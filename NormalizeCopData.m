classdef NormalizeCopData
   properties
       % Percentage in gait
       HealStrikePercentage
       ToeOffPercentage
       NormalizedCopArray
   end
   
   methods 
      function obj = NormalizeCopData(rawCopDataCsv, ...
          heelStrikePercentage, toeOffPercentage)
        
        obj.HealStrikePercentage = heelStrikePercentage;
        obj.ToeOffPercentage = toeOffPercentage;
     
        csvArray=csvread(rawCopDataCsv, 1);
        % Select the raw Com X data
        rawCopX = csvArray(:, 4);
        numberCopFrames = length(rawCopX);
        
        % Percent gait to average the COM values over
        numberGaitFrames = toeOffPercentage - heelStrikePercentage;
        %forceInLeftLegGaitTime = numberGaitFrames*timeSamplingRate;
        
        obj.NormalizedCopArray = obj.GetNormalizedCop(rawCopX, numberCopFrames, numberGaitFrames);
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
   end    
end