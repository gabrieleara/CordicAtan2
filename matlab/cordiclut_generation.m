function lut = cordiclut_generation(size, fixed, bitlen)

% ---------------------------------
%        Arguments checking
% ---------------------------------

if nargin < 1 || size < 8
    size = 8;
end

if nargin < 2
    fixed = false;
end

% ---------------------------------
%        Lut creation
% ---------------------------------

lut = zeros(size, 1);

lut(1) = pi/2;

for i = 0:size-2
    lut(i+2) = atan(2^(-i));
end

% ---------------------------------
% Optional conversion to fixed type
% ---------------------------------

if fixed
    if nargin < 3
        lut = fixed_integer(lut, true);
    else
        lut = fixed_integer(lut, true, bitlen);
    end
end



end

