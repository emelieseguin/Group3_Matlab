classdef GaitDataForces
    properties
        % Force columns stored from the excel
        time
        xForces
        yForces
        zForces
    end
    methods
        function obj = GaitDataForces(csvFileName)
            % Make sure the file exists here
            if (exist(csvFileName, 'file') ~= 2)
                 error ('Gait data file cannot be found.')
            end

            csvArray=csvread(csvFileName, 1);
            % The second number is the column number
            obj.time = csvArray(:, 1);
            obj.xForces = csvArray(:, 2);
            obj.yForces = csvArray(:, 3);
            obj.zForces = csvArray(:, 4);
            
            %plot(col1, col2)
        end
    end  
end