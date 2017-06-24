function atan = gcordicatan2(inB, inA, cordicLut)

LUT_SIZE = length(cordicLut);

if nargin < 3
    error('The cordiclut must be supplied along with ina and inb');
end

% ---------------------------------
%           The Algorithm
% ---------------------------------

if(inA == 0 && inB == 0)
    % This is used to format the output with the sime type of the cordicLut
    % elements
    atan = zeros(1, 1, 'like', cordicLut(1));
    return;
end

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
    return;
end

inA = tempA;
inB = tempB;

% It will be from 1 to LUT_SIZE-1 for a 0-based array
for i = 2:LUT_SIZE
    
    sign = inB < 0; % Equal to the MSB of inB
    
    if sign == 0
        atan = atan + cordicLut(i);
        
        % This will be i-1 in for a 0-based array
        tempA = inA + bitsra(inB, i-2);
        tempB = inB - bitsra(inA, i-2);
    else
        atan = atan - cordicLut(i);
        
        % This will be i-1 in for a 0-based array
        tempA = inA - bitsra(inB, i-2);
        tempB = inB + bitsra(inA, i-2);
    end
    
    inA = tempA;
    inB = tempB;
end

atan = atan;

end