function [ minimum, maximum, mean, variance ] = statistics( matrix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
matrix = matrix(isfinite(matrix));

minimum = min(matrix);
maximum = max(matrix);
mean = mean2(matrix);
variance = var(matrix);



end

