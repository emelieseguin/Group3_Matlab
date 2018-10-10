classdef AnthropometricModel
    properties
        errorMessage
        dimensionMap
        weightMap
    end
    methods
        function obj = AnthropometricDimensions(height, weight)
            % Here we can put restrictions on the height and weight, can
            % throw an error if they don't meet our restrictions
            if(height < 0 || weight < 0)
                obj.errorMessage = "You have entered invalid parameters.";
                error ('You have entered a height or weight less than 0.')
            end
           
            obj.dimensionMap = GetDimensions(height);
            obj.weightMap = GetWeight(weight);  
        end
        
        function map = GetDimensions(height)
            map = containers.Map();
            
            % Foot naming global variables 
            global footWidth footLength heelToAnkle;
            
            % Foot variable declaration
            map(footWidth) = height*0.055;
            map(footLength) = height*0.152;
            map(heelToAnkle) = height*0.039;
            
            % Leg naming global variables
            global rightShankLength leftShankLength thighLength;
            
            % Leg variable declaration
            map(rightShankLength) = height*0.246; 
            map(leftShankLength) = height*0.246;
            map(thighLength) = height*0.245;
            
            % COM naming global variables
            global pFootCOM pLegCOM pThighCOM pTotalLegCOM ;
            % Currently not being used: global pFootAndLegCOM pAbdomenCOM pPelvisCOM pAbdomenAndPelvisCOM;
    
            % COM variable declarations
            map(pFootCOM) = map(footLength)*0.5;
            map(pLegCOM) = map(rightShankLength)*0.433;
            map(pThighCOM) = map(thighLength)*0.433;
            map(pTotalLegCOM) = (map(thighLength) + map(rightShankLength))*0.161;
        end
        
        function map = GetWeight(weight)
            map = containers.Map();
            
            % Leg and Foot naming global variables
            global footSegmentWeight legSegmentWeight thighSegmentWeight; 
            global footAndLegSegmentWeight totalLegSegmentWeight;
            
            % Leg and Foot variable declaration
            map(footSegmentWeight) = weight*0.0145;
            map(legSegmentWeight) = weight*0.0465;
            map(thighSegmentWeight) = weight*0.1;
            map(footAndLegSegmentWeight) = weight*0.061;
            map(totalLegSegmentWeight) = weight*0.161;
            
            % Trunk naming global variables
            global abdomenSegmentWeight pelvisSegmentWeight;
            global abdomenAndPelvisSegmentWeight;
            
            % Trunk variable declaration
            map(abdomenSegmentWeight) = weight*0.139;
            map(pelvisSegmentWeight) = weight*0.142;
            map(abdomenAndPelvisSegmentWeight) = weight*0.281;
        end
    end    
end