function surf3(matrix, range, cmap, reduced)
    if nargin < 2
        error('At least the matrix and the range must be supplied.');
    end
    
    figure
    
    if nargin < 3 || isempty(cmap)
        cmap = flipud(hot);
        cmap = cmap(23:50, :, :); 
    end
    
    if nargin < 4
        reduced = false;
    end
    
    if reduced
        l = length(range)-1;

        reduced_indexes_y = floor(0.5*l):l;
        reduced_indexes_x = floor(0.4955*l):ceil(0.5052*l);

        range_y = range(reduced_indexes_y);
        range_x = range(reduced_indexes_x);

        matrix = matrix(reduced_indexes_y, reduced_indexes_x);
    else
        range_y = range;
        range_x = range;
    end
    
    surf(range_x, range_y, matrix);
    %colormap(flipud(gray))
    colormap(cmap);
    shading(gca, 'interp');
    
    if reduced
        light('Position',[1 1 1],'Style','local')
    
        %light
        %lighting gouraud
        %lighting flat
        %lighting none

        material dull
    end

end