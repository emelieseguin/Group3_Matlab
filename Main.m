function Main()
    SetAnthropometricNames(); % Run this to initialize all global naming variables
    
    model = AnthropometricDimensions(120, 50);
    disp(model);
end