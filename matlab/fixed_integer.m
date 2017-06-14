function [ val ] = fixed_integer(v, out, len)

% ---------------------------------
%        Arguments checking
% ---------------------------------

if nargin < 1
    error('Must supply at least the value');
elseif nargin < 2
    out = true;
    len = 12;
elseif nargin < 3
    len = 12;
end

if out
    % ---------------------------------
    %    Output data type definition
    % ---------------------------------

    WORD_LENGTH      = len;
    FRACTION_LENGTH  = WORD_LENGTH-3; % 1 bit for the sign and two bits for
                                      % the integer part
else
    % ---------------------------------
    %    Input data type definition
    % ---------------------------------
    
    WORD_LENGTH      = len+2;         % Needed to avoid overflow,
    FRACTION_LENGTH  = 0;             % numbers are treated as integers
end

% Fixed Point arithmetic, cannot resize the variables
FiType = numerictype('WordLength', WORD_LENGTH, ...
    'FractionLength', FRACTION_LENGTH);

FiMath = fimath('SumMode', 'SpecifyPrecision', ...
    'SumWordLength', WORD_LENGTH, ...
    'SumFractionLength', FRACTION_LENGTH);

% Conversion
val = fi(v, FiType, FiMath);

end

