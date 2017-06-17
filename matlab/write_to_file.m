function write_to_file(lut, filename)

len = length(lut);

if isfi(lut)
    toprint = string(bin(lut));
else
    toprint = strings(len, 1);
    for i = 1:len
        toprint(i) = num2str(lut(i), '%f');
    end
end

fid = fopen(filename, 'w');
fprintf(fid, '\"%s\",', toprint(1:len-1));
fprintf(fid, '\"%s\"\n', toprint(len));
fclose(fid);

% dlmwrite(filename, toprint(2:length(blut),:), '-append') ;

end