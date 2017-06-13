function lut = shiftlut_generation(size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lut = zeros(size, 1);

%lut(1) = 0;

for i = 2:size
    lut(i) = i-2;
end

end

