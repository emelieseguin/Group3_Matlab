% Taken From ----- 

%% SFBM
function [ShearF, BendM] = ShearForceBendingMoment( varargin)
    %SFBM calculates the shear force and bending moment, plot the diagram and
    %computes the equations of the lines.
    global Name nc nd nm Cload Dload Mload Cloc Dloc Mloc Xload DistFfun ....
           DistPoly Xtick YtickSF YtickBM DeciPlace TypeF TypeM TypeD

    N         = nargin;
    NP        = 10000;
    DeciPlace = 2;
    Name      = varargin{1};
    Length    = varargin{2}(1);
    if numel(varargin{2}) == 1
        Supports = 0;
    else
        Supports  = varargin{2}(2:end);
    end
    Support1  = Supports(1);
    M         = 0; % sum moment about support 1.
    F         = 0; % sum vertical forces .
    nc        = numel(varargin{2}) - 1; nd    = 0; nm  = 0; 
    DistFfun  = {};  DistPoly = {};  Xload    = [0,varargin{2}];
    Cload     = {};  Dload    = {};  Mload    = {};
    Cloc      = {};  Dloc     = {};  Mloc     = {};
    Xtick     = [];  YtickSF  = [];  YtickBM  = [];
    TypeF     = [];  TypeM    = [];  TypeD    = [];
    for n = 3:N
        LoadCell = varargin{n};
        type     = LoadCell{1};
        load     = LoadCell{2};
        loc      = LoadCell{3};
        Xload    = union(Xload, loc);
        if strcmp(type,'CF')
            Mcl      = load*(loc - Support1);   
            M        = M + Mcl;
            Fcl      = load;   
            F        = F + Fcl;
            Cload    = [Cload;{load}];
            Cloc     = [Cloc;{loc}];
            TypeF    = [TypeF,'a'];
            nc       = nc + 1;
        elseif strcmp(type,'DF')
            if (numel(load) == 1) load = repmat(load,size(loc)); end
            p        = polyfit(loc - Support1, load, numel(loc) - 1); 
            DistPoly = [DistPoly, {p}];
            power    = numel(p) - 1: -1: 0;
            Ffun     = @(x) sum(p.*(x - Support1).^(power + 1)./(power + 1)); 
            DistFfun = [DistFfun, {Ffun}];
            Fbl      = Ffun(loc(end)) - Ffun(loc(1));
            F        = F + Fbl;
            Mfun     = @(x) sum(p.*(x - Support1).^(power + 2)./(power + 2)); 
            Mbl      = Mfun(loc(end)) - Mfun(loc(1));
            M        = M + Mbl;
            Dload    = [Dload;{load}];
            Dloc     = [Dloc;{loc}];
            TypeD    = [TypeD,'a'];
            nd       = nd + 1;
        elseif strcmp(type,'M')
            M        = M + load;
            Mload    = [Mload;{load}];
            Mloc     = [Mloc;{loc}];
            TypeM    = [TypeM,'a'];
            nm       = nm + 1;
        end
    end
    Xload = Round(Xload,3); % hold it to 3 digits not 2
    if numel(varargin{2}) == 1
        TypeD    = [TypeD,'r'];
        p        = -F/Length;
        power    = numel(p) - 1: -1: 0;
        Dload    = [Dload;{[p, p]}];
        Dloc     = [Dloc;{[0,Length]}]; 
        DistPoly = [DistPoly, {p}];
        Ffun     = @(x) sum(p.*(x - Support1).^(power + 1)./(power + 1)); 
        DistFfun = [DistFfun, {Ffun}];
        Xload    = [Xload,Length];
        nd       = nd + 1;
    elseif (numel(Supports) > 1)
        B        = -M/(Supports(2) - Support1); % Reaction B
        A        = -(F + B); % Reaction A
        Cload    = [{A};Cload;{B}];
        TypeF    = ['r',TypeF,'r'];
        Cloc     = [{Supports(1)};Cloc;{Supports(2)}];
    else
        if Support1 > 0
            A     = -F; % Reaction A
            Cload = [Cload;{A}];
            TypeF = [TypeF,'r'];
            Cloc  = [Cloc;{Support1}];
            Mload = [Mload;{-M}];
            TypeM = [TypeM,'r'];
            Mloc  = [Mloc;{Support1}];
        else
            A     = -F; % Reaction A
            Cload = [{A};Cload];
            TypeF = ['r',TypeF];
            Cloc  = [{Support1};Cloc];
            Mload = [{-M};Mload];
            TypeM = ['r',TypeM];
            Mloc  = [{Support1};Mloc];
        end
        nm    = nm + 1;
    end

        function [sf, bm] = SF(x)
            sf = 0; bm = 0;
            
            
            NewCcrossed = 0; NewMcrossed = 0;
            
            for i = 1:nc
                if x > Cloc{i}
                    if i > Ccrossed
                        Ccrossed = i;  NewCcrossed = 1;
                    end
                    sf = sf + Cload{i};
                end
            end

            for i = 1:nd
                loc = Dloc{i};
                if x > loc(1)
                    Ffun = DistFfun{i};
                    sf = sf + Ffun(min([x,loc(end)])) - Ffun(loc(1));
                end
            end

            for i = 1:nm
                if x > Mloc{i}
                    if i > Mcrossed
                        Mcrossed = i;  NewMcrossed = 1;
                    end
                    bm = bm - Mload{i};
                end
            end
        end

    dx       = Length/NP;
    X        = 0; base = 0;
    Ccrossed = 0; Mcrossed = 0;
    ShearF   = 0; 
    BendM    = 0;
    for n = 1:NP + 2
        xx = (n - 1)*dx;
        [sf,bm] = SF(xx);
        % handling discontinuities
        if(NewCcrossed || NewMcrossed)
            if (NewCcrossed && NewMcrossed)
                [sfc,bmc] = SF(Cloc{Ccrossed}); xc = Cloc{Ccrossed};
                sfc2 = sfc + Cload{Ccrossed}; bmc2 = bmc - Mload{Mcrossed};
            elseif (NewCcrossed && ~NewMcrossed)
                [sfc,bmc] = SF(Cloc{Ccrossed}); xc = Cloc{Ccrossed};
                sfc2 = sfc + Cload{Ccrossed}; bmc2 = bmc;
            elseif (~NewCcrossed && NewMcrossed)
                [sfc,bmc] = SF(Mloc{Mcrossed}); xc = Mloc{Mcrossed};
                sfc2 = sfc; bmc2 = bmc - Mload{Mcrossed};
            end
            X = [X; xc; xc]; Xtick = [Xtick; xc; xc]; 
            ShearF = [ShearF; sfc; sfc2]; YtickSF = [YtickSF; sfc; sfc2];
            BendM = [BendM; base + bmc; base + bmc2]; YtickBM = [YtickBM; base + bmc; base + bmc2];
        end
        if n > 1 && n < NP + 2 
            X = [X;xx];
            ShearF = [ShearF; sf];
            base = base + 0.5*dx*(sf + ShearF(end - 1));
            BendM = [BendM; bm + base];
        end
    end
    %SpecialPoints(X, ShearF, BendM);
    %Diagrams(X, ShearF, BendM)
end


%% SpecialPoints
function SpecialPoints(x,ysf,ybm)
    global Xload Xtick YtickSF YtickBM PSF PBM DistPoly DeciPlace

    YtickSF = [YtickSF; Interpolate(x,ysf,Xload)];
    YtickBM = [YtickBM; Interpolate(x,ybm,Xload)];

    N    = numel(x);
    sysf = sign(ysf);
    for n = 2:N
        diffsysf = sysf(n) - sysf(n - 1); 
        cond1 = diffsysf == 2 || diffsysf == -2;
        cond2 = sysf(n) == 0 && sysf(n - 1) ~= 0 ;
        if(cond1 || cond2)
            if( cond1 && ~cond2)
                ysfin = 0; 
                xin = interp1(ysf(n - 1:n), x(n - 1:n), ysfin);
                ybmin = interp1(ysf(n - 1:n), ybm(n - 1:n), ysfin);
            elseif (cond2 && ~cond1)
                ysfin = 0; xin = x(n); ybmin = ybm(n);
            end
            if(~ismember(xin,Xtick)) Xtick = [Xtick; xin]; end
            if(~ismember(ysfin,YtickSF)) YtickSF = [YtickSF; ysfin]; end
            if(~ismember(ybmin,YtickBM)) YtickBM = [YtickBM; ybmin]; end
        end
    end
    sybm = sign(ybm);
    for n = 2:N
        diffsybm = sybm(n) - sybm(n - 1); 
        cond1 = diffsybm == 2 || diffsybm == -2;
        cond2 = sybm(n) == 0 && sybm(n - 1) ~= 0 ;
        if(cond1 || cond2)
            if( cond1 && ~cond2)
                ybmin = 0; 
                xin = interp1(ybm(n - 1:n), x(n - 1:n), ybmin);
                ysfin = interp1(ybm(n - 1:n), ysf(n - 1:n), ybmin);
            elseif (cond2 && ~cond1)
                ybmin = 0; xin = x(n); ysfin = ysf(n);
            end
            if(~ismember(xin,Xtick)) Xtick = [Xtick; xin]; end
            if(~ismember(ysfin,YtickSF)) YtickSF = [YtickSF; ysfin]; end
            if(~ismember(ybmin,YtickBM)) YtickBM = [YtickBM; ybmin]; end
        end
    end
    Xtick = Round(union(Xload,Xtick),DeciPlace); YtickSF = unique(Round([YtickSF; ysf(end)],DeciPlace)); 
    YtickBM = unique(Round([YtickBM; ybm(end)],DeciPlace));

    PSF  = {};
    PBM  = {};
    for i = 2:numel(Xtick)
        xm = Xtick(i-1);
        xp = Xtick(i);
        I = 1:numel(x); I = I(x > xm); 
        X = x(I); I = I(X < xp); 
        if(~isempty(I))
            X = x(I); Ysf = ysf(I); Ybm = ybm(I);
            sfdegree = 0;
            n = Nboxed(0.5*(xm + xp));
            if ~isempty(n)
                sfdegree = numel(DistPoly{n}) - 1;
            end
            PSF   = [PSF,{Round(polyfit(X,Ysf,sfdegree + 1),2)}];
            PBM   = [PBM,{Round(polyfit(X,Ybm,sfdegree + 2),2)}];
        end
    end
end

function n = Nboxed(x)
    global Dloc 
    n = [];
    for i = 1:numel(Dloc)
        loc = Dloc{i};
        if loc(1) < x && x < loc(end)
            n = i; break;
        end
    end
end

%% Round
function x = Round(x,N)
    x = round(10^N*x)/10^N;
end

%% rotateXLabels
function hh = rotateXLabels( ax, angle, varargin )
%rotateXLabels: rotate any xticklabels
%
%   hh = rotateXLabels(ax,angle) rotates all XLabels on axes AX by an angle
%   ANGLE (in degrees). Handles to the resulting text objects are returned
%   in HH.
%
%   hh = rotateXLabels(ax,angle,param,value,...) also allows one or more
%   optional parameters to be specified. Possible parameters are:
%     'MaxStringLength'   The maximum length of label to show (default inf)
%
%   Examples:
%   >> bar( hsv(5)+0.05 )
%   >> days = {'Monday','Tuesday','Wednesday','Thursday','Friday'};
%   >> set( gca(), 'XTickLabel', days )
%   >> rotateXLabels( gca(), 45 )
%
%   See also: GCA, BAR

%   Copyright 2006-2013 The MathWorks Ltd.

error( nargchk( 2, inf, nargin ) );
if ~isnumeric( angle ) || ~isscalar( angle )
    error( 'RotateXLabels:BadAngle', 'Parameter ANGLE must be a scalar angle in degrees' )
end
angle = mod( angle, 360 );

% From R2014b, rotating labels is built-in using 'XTickLabelRotation'
if ~verLessThan('matlab','8.4.0')
    set(ax, 'XTickLabelRotation', angle)
    if nargout > 1
        hh = [];
    end
    return;
end

[maxStringLength] = parseInputs( varargin{:} );

% Get the existing label texts and clear them
[vals, labels] = findAndClearExistingLabels( ax, maxStringLength );

% Create the new label texts
h = createNewLabels( ax, vals, labels, angle );

% Reposition the axes itself to leave space for the new labels
repositionAxes( ax );

% If an X-label is present, move it too
repositionXLabel( ax );

% Store angle
setappdata( ax, 'RotateXLabelsAngle', angle );

% Only send outputs if requested
if nargout
    hh = h;
end

%-------------------------------------------------------------------------%
    function [maxStringLength] = parseInputs( varargin )
        % Parse optional inputs
        maxStringLength = inf;
        if nargin > 0
            params = varargin(1:2:end);
            values = varargin(2:2:end);
            if numel( params ) ~= numel( values )
                error( 'RotateXLabels:BadSyntax', 'Optional arguments must be specified as parameter-value pairs.' );
            end
            if any( ~cellfun( 'isclass', params, 'char' ) )
                error( 'RotateXLabels:BadSyntax', 'Optional argument names must be specified as strings.' );
            end
            for pp=1:numel( params )
                switch upper( params{pp} )
                    case 'MAXSTRINGLENGTH'
                        maxStringLength = values{pp};
                        
                    otherwise
                        error( 'RotateXLabels:BadParam', 'Optional parameter ''%s'' not recognised.', params{pp} );
                end
            end
        end
    end % parseInputs
%-------------------------------------------------------------------------%
    function [vals,labels] = findAndClearExistingLabels( ax, maxStringLength )
        % Get the current tick positions so that we can place our new labels
        vals = get( ax, 'XTick' );
        
        % Now determine the labels. We look first at for previously rotated labels
        % since if there are some the actual labels will be empty.
        ex = findall( ax, 'Tag', 'RotatedXTickLabel' );
        if isempty( ex )
            % Store the positions and labels
            labels = get( ax, 'XTickLabel' );
            if isempty( labels )
                % No labels!
                return
            else
                if ~iscell(labels)
                    labels = cellstr(labels);
                end
            end
            % Clear existing labels so that xlabel is in the right position
            set( ax, 'XTickLabel', {}, 'XTickMode', 'Manual' );
            setappdata( ax, 'OriginalXTickLabels', labels );
        else
            % Labels have already been rotated, so capture them
            labels = getappdata( ax, 'OriginalXTickLabels' );
            set(ex, 'DeleteFcn', []);
            delete(ex);
        end
        % Limit the length, if requested
        if isfinite( maxStringLength )
            for ll=1:numel( labels )
                if length( labels{ll} ) > maxStringLength
                    labels{ll} = labels{ll}(1:maxStringLength);
                end
            end
        end
        
    end % findAndClearExistingLabels
%-------------------------------------------------------------------------%
    function restoreDefaultLabels( ax )
        % Restore the default axis behavior
        removeListeners( ax );
        
        % Try to restore the tick marks and labels
        set( ax, 'XTickMode', 'auto', 'XTickLabelMode', 'auto' );
        rmappdata( ax, 'OriginalXTickLabels' );
        
        % Try to restore the axes position
        if isappdata( ax, 'OriginalAxesPosition' )
            set( ax, 'Position', getappdata( ax, 'OriginalAxesPosition' ) );
            rmappdata( ax, 'OriginalAxesPosition' );
        end
    end
%-------------------------------------------------------------------------%
    function textLabels = createNewLabels( ax, vals, labels, angle )
        % Work out the ticklabel positions
        zlim = get(ax,'ZLim');
        z = zlim(1);
        
        % We want to work in normalised coords, but this doesn't print
        % correctly. Instead we have to work in data units even though it
        % makes positioning hard.
        y = getYPositionToUse( ax );
        
        % Now create new text objects in similar positions.
        textLabels = -1*ones( numel( vals ), 1 );
        for ll=1:numel(vals)
            textLabels(ll) = text( ...
                'Units', 'Data', ...
                'Position', [vals(ll), y, z], ...
                'String', labels{ll}, ...
                'Parent', ax, ...
                'Clipping', 'off', ...
                'Rotation', angle, ...
                'Tag', 'RotatedXTickLabel', ...
                'UserData', vals(ll));
        end
        % So that we can respond to CLA and CLOSE, attach a delete
        % callback. We only attach it to one label to save massive numbers
        % of callbacks during axes shut-down.
        set(textLabels(end), 'DeleteFcn', @onTextLabelDeleted);
        
        % Now copy font properties into the texts
        updateFont();
        % Update the alignment of the text
        updateAlignment();
        
    end % createNewLabels

%-------------------------------------------------------------------------%
    function repositionAxes( ax )
        % Reposition the axes so that there's room for the labels
        % Note that we only do this if the OuterPosition is the thing being
        % controlled
        if ~strcmpi( get( ax, 'ActivePositionProperty' ), 'OuterPosition' )
            return;
        end
        
        % Work out the maximum height required for the labels
        labelHeight = getLabelHeight(ax);
        
        % Remove listeners while we mess around with things, otherwise we'll
        % trigger redraws recursively
        removeListeners( ax );
        
        % Change to normalized units for the position calculation
        oldUnits = get( ax, 'Units' );
        set( ax, 'Units', 'Normalized' );
        
        % Not sure why, but the extent seems to be proportional to the height of the axes.
        % Correct that now.
        set( ax, 'ActivePositionProperty', 'Position' );
        pos = get( ax, 'Position' );
        axesHeight = pos(4);
        % Make sure we don't adjust away the axes entirely!
        heightAdjust = min( (axesHeight*0.9), labelHeight*axesHeight );
        
        % Move the axes
        if isappdata( ax, 'OriginalAxesPosition' )
            pos = getappdata( ax, 'OriginalAxesPosition' );
        else
            pos = get(ax,'Position');
            setappdata( ax, 'OriginalAxesPosition', pos );
        end
        if strcmpi( get( ax, 'XAxisLocation' ), 'Bottom' )
            % Move it up and reduce the height
            set( ax, 'Position', pos+[0 heightAdjust 0 -heightAdjust] )
        else
            % Just reduce the height
            set( ax, 'Position', pos+[0 0 0 -heightAdjust] )
        end
        set( ax, 'Units', oldUnits );
        set( ax, 'ActivePositionProperty', 'OuterPosition' );
        
        % Make sure we find out if axes properties are changed
        addListeners( ax );
        
    end % repositionAxes

%-------------------------------------------------------------------------%
    function repositionXLabel( ax )
        % Try to work out where to put the xlabel
        removeListeners( ax );
        labelHeight = getLabelHeight(ax);
        
        % Use the new max extent to move the xlabel. We may also need to
        % move the title
        xlab = get(ax,'XLabel');
        titleh = get( ax, 'Title' );
        set( [xlab,titleh], 'Units', 'Normalized' );
        if strcmpi( get( ax, 'XAxisLocation' ), 'Top' )
            titleExtent = get( xlab, 'Extent' );
            set( xlab, 'Position', [0.5 1+labelHeight-titleExtent(4) 0] );
            set( titleh, 'Position', [0.5 1+labelHeight 0] );
        else
            set( xlab, 'Position', [0.5 -labelHeight 0] );
            set( titleh, 'Position', [0.5 1 0] );
        end
        addListeners( ax );
    end % repositionXLabel

%-------------------------------------------------------------------------%
    function height = getLabelHeight(ax)
        height = 0;
        textLabels = findall( ax, 'Tag', 'RotatedXTickLabel' );
        if isempty(textLabels)
            return;
        end
        oldUnits = get( textLabels(1), 'Units' );
        set( textLabels, 'Units', 'Normalized' );
        for ll=1:numel(vals)
            ext = get( textLabels(ll), 'Extent' );
            if ext(4) > height
                height = ext(4);
            end
        end
        set( textLabels, 'Units', oldUnits );
    end % getLabelExtent

%-------------------------------------------------------------------------%
    function updateFont()
        % Update the rotated text fonts when the axes font changes
        properties = {
            'FontName'
            'FontSize'
            'FontAngle'
            'FontWeight'
            'FontUnits'
            };
        propertyValues = get( ax, properties );
        textLabels = findall( ax, 'Tag', 'RotatedXTickLabel' );
        set( textLabels, properties, propertyValues );
    end % updateFont

    function updateAlignment()
        textLabels = findall( ax, 'Tag', 'RotatedXTickLabel' );
        angle = get( textLabels(1), 'Rotation' );
        % Depending on the angle, we may need to change the alignment. We change
        % alignments within 5 degrees of each 90 degree orientation.
        if strcmpi( get( ax, 'XAxisLocation' ), 'Top' )
            if 0 <= angle && angle < 5
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom' );
            elseif 5 <= angle && angle < 85
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Bottom' );
            elseif 85 <= angle && angle < 95
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle' );
            elseif 95 <= angle && angle < 175
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Top' );
            elseif 175 <= angle && angle < 185
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top' );
            elseif 185 <= angle && angle < 265
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Top' );
            elseif 265 <= angle && angle < 275
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle' );
            elseif 275 <= angle && angle < 355
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom' );
            else % 355-360
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom' );
            end
        else
            if 0 <= angle && angle < 5
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top' );
            elseif 5 <= angle && angle < 85
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Top' );
            elseif 85 <= angle && angle < 95
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle' );
            elseif 95 <= angle && angle < 175
                set( textLabels, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom' );
            elseif 175 <= angle && angle < 185
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom' );
            elseif 185 <= angle && angle < 265
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Bottom' );
            elseif 265 <= angle && angle < 275
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle' );
            elseif 275 <= angle && angle < 355
                set( textLabels, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Top' );
            else % 355-360
                set( textLabels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top' );
            end
        end
    end

%-------------------------------------------------------------------------%
    function onAxesFontChanged( ~, ~ )
        updateFont();
        repositionAxes( ax );
        repositionXLabel( ax );
    end % onAxesFontChanged

%-------------------------------------------------------------------------%
    function onAxesPositionChanged( ~, ~ )
        % We need to accept the new position, so remove the appdata before
        % redrawing
        if isappdata( ax, 'OriginalAxesPosition' )
            rmappdata( ax, 'OriginalAxesPosition' );
        end
        if isappdata( ax, 'OriginalXLabelPosition' )
            rmappdata( ax, 'OriginalXLabelPosition' );
        end
        repositionAxes( ax );
        repositionXLabel( ax );
    end % onAxesPositionChanged

%-------------------------------------------------------------------------%
    function onXAxisLocationChanged( ~, ~ )
        updateAlignment();
        repositionAxes( ax );
        repositionXLabel( ax );
    end % onXAxisLocationChanged

%-------------------------------------------------------------------------%
    function onAxesLimitsChanged( ~, ~ )
        % The limits have moved, so make sure the labels are still ok
        textLabels = findall( ax, 'Tag', 'RotatedXTickLabel' );
        xlim = get( ax, 'XLim' );
        pos = [0 getYPositionToUse( ax )];
        for tt=1:numel( textLabels )
            xval = get( textLabels(tt), 'UserData' );
            pos(1) = xval;
            % If the tick is off the edge, make it invisible
            if xval<xlim(1) || xval>xlim(2)
                set( textLabels(tt), 'Visible', 'off', 'Position', pos )
            elseif ~strcmpi( get( textLabels(tt), 'Visible' ), 'on' )
                set( textLabels(tt), 'Visible', 'on', 'Position', pos )
            else
                % Just set the position
                set( textLabels(tt), 'Position', pos );
            end
        end
        
        repositionXLabel( ax );
    end % onAxesPositionChanged

%-------------------------------------------------------------------------%
    function onTextLabelDeleted( ~, ~ )
        % The final text label has been deleted. This is likely from a
        % "cla" or "close" call, so we should remove all of our dirty
        % hacks.
        restoreDefaultLabels(ax);
    end

%-------------------------------------------------------------------------%
    function addListeners( ax )
        % Create listeners. We store the array of listeners in the axes to make
        % sure that they have the same life-span as the axes they are listening to.
        axh = handle( ax );
        listeners = [
            handle.listener( axh, findprop( axh, 'FontName' ), 'PropertyPostSet', @onAxesFontChanged )
            handle.listener( axh, findprop( axh, 'FontSize' ), 'PropertyPostSet', @onAxesFontChanged )
            handle.listener( axh, findprop( axh, 'FontWeight' ), 'PropertyPostSet', @onAxesFontChanged )
            handle.listener( axh, findprop( axh, 'FontAngle' ), 'PropertyPostSet', @onAxesFontChanged )
            handle.listener( axh, findprop( axh, 'FontUnits' ), 'PropertyPostSet', @onAxesFontChanged )
            handle.listener( axh, findprop( axh, 'OuterPosition' ), 'PropertyPostSet', @onAxesPositionChanged )
            handle.listener( axh, findprop( axh, 'XLim' ), 'PropertyPostSet', @onAxesLimitsChanged )
            handle.listener( axh, findprop( axh, 'YLim' ), 'PropertyPostSet', @onAxesLimitsChanged )
            handle.listener( axh, findprop( axh, 'XAxisLocation' ), 'PropertyPostSet', @onXAxisLocationChanged )
            ];
        setappdata( ax, 'RotateXLabelsListeners', listeners );
    end % addListeners

%-------------------------------------------------------------------------%
    function removeListeners( ax )
        % Rempove any property listeners whilst we are fiddling with the axes
        if isappdata( ax, 'RotateXLabelsListeners' )
            delete( getappdata( ax, 'RotateXLabelsListeners' ) );
            rmappdata( ax, 'RotateXLabelsListeners' );
        end
    end % removeListeners

%-------------------------------------------------------------------------%
    function y = getYPositionToUse( ax )
        % Use the direction and XAxisLocation properties to work out which
        % Y-value to draw the labels at.
        whichYLim = 1;
        % If YDir is reversed, switch where we position
        if strcmpi( get( ax, 'YDir' ), 'Reverse' )
            whichYLim = 3-whichYLim;
        end
        % If set to "top", then switch (again?)
        if strcmpi( get( ax, 'XAxisLocation' ), 'Top' )
            whichYLim = 3-whichYLim;
        end
        % Now get the value
        ylim = get( ax, 'YLim' );
        y = ylim(whichYLim);
    end % getYPositionToUse

end % EOF

%% MomentArrow.m
function h = MomentArrow(r,t1,t2,location, style, thickness)
    t      = linspace(t1,t2,50)';
    loc2   = [r*cos(t2),r*sin(t2)] + location;
    r2     = r/2;
    ts1    = t2+sign(t1-t2)*3*pi/4;
    ts2    = t2+sign(t1-t2)*5*pi/16;
    p1     = [r2*cos(ts1),r2*sin(ts1)] + loc2;
    p2     = [r2*cos(ts2),r2*sin(ts2)] + loc2;
    L      = [r*cos(t),r*sin(t)] + ones(50,1)*location;
             plot(L(:,1),L(:,2),style, 'linewidth',thickness);
             plot([L(50,1),p1(1)],[L(50,2),p1(2)],style, 'linewidth',thickness);
    h      = plot([L(50,1),p2(1)],[L(50,2),p2(2)],style, 'linewidth',thickness);
end

%% Interpolate
function y = Interpolate(X,Y,x)
    y = [];
    for n = 1:numel(x)-1
        xn = x(n);
        for i = 1:numel(X)
            xlow = X(i); xhigh = X(i + 1);
            if(xn >= xlow && xn <= xhigh) || (xn <= xlow && xn >= xhigh)
                yn = Y(i) + (xn - xlow)*(Y(i+1) - Y(i))/(xhigh - xlow);
                break;
            end
        end
        if (xlow ~= xhigh) y = [y;yn]; end
    end
end

%% Draw Arrow
function h = DrawArrow(x,y,arrowhead, varargin)
    ax = gca;
    holding = ishold(ax); 
    hold on;
    plot([x,x],y,varargin{:});
    Xhead = [x - arrowhead(1),x,x + arrowhead(1)];
    Yhead = [y(2) + sign(y(1))*arrowhead(2), y(2), y(2) + sign(y(1))*arrowhead(2)];
    h = plot(Xhead,Yhead,varargin{:});
    if(~holding) 
        hold off
    end
end

%% Diagrams
function Diagrams(x,sf,bm)
    close all
    clc
    global Name nc nd nm Cload Dload Mload Xload Cloc Dloc Mloc Xtick YtickSF ....
           YtickBM PSF PBM DeciPlace TypeF TypeM TypeD

    %% Display Information Processing
    Loads = [];
    for m = 1:numel(Cload)
        Loads = [Loads,Cload{m}];
    end
    for m = 1:numel(Dload)
        Loads = [Loads,Dload{m}];
    end

    % Factors needed for proper units so Matlab axis is not adjusted after creation
    Xfactor     = 10^floor(log10(max(abs(x))));
    SFfactor    = 10^floor(log10(max(abs(sf))));
    BMfactor    = 10^floor(log10(max(abs(bm))));
    maxforce    = max(Loads); minforce = min(Loads);

    % To adjust length of arrows and number of arrows
    lenperforce = 2/max([maxforce, -minforce]);
    numperlen   = 30/(max(x) - min(x));


    % Tick Points and Values
    Xtick   = unique(Round(Xtick,DeciPlace));
    YtickSF = unique(Round(YtickSF,DeciPlace));
    YtickBM = unique(Round(YtickBM,DeciPlace));
    XTICK   = {};
    YTICKSF = {};
    YTICKBM = {};
    XLOAD   = {};
    format  = ['%.',num2str(DeciPlace),'f'];
    for n = 1:numel(Xtick)
        XTICK{n} = num2str(Xtick(n)/Xfactor,format);
    end

    for n = 1:numel(Xload)
        XLOAD{n} = num2str(Xload(n)/Xfactor,format);
    end

    for n = 1:numel(YtickSF)
        YTICKSF{n} = num2str(YtickSF(n)/SFfactor,format);
    end

    for n = 1:numel(YtickBM)
        YTICKBM{n} = num2str(YtickBM(n)/BMfactor,format);
    end


    %% Creating Freebody Diagram and Equation Figure
    h1 = figure(1);
    set(h1,'units','normalized','outerposition',[0 0.05 0.6 0.95],'Color', [1.00 1.00 1.00])
    ax1 = axes('Position',[0 0 1 1],'Visible','off');
    ax2 = axes('Position',[0.05,0.50,0.90,0.45],'Visible','off');
    axes(ax2)
    t = 0.2; 
    fill([0,0,x(end),x(end),0],[-t/2,t/2,t/2,-t/2,-t/2],'b','linewidth',1.5)
    minx = min(x); maxx = max(x);
    Xmin = minx - 0.05*maxx;
    Xmax = maxx + 0.05*maxx;
    ymin = 0; ymax = 0;
    box off
    hold on
    PlotHandles = [];
    PlotNames   = {};

    Arrowhead = [(Xmax - Xmin)/150, (maxforce-minforce)/(75*SFfactor)];
    % Concentrated Forces
    nca = 0; ncr = 0;
    for n   = 1:nc
        xl  = Cloc{n};
        yl2 = sign(-Cload{n})*t/2;
        yl1 = -Cload{n}*lenperforce + yl2;
        ymin = min([ymin,yl1]); ymax = max([ymax,yl1]);
        text(xl,yl1+0.2*sign(yl1),[num2str(abs(Cload{n}),'%.2f'),'KN'], 'FontSize',12 ,'FontWeight','bold', 'HorizontalAlignment','center', 'interpreter','latex')
        if yl1 ~= yl2
            if TypeF(n) == 'a';
                if (nca == 0)
                    nca = 1;
                    hca = DrawArrow(xl,[yl1,yl2],Arrowhead,'linewidth',1.5,'color','k');
                    PlotHandles = [PlotHandles; hca]; PlotNames = [PlotNames;{'Applied Concentrated Force'}];
                else
                    DrawArrow(xl,[yl1,yl2],Arrowhead,'linewidth',1.5,'color','k');
                end
            else
                if (ncr == 0)
                    ncr = 1;
                    hcr = DrawArrow(xl,[yl1,yl2],Arrowhead,'linewidth',1.5,'color','k','linestyle','-.');
                    PlotHandles = [PlotHandles; hcr];  PlotNames = [PlotNames;{'Reacting Concentrated Force'}];
                else
                    DrawArrow(xl,[yl1,yl2],Arrowhead,'linewidth',1.5,'color','k','linestyle','-.');
                end
            end
        end
    end

    % Distributed Forces
    nda = 0; ndr = 0;
    for n  = 1:nd
        xl     = Dloc{n};
        num    = ceil(numperlen * (xl(end) - xl(1)));
        xdist  = linspace(xl(1),xl(end),num);
        ps     = polyfit(xl,-Dload{n}*lenperforce,numel(xl)-1);
        ydist1 = polyval(ps,xdist);
        IDzero = find(ydist1==0);    
        ydist2 = sign(ydist1)*t/2;
        if IDzero == 1
            ydist2(IDzero) = sign(ydist1(end))*t/2; 
        elseif IDzero == numel(ydist1)
            ydist2(IDzero) = sign(ydist1(1))*t/2;
        end
        ydist1 = ydist1 + ydist2;
        ymin   = min([ymin,min(ydist1)]); ymax = max([ymax,max(ydist1)]);

        text(xdist(1),ydist1(1) + 0.2*sign(ydist1(1)),[num2str(abs(Dload{n}(1)),'%.2f'),'KN/m'], 'FontSize',12 ,'FontWeight','bold', 'HorizontalAlignment','center', 'interpreter','latex')
        text(xdist(end),ydist1(end) + 0.2*sign(ydist1(end)),[num2str(abs(Dload{n}(end)),'%.2f'),'KN/m'], 'FontSize',12 ,'FontWeight','bold', 'HorizontalAlignment','center', 'interpreter','latex')

        for nn = 1:num
            if ydist2(nn) ~= ydist1(nn)
                if TypeD(n) == 'a';
                    if (nda == 0)
                        nda = 1;
                        hda = DrawArrow(xdist(nn),[ydist1(nn), ydist2(nn)],Arrowhead,'linewidth',1.5,'color','m');
                        PlotHandles = [PlotHandles; hda];  PlotNames = [PlotNames;{'Applied Distributed Force'}];
                    else
                        DrawArrow(xdist(nn),[ydist1(nn), ydist2(nn)],Arrowhead,'linewidth',1.5,'color','m');
                    end
                else
                    if (ndr == 0)
                        ndr = 1;
                        hdr = DrawArrow(xdist(nn),[ydist1(nn), ydist2(nn)],Arrowhead,'linewidth',1.5,'color','m','LineStyle','-.');
                        PlotHandles = [PlotHandles; hdr];  PlotNames = [PlotNames;{'Reacting Distributed Force'}];
                    else
                        DrawArrow(xdist(nn),[ydist1(nn), ydist2(nn)],Arrowhead, 'linewidth',1.5,'color','m','LineStyle','-.');
                    end
                end
            end
        end
        plot(xdist,ydist1,'m','linewidth',1.5)
    end

    % Moments
    nma = 0; nmr = 0;
    for n = 1:nm
        radius = 0.05*x(end);
        t      = sign(Mload{n})*[-3*pi/4,3*pi/4];
        t1     = t(1);
        t2     = t(2);
        if TypeM(n) == 'a';
            if(nma == 0)
                nma = 1;
                hma = MomentArrow(radius,t1,t2,[Mloc{n},0],'r', 1.5);
                PlotHandles = [PlotHandles; hma];  PlotNames = [PlotNames;{'Applied Torque'}];
            else
                MomentArrow(radius,t1,t2,[Mloc{n},0],'r', 1.5);

            end
            plot(Mloc{n},0,'or','markersize',5,'markerfacecolor','r')
        else
            if(nmr == 0)
                nmr = 1;
                hmr = MomentArrow(radius,t1,t2,[Mloc{n},0],'-.r', 1.5);
                PlotHandles = [PlotHandles; hmr];  PlotNames = [PlotNames;{'Reacting Torque'}];
            else
                MomentArrow(radius,t1,t2,[Mloc{n},0],'-.r', 1.5);
            end
            plot(Mloc{n},0,'ok','markersize',5,'markerfacecolor','r')
        end
        text(Mloc{n},0.3*sign(Mload{n}),[num2str(abs(Mload{n}),'%.2f'),'KN-m'], 'FontSize',12, 'FontWeight','bold', 'HorizontalAlignment','center', 'interpreter','latex')
    end

    Ymin = ymin - 0.5;
    Ymax = ymax + 2.5;
    axis([Xmin, Xmax,Ymin,Ymax])
    title('$Free~Body~Diagram$','FontSize',12, 'interpreter','latex')
    hold off
    box off
    set(ax2,'YTick',[]);
    Height = (Ymax - Ymin)/ax2.Position(4);
    VerticalOffset = Height/30;
    set(ax2,'XTickLabel',[]);
    for i = 1:length(Xload)
    %Create text box and set appropriate properties
         text(Xload(i), Ymin - VerticalOffset, ['$' XLOAD{i} '$'],...
             'HorizontalAlignment','Center','Rotation',90, 'FontSize',12, 'interpreter', 'latex');   
    end
    if Xfactor > 1
        xlabeltext = ['$x(',num2str(Xfactor),'m)$'];
    else
        xlabeltext = '$x(m)$';
    end
    VerticalOffset = Height/15;
    text(0.5*(Xmin + Xmax), Ymin - VerticalOffset, xlabeltext,...
             'HorizontalAlignment','Center','FontSize',12, 'FontWeight','bold','interpreter', 'latex');

    [xa0, ya0] = ConvertCoordinates(ax2, Xload,zeros(size(Xload)));
    [xb0, yb0] = ConvertCoordinates(ax2, Xload,repmat(Ymin,size(Xload)));

    for n = 1:numel(Xload)
        h4 = annotation('line',[xa0(n) xb0(n)],[ya0(n) yb0(n)],'Tag' , 'connect1');
        set(h4,'LineStyle','--'); set(h4,'Color','b'); 
    end 
    legend(PlotHandles,PlotNames, 'FontSize',10,'interpreter', 'latex')

    % Equations
    Range = {'$Range$'};
    Equa1 = {'$ Equations~of~Shear~Force: $'};
    Equa2 = {'$ Equations~of~Bending~Moment: $'};

    for n = 2:numel(Xtick)
        range = ['$',num2str(Xtick(n - 1)), '~to~',num2str(Xtick(n)),'$'];
        equa1 = ['$',makeequation(PSF{n - 1}),'$'];
        equa2 = ['$',makeequation(PBM{n - 1}),'$'];
        Range = [Range;{range}]; Equa1 = [Equa1;{equa1}]; Equa2 = [Equa2;{equa2}]; 
    end
    axes(ax1)
    text(0.05, 0.40, Range, 'VerticalAlignment', 'cap', 'FontSize', 12, 'interpreter', 'latex')
    text(0.20, 0.40, Equa1, 'VerticalAlignment', 'cap', 'FontSize', 12, 'interpreter', 'latex')
    text(0.50, 0.40, Equa2, 'VerticalAlignment', 'cap', 'FontSize', 12, 'interpreter', 'latex')

    f1 = getframe(gcf);

    %%
    h2 = figure(2);
    set(h2,'units','normalized','outerposition',[0.6 0.05 0.4 0.95],'Color', [0.98 0.98 0.98]);
    y = zeros(size(x)); % To be used for fill
    % Shear Force
    subplot(2,1,1);
    fill([x;flipud(x)],[y;flipud(sf)],'b','facealpha',0.15,'edgecolor','none');hold on
    plot(x,sf,'b','Linewidth',2);hold off
    refline(0,0);
    offset = 0.05*(max(sf) - min(sf));
    Vmin = min(sf) - offset;
    Vmax = max(sf) + offset;
    axis([Xmin, Xmax, Vmin, Vmax])
    % Latex Formatting
    ax3 = gca;
    set(ax3,'YTick',[]);
    set(ax3,'XTick',[]);
    Height = (Vmax - Vmin)/ax3.Position(4);
    VerticalOffset = Height/30;
    Width = (Xmax - Xmin)/ax3.Position(3);
    HorizontalOffset = Width/60;
    if SFfactor > 1
        ylabeltext = ['$V(',num2str(SFfactor),'KN)$'];
    else
        ylabeltext = '$V(KN)$';
    end
    for i = 1:length(Xtick)
    %Create text box and set appropriate properties
         text(Xtick(i), Vmin - VerticalOffset, ['$' XTICK{i} '$'],...
             'HorizontalAlignment','Center','Rotation',90, 'FontSize',8, 'interpreter', 'latex');   
    end

    for i = 1:length(YtickSF)
    %Create text box and set appropriate properties
         text(Xmin - HorizontalOffset, YtickSF(i), ['$' YTICKSF{i} '$'],...
             'HorizontalAlignment','Right', 'FontSize',8, 'interpreter', 'latex');   
    end
    VerticalOffset = Height/15;
    text(0.5*(Xmin + Xmax), Vmin - VerticalOffset, xlabeltext,...
             'HorizontalAlignment','Center','FontSize',12, 'FontWeight','bold','interpreter', 'latex');
    HorizontalOffset = Width/9;     
    text(Xmin - HorizontalOffset, 0.5*(Vmin + Vmax), ylabeltext,...
             'HorizontalAlignment','Center','VerticalAlignment','cap','Rotation',90, 'FontSize',12, 'interpreter', 'latex');

    title('$Shear~Force~Diagram$','FontSize',12, 'interpreter','latex')


    %%
    subplot(2,1,2);
    fill([x;flipud(x)],[y;flipud(bm)],'b','facealpha',0.15,'edgecolor','none');hold on
    plot(x,bm,'b','Linewidth',2);hold off
    refline(0,0)
    offset = 0.05*(max(bm) - min(bm));
    Mmin = min(bm) - offset;
    Mmax = max(bm) + offset;
    axis([Xmin, Xmax, Mmin, Mmax])
    % Latex Formatting
    ax4 = gca;
    set(ax4,'YTick',[]);
    set(ax4,'XTick',[]);
    Height = (Mmax - Mmin)/ax4.Position(4);
    VerticalOffset = Height/30;
    Width = (Xmax - Xmin)/ax4.Position(3);
    HorizontalOffset = Width/60;
    if BMfactor > 1
        ylabeltext = ['$M(',num2str(BMfactor),'KN-m)$'];
    else
        ylabeltext = '$M(KN-m)$';
    end
    for i = 1:length(Xtick)
    %Create text box and set appropriate properties
         text(Xtick(i), Mmin - VerticalOffset, ['$' XTICK{i} '$'],...
             'HorizontalAlignment','Center','Rotation',90, 'FontSize',8, 'interpreter', 'latex');   
    end

    for i = 1:length(YtickBM)
    %Create text box and set appropriate properties
         text(Xmin - HorizontalOffset, YtickBM(i), ['$' YTICKBM{i} '$'],...
             'HorizontalAlignment','Right', 'FontSize',8, 'interpreter', 'latex');   
    end
    VerticalOffset = Height/15;
    text(0.5*(Xmin + Xmax), Mmin - VerticalOffset, xlabeltext,...
             'HorizontalAlignment','Center','FontSize',12, 'FontWeight','bold','interpreter', 'latex');
    HorizontalOffset = Width/9;     
    text(Xmin - HorizontalOffset, 0.5*(Mmin + Mmax), ylabeltext,...
             'HorizontalAlignment','Center','VerticalAlignment','cap','Rotation',90, 'FontSize',12, 'interpreter', 'latex');
    title('$Bending~Monent~Diagram$','FontSize',12, 'interpreter','latex')

    %% annotation
    [xa1, ya1] = ConvertCoordinates(ax3, Xtick,repmat(Vmax,size(Xtick)));
    [xb1, yb1] = ConvertCoordinates(ax3, repmat(Xmin,size(YtickSF)),YtickSF);
    [xc1, yc1] = ConvertCoordinates(ax3, repmat(Xmax,size(YtickSF)),YtickSF);

    [xa2, ya2] = ConvertCoordinates(ax4, Xtick,repmat(Mmin,size(Xtick)));
    [xb2, yb2] = ConvertCoordinates(ax4, repmat(Xmin,size(YtickBM)),YtickBM);
    [xc2, yc2] = ConvertCoordinates(ax4, repmat(Xmax,size(YtickBM)),YtickBM);

    for n = 1:numel(Xtick)
        h4 = annotation('line',[xa1(n) xa2(n)],[ya1(n) ya2(n)],'Tag' , 'connect1');
        set(h4,'LineStyle','--'); set(h4,'Color','b'); 
    end

    for n = 1:numel(YtickSF)
        h4 = annotation('line',[xb1(n) xc1(n)],[yb1(n) yc1(n)],'Tag' , 'connect1');
        set(h4,'LineStyle','--'); set(h4,'Color','b'); 
    end

    for n = 1:numel(YtickBM)
        h4 = annotation('line',[xb2(n) xc2(n)],[yb2(n) yc2(n)],'Tag' , 'connect1');
        set(h4,'LineStyle','--'); set(h4,'Color','b'); 
    end

    f2 = getframe(gcf);
    F = [f1.cdata,f2.cdata];
    imwrite(F,[Name,'.png'])
end

function equation = makeequation(p)
    equation = [];
    for m = 1:numel(p)
        vv = p(m); power = numel(p) - m;
        avv = abs(vv);
        vvstr = [];
        if (avv ~= 0)
            if (avv == 1) 
                if(isempty(equation))
                    if(vv < 0)
                        if power == 0
                            vvstr = ' - 1';
                        else
                            vvstr = ' - ';
                        end
                    else
                        if power == 0
                            vvstr = ' 1';
                        end
                    end
                else
                    if(vv < 0)
                        vvstr = ' - ';
                    else
                        vvstr = ' + ';
                    end
                end
            else
                if(isempty(equation))
                    vvstr = num2str(vv);
                else
                    if(vv < 0)
                        vvstr = num2str(vv);
                    else
                        vvstr = [' + ',num2str(vv)];
                    end
                end
            end
            if (power > 0)
                if (power > 1) vvstr = [vvstr,'x^',num2str(power)];
                else vvstr = [vvstr,'x'];
                end
            end
        end
        equation = [equation, vvstr];
    end
    if(isempty(equation))
        equation = '0';
    end
end

%% Convert Coordinates
function [Xh,Yh] = ConvertCoordinates(axis, Xa,Ya)
    XLim     = axis.XLim; YLim = axis.YLim; 
    Position = axis.Position;
    Xh       = Position(1) + Position(3)*(Xa - XLim(1))/diff(XLim);
    Yh       = Position(2) + Position(4)*(Ya - YLim(1))/diff(YLim);
end
