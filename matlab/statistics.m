function [ maximum, mean, variance ] = statistics( matrix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
matrix = matrix(isfinite(matrix));

maximum = max(matrix);
mean = mean2(matrix);
variance = var(matrix);



end

