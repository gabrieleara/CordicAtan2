function [inA, inB, expected_output] = generate_testbench(n)

    BIT_LENGTH = 12;
    LUT_SIZE = 11;
    
    lut = cordiclut_generation(LUT_SIZE, true, BIT_LENGTH);
    
    range = 1:n;
    
    inA = randperm(4096) - 2049;
    test_inA = fixed_integer(inA(range), false, BIT_LENGTH);
    inA = fixed_integer(inA(range)', false, BIT_LENGTH, false);
    
    inB = randperm(4096) - 2049;
    test_inB = fixed_integer(inB(range), false, BIT_LENGTH);
    inB = fixed_integer(inB(range)', false, BIT_LENGTH, false);
    
    expected_output = fixed_integer(zeros(n, 1), true, BIT_LENGTH);
    
    for i = range
        expected_output(i) = gcordicatan2(test_inB(i), test_inA(i), lut);
    end

end