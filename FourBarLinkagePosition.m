classdef FourBarLinkagePosition
    properties
        Link1X
        Link1Y
        Link2X
        Link2Y
        Link3X
        Link3Y
        Link4X
        Link4Y
        
        IntersectPointX
        IntersectPointY
    end
    
    methods
        function obj = FourBarLinkagePosition(personHeight, hipAngleZ, kneeAngleZ)
            
            % Convert angles to radians
            kneeAngleZRads = deg2rad(kneeAngleZ);
            hipAngleZRads = deg2rad(hipAngleZ);
            
            % Create all of the points when projected straight down
            x4 = 0;
            y4 = 0;
            
            ax = -0.01586685*personHeight;
            ay= -0.24707416*personHeight;
            
            bx = 0.0078837079*personHeight;
            by = -0.255416854*personHeight;
            
            cx = -0.010286*personHeight;
            cy = -0.232313*personHeight;
            
            dx = 0.010286*personHeight;
            dy = -0.24293*personHeight;
            
            cxRotated = (cx*cos(hipAngleZRads)) - (cy*sin(hipAngleZRads));
            cyRotated = (cy*cos(hipAngleZRads)) + (cx*sin(hipAngleZRads));
            
            dxRotated = (dx*cos(hipAngleZRads)) - (dy*sin(hipAngleZRads));
            dyRotated = (dy*cos(hipAngleZRads)) + (dx*sin(hipAngleZRads));
            
            % Find the relative Knee Rotation
            kneeAngleRelative = hipAngleZRads - kneeAngleZRads;
            
            % If either (Hip Extension, Knee Flexion) or (Hip Flexion, Knee Extension)
            if((hipAngleZRads < 0 && kneeAngleZRads > 0)||(hipAngleZRads > 0 && kneeAngleZRads < 0))
                kneeAngleRelative = hipAngleZRads + kneeAngleZRads;
            end
            
            % Create all rotated angles based on the hip and knee angle
            axRotated = (ax*cos(kneeAngleRelative)) - (ay*sin(kneeAngleRelative));
            ayRotated = (ay*cos(kneeAngleRelative)) + (ax*sin(kneeAngleRelative));
            
            bxRotated = (bx*cos(kneeAngleRelative)) - (by*sin(kneeAngleRelative));
            byRotated = (by*cos(kneeAngleRelative)) + (bx*sin(kneeAngleRelative));
            
            obj.Link1X = [axRotated bxRotated];
            obj.Link1Y = [ayRotated byRotated];
            obj.Link2X = [bxRotated cxRotated];
            obj.Link2Y = [byRotated cyRotated];
            obj.Link3X = [cxRotated dxRotated];
            obj.Link3Y = [cyRotated dyRotated];
            obj.Link4X = [dxRotated axRotated];
            obj.Link4Y = [dyRotated ayRotated];
        end
    end
end
