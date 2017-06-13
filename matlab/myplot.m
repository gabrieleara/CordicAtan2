function myplot(matrix, range)

figure
surf(range, range, matrix);
%surf(range, range, errorMagnitude, 'EdgeColor','none');
%mesh(range, range, errorMagnitude);
colormap(jet);
shading(gca, 'interp');

end