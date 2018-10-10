classdef GaitDataAngles
    properties
        % Angle columns stored from the excel
        time
        angle1
        angle2
        angle3
    end
    methods
        function obj = GaitDataAngles(csvFileName)
            % Make sure the file exists here
            if(exist(csvFileName, 'file') ~= 2)
                 error ('Gait data file cannot be found.')
            end

            csvArray=csvread(csvFileName, 1);
            % The second number is the column number
            obj.time = csvArray(:, 1);
            obj.angle1 = csvArray(:, 2);
            obj.angle2 = csvArray(:, 3);
            obj.angle3 = csvArray(:, 4);
            
            %plot(col1, col2)
        end
    end  
end