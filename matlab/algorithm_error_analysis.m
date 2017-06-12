N_BIT = 12;
MAX_DIM = 2^N_BIT;
MAX_RANGE = 2^(N_BIT-1)-1;
MIN_RANGE = -2^(N_BIT-1);

INCREMENT = 1;

LUT_SIZE = 16;

[originalValues, algorithmValues, differences] = deal(zeros(floor(MAX_DIM / INCREMENT)));

cordicLut = cordiclut_generation(LUT_SIZE, false); % Uses double precition

range = MIN_RANGE:INCREMENT:MAX_RANGE;


i = 1;
for inA = range
    
    j = 1;
    for inB = range
        originalValues(i, j) = atan2(inB, inA);
        algorithmValues(i, j) = gcordicatan2(inB, inA, cordicLut);
        
        j = j+1;
    end
    i = i+1;
end

errorMagnitude = magnitude(originalValues - algorithmValues, originalValues);

myplot

















function val = magnitude(diff, val)
    val = abs(diff) ./ abs(val) * 100;
end