classdef AnthropometricModel
    properties
        errorMessage
        dimensionMap
        weightMap
        comPercentageMap
        height
        weight
    end
    methods
        function obj = AnthropometricModel(height, weight)
            % Here we can put restrictions on the height and weight, can
            % throw an error if they don't meet our restrictions
            if(height <= 0.0 || weight <= 0.0)
                obj.errorMessage = "You have entered invalid parameters.";
                error ('You have entered a height or weight less than 0.')
            end

            obj.height = height;
            obj.weight = weight;
            obj.dimensionMap = obj.GetDimensions(height);
            obj.weightMap = obj.GetWeight(weight);  
            obj.comPercentageMap = obj.GetCom();
        end
        
        function dimensionMap = GetDimensions(~, height)
            dimensionMap = containers.Map();
            
            % Foot naming global variables 
            global footWidth footLength heelToAnkle;
            
            % Foot variable declaration
            dimensionMap(footWidth) = height*0.055;
            dimensionMap(footLength) = height*0.152;
            dimensionMap(heelToAnkle) = height*0.039;
            
            % Leg naming global variables
            global rightShankLength leftShankLength thighLength;
            
            % Leg variable declaration
            dimensionMap(rightShankLength) = height*0.246; 
            dimensionMap(leftShankLength) = height*0.246;
            dimensionMap(thighLength) = height*0.245;
        end
        
        function weightMap = GetWeight(~, weight)
            weightMap = containers.Map();
            
            % Leg and Foot naming global variables
            global footSegmentWeight legSegmentWeight thighSegmentWeight; 
            global footAndLegSegmentWeight totalLegSegmentWeight;
            
            % Leg and Foot variable declaration
            weightMap(footSegmentWeight) = weight*0.0145;
            weightMap(legSegmentWeight) = weight*0.0465;
            weightMap(thighSegmentWeight) = weight*0.1;
            weightMap(footAndLegSegmentWeight) = weight*0.061;
            weightMap(totalLegSegmentWeight) = weight*0.161;
            
            % Trunk naming global variables
            global abdomenSegmentWeight pelvisSegmentWeight;
            global abdomenAndPelvisSegmentWeight;
            
            % Trunk variable declaration
            weightMap(abdomenSegmentWeight) = weight*0.139;
            weightMap(pelvisSegmentWeight) = weight*0.142;
            weightMap(abdomenAndPelvisSegmentWeight) = weight*0.281;
        end
        
        function comMap = GetCom(~)
            comMap = containers.Map();
            
            % COM naming global variables
            global pFootCOM pShankCOM pThighCOM ;
            % Currently not being used: global pFootAndLegCOM pAbdomenCOM pPelvisCOM pAbdomenAndPelvisCOM;
        
            % COM variable declarations, all referenced from proximal
            comMap(pFootCOM) = 0.5;
            comMap(pShankCOM) = 0.433;
            comMap(pThighCOM) = 0.433;
            %comMap(pTotalLegCOM) = (dimensionMap(thighLength) + dimensionMap(rightShankLength))*0.161;
        end
    end    
end