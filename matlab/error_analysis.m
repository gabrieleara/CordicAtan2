function [algerror, range, objective, algorithm, fixerror, fix] = ...
    error_analysis(nbit, lutsize, increment, fixed, algorithm)

% ---------------------------------
%        Arguments checking
% ---------------------------------

if nargin < 1 || isempty(nbit)
    nbit = 12;
end

if nargin < 2 || isempty(lutsize)
    lutsize = 16;
end

% Use 1 for best resolution. Warning: takes A LOT MORE even for algorithmic
% error calculation only
if nargin < 3 || isempty(increment)
    increment = 16;
end

if nargin < 4 || isempty(fixed)
    fixed = false;
end

% ---------------------------------
%       Constants definition
% ---------------------------------

MAX_DIM = 2^nbit;
MAX_RANGE = 2^(nbit-1)-1;
MIN_RANGE = -2^(nbit-1);

% Arrays and matrices initialization
[objective, algerror, fixerror, fix] = deal(zeros(floor(MAX_DIM / increment)));

cordicLut = cordiclut_generation(lutsize, false);

range = MIN_RANGE:increment:MAX_RANGE;

errormsg = 'Computation aborted by the user.';
wbar = waitbar(0);

if nargin < 5 || isempty(algorithm)
    algorithm = objective;
    
    % Need to calculate the objective and algorithmic tables, otherwise I
    % calculate only the fixed one

    fprintf('Starting calculation of the objective and algorithmic tables...\n');

    % Diplaying a progress bar
    [oldprogress, progress] = deal(0);
    msg = 'Calculation of the objective and algorithmic tables...';
    waitbar(progress, wbar, msg);

    i = 1;
    for inA = range
        j = 1;

        for inB = range

            % Values that need to be calculated
            objective(i, j) = atan2(inB, inA);

            % Values obtained using the CORDIC algorithm; since calculation is
            % performed using doubles we assume that the error in performing
            % these actions is only due to algorithmic error
            algorithm(i, j) = gcordicatan2(inB, inA, cordicLut);

            j = j+1;

            if not(ishandle(wbar))
                error(errormsg);
            end
        end

        i = i+1;

        % Progress bar update   
        progress = i / length(range);

        if progress - oldprogress > 0.015 % 1.5 percent
            waitbar(progress, wbar, msg);
            oldprogress = progress;
        end

    end

    if not(ishandle(wbar))
        error(errormsg);
    end

    waitbar(1, wbar, 'Algorithmic error table calculation...');
    fprintf('Calculation of the objective and algorithmic tables terminated.\n');

    % Actual calculation of the relative algorithmic error
    algerror = magnitude(objective - algorithm, objective);

fprintf('Algorithmic error table calculation terminated.\n');
end

if fixed
    
    fprintf('Starting calculation of the fixed point table...\n');
    
    if not(ishandle(wbar))
        error(errormsg);
    end

    % Diplaying a progress bar
    [oldprogress, progress] = deal(0);
    msg = 'Calculation of the fixed point table...';
    waitbar(progress, wbar, msg);

    % Let's move to fixed point numbers
    fixrange = fixed_integer(range, false, nbit);
    cordicLut = cordiclut_generation(lutsize, true, nbit);
    
    fix = fixed_integer(fix, true, nbit);
    
    i = 1;
    for inA = fixrange

        j = 1;
        for inB = fixrange
            
            % Since inputs are all fixed integers type, computation is done
            % using fixed integers arithmetic
            
            % NOTICE: this takes A LOT and A LOT and A LOT and A LOT more
            % than the computation on doubles, make sure you do this only
            % when connected to power supply and you have enough time.
            
            % You can abort any time the computation by closing the window
            % displaying the progress bar; notice that to abort computation
            % a little time may be needed, the computation of this function
            % has to be terminated first. If you want to abort the
            % computation badly just do a ^C.
            temp = gcordicatan2(inB, inA, cordicLut);
            
            fix(i, j) = temp;

            j = j+1;
            
            if not(ishandle(wbar))
                error(errormsg);
            end
        end
        i = i+1;
        
        % Progress bar update   
        progress = i / length(range);

        if progress - oldprogress > 0.015 % 1.5 percent
            waitbar(progress, wbar, msg);
            oldprogress = progress;
        end 
    end
    
    if not(ishandle(wbar))
        error(errormsg);
    end
    
    waitbar(1, wbar, msg, 'Quantization error table calculation...');
    fprintf('Calculation of the fixed point table terminated.\n');

    % The quantization error is calculated as relative error to the
    % algorithmic value produced before
    fixerror = magnitude(algorithm - double(fix), algorithm);

    fprintf('Quantization error table calculation terminated.\n');

end

close(wbar);

end

function val = magnitude(diff, val)
    val = abs(diff) ./ abs(val) * 100;
    % val(isinf(val)) = 0;
    val(val > 1000) = 0;
end