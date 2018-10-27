classdef GaitDataForces
    properties
        % Force columns stored from the excel
        Time
        LGRFX
        LGRFY
        LGRFZ
        ToeOffPercentage
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
            
            obj.LGRFX = 50.0*obj.LGRFX;
            obj.LGRFY = 50.0*obj.LGRFY;
            obj.LGRFZ = 50.0*obj.LGRFZ;
            
            % Find when toe off is in the data
            obj.ToeOffPercentage = find(obj.LGRFX==0, 1, 'first');
        end
    end  
end