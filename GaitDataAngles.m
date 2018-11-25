classdef GaitDataAngles
    properties
        % Angle columns stored from the excel
        Time
        %LPelvisAngleX
        %LPelvisAngleY
        %LPelvisAngleZ
        %LHipAngleX
        %LHipAngleY
        LHipAngleZ
        %LKneeAngleX
        %LKneeAngleY
        LKneeAngleZ
        %LAnkleAngleX
        %LAnkleAngleY
        LAnkleAngleZ
        %LFootAngleX       
        %LFootAngleY
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
            %obj.LPelvisAngleX = csvArray(:, 5);
            %obj.LPelvisAngleY = csvArray(:, 6);
            %obj.LPelvisAngleZ = csvArray(:, 7);
            %obj.LHipAngleX = csvArray(:, 11);
            %obj.LHipAngleY = csvArray(:, 12);
            obj.LHipAngleZ = csvArray(:, 13);           
            %obj.LKneeAngleX = csvArray(:, 17);           
            %obj.LKneeAngleY = csvArray(:, 18);           
            obj.LKneeAngleZ = csvArray(:, 19);           
            %obj.LAnkleAngleX = csvArray(:, 23);   
            %obj.LAnkleAngleY = csvArray(:, 24);   
            obj.LAnkleAngleZ = csvArray(:, 25);   
            %obj.LFootAngleX = csvArray(:, 29);   
            %obj.LFootAngleY = csvArray(:, 30);   
            obj.LFootAngleZ = csvArray(:, 31);   
            %plot(col1, col2)
        end
    end  
end