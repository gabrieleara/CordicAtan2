function lut = cordiclut_generation(size, fixed, filename)

if nargin < 1 || size < 8
    size = 8;
end

if nargin < 2
    fixed = false;
end

lut = zeros(size, 1);

lut(1) = pi/2;

for i = 0:size-2
    lut(i+2) = atan(2^(-i));
end

% ---------------------------------
% Optional conversion to fixed type
% ---------------------------------

if fixed
    lut = fixed_integer(lut);
end

% ---------------------------------
%      Optional File Printing
% ---------------------------------

if nargin >= 3
    if fixed
        toprint = string(bin(lut));
    else
        toprint = strings(size, 1);
        for i = 1:size
            toprint(i) = num2str(lut(i), '%f');
        end
    end
    
    fid = fopen(filename, 'w');
    fprintf(fid, '%s,', toprint(1:size-1));
    fprintf(fid, '%s\n', toprint(size));
    fclose(fid);

    % dlmwrite(filename, toprint(2:length(blut),:), '-append') ;
end



end

