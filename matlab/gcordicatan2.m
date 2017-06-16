function [res, minA, minB, maxA, maxB] = gcordicatan2(inB, inA, cordicLut)

LUT_SIZE = length(cordicLut);

if nargin < 3
    error('The cordiclut must be supplied along with ina and inb');
end

% ---------------------------------
%           Lut generation
% ---------------------------------

shiftLut = shiftlut_generation(LUT_SIZE);

% ---------------------------------
%           The Algorithm
% ---------------------------------

% Used to calculate needed bit size inside the component
[minA, maxA] = deal(inA);
[minB, maxB] = deal(inB);

sign = inB < 0; % equal to the msb of inb

if sign == 0
    atan = cordicLut(1);  % cordicLut(0)
    
    tempA = + inB;
    tempB = - inA;
else
    atan = -cordicLut(1); % cordicLut(0)
    
    tempA = - inB;
    tempB = + inA;
end

if inA == 0
    res = atan;
    return;
end

inA = tempA;
inB = tempB;


for i = 2:LUT_SIZE % 1 to LUT_SIZE-1
    
    sign = inB < 0; % equal to the msb of inb
    
    if sign == 0
        atan = atan + cordicLut(i);
        
        tempA = inA + bitsra(inB, shiftLut(i));
        tempB = inB - bitsra(inA, shiftLut(i));
    else
        atan = atan - cordicLut(i);
        
        tempA = inA - bitsra(inB, shiftLut(i));
        tempB = inB + bitsra(inA, shiftLut(i));
    end
    
    inA = tempA;
    inB = tempB;
    
    % Used only to check for the required number of bits
%     if inA > maxA
%         maxA = inA;
%     elseif inA < minA
%         minA = inA;
%     end
%     
%     if inB > maxB
%         maxB = inB;
%     elseif inB < minB
%         minB = inB;
%     end
end

res = atan;

end