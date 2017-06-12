function [ val ] = fixed_integer(v, output)

% ---------------------------------
%    Output data type definition
% ---------------------------------

WORD_LENGTH      = 16;
FRACTION_LENGTH  = WORD_LENGTH-3;

FiOutType = numerictype('WordLength', WORD_LENGTH, ...
    'FractionLength', FRACTION_LENGTH);

FiOutMath = fimath('SumMode', 'SpecifyPrecision', ...
    'SumWordLength', WORD_LENGTH, ...
    'SumFractionLength', FRACTION_LENGTH);

% ---------------------------------
%        Arguments checking
% ---------------------------------

if nargin < 1
    error("Must supply at least the value");
end

if nargin < 2
    output = true;
end

% ---------------------------------
%            Conversion
% ---------------------------------

if output
    val = fi(v, FiOutType, FiOutMath);
else
    val = sfi(v);
end

end

