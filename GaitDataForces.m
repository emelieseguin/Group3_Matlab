classdef GaitDataForces
    properties
        % Force columns stored from the excel
        Time
        LGRFX
        LGRFY
        LGRFZ
    end
    methods
        function obj = GaitDataForces(csvFileName)
            % Make sure the file exists here
            if (exist(csvFileName, 'file') ~= 2)
                 error ('Gait data file cannot be found.')
            end

            csvArray=csvread(csvFileName, 1);
            % The second number is the column number
            obj.Time = csvArray(:, 1);
            obj.LGRFX = csvArray(:, 23);
            obj.LGRFY = csvArray(:, 24);
            obj.LGRFZ = csvArray(:, 25);
            
            %plot(col1, col2)
        end
    end  
end