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
            global FootWidth FootLength;
            % Foot variable declaration
            map(FootWidth) = height*0.055;
            map(FootLength) = height*0.152;
            
        end
        
        function map = GetWeight(weight)
            map = containers.Map();
            
        end
    end    
end