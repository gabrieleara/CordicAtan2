figure
surf(range, range, errorMagnitude);
%surf(range, range, errorMagnitude, 'EdgeColor','none');
%mesh(range, range, errorMagnitude);
colormap(jet);
shading(gca, 'interp');