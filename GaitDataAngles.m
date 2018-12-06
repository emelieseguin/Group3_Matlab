classdef GaitDataAngles
    properties
        % Angle columns stored from the excel
        Time
        LHipAngleZ
        LKneeAngleZ
        LAnkleAngleZ
        LFootAngleZ
    end
    methods
        function obj = GaitDataAngles(csvFileName)
            % Make sure the file exists here
            if(exist(csvFileName, 'file') ~= 2)
                 error ('Gait data file cannot be found.')
            end

            csvArray=csvread(csvFileName, 1);
            % The second number is the column number
            obj.Time = csvArray(:, 1);
            obj.LHipAngleZ = csvArray(:, 13);                      
            obj.LKneeAngleZ = csvArray(:, 19);             
            obj.LAnkleAngleZ = csvArray(:, 25);    
            obj.LFootAngleZ = csvArray(:, 31);   
        end
    end  
end