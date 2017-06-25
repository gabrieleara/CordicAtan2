% we set the units of the measures used through the file
%
% [ inches | centimeters | normalized | points | {pixels} | characters ]
%set(gcf, 'Units', 'centimeters');
% we set the position and dimension of the figure ON THE SCREEN
%
% NOTE: measurement units refer to the previous settings!
%afFigurePosition = [1 1 20 5.5]; % [pos_x pos_y width_x width_y]
%set(gcf, 'Position', afFigurePosition); % [left bottom width height]
% we link the dimension of the figure ON THE PAPER in such a way that
% it is equal to the dimension on the screen
%
% ATTENTION: if PaperPositionMode is not 'auto' the saved file
% could have different dimensions from the one shown on the screen!
%set(gcf, 'PaperPositionMode', 'auto');
% in order to make matlab to do not "cut" latex-interpreted axes labels
%set(gca, 'Units','normalized',... %
%    'Position',[0.15 0.2 0.75 0.7]);

% xlimit = [-50 50];%[-100 100];
% ylimit = [0 2047];

% view([0 90]);

% general properties
iFontSize = 18;
strFontUnit = 'points'; % [{points} | normalized | inches | centimeters | pixels]
strFontName = 'Times'; % [Times | Courier | ] TODO complete the list
strFontWeight = 'normal'; % [light | {normal} | demi | bold]
strFontAngle = 'normal'; % [{normal} | italic | oblique] ps: only for axes
strInterpreter = 'latex'; % [{tex} | latex]
fLineWidth = 1.4; % width of the line of the axes

set(gca, ...
    ... 'Position', [1 1 20 10], ... TODO
    ... 'OuterPosition', [1 1 20 10], ... TODO
    ...
    'XGrid', 'on', ... [on | {off}]
    'YGrid', 'on', ... [on | {off}]
    'GridLineStyle', 'none', ... [- | -- | {:} | -. | none]
    'XMinorGrid', 'off' , ... [on | {off}]
    'YMinorGrid', 'off', ... [on | {off}]
    'MinorGridLineStyle', '-', ... [- | -- | {:} | -. | none]
    'Layer', 'top', ...
    ...
    ...'XTick', 0:10:100, ... ticks of x axis
    ...'YTick', 0:1:10, ... ticks of y axis
    ...'XTickLabel', {'-1','0','1'}, ...
    ...'YTickLabel', {'-1','0','1'}, ...
    'XMinorTick', 'off' , ... [on | {off}]
    'YMinorTick', 'off', ... [on | {off}]
    'TickDir', 'out', ... [{in} | out] inside or outside (for 2D)
    'TickLength', [.01 .01], ... length of the ticks
    ...
    'Box', 'on', ... [off | {on}] displays the box around the plot
    'XColor', [.1 .1 .1], ... color of x axis
    'YColor', [.1 .1 .1], ... color of y axis
    'XAxisLocation', 'bottom', ... where labels have to be printed [top | {bottom}]
    'YAxisLocation', 'left', ... where labels have to be printed [left | {right}]
    'XDir', 'normal', ... axis increasement direction [{normal} | reverse]
    'YDir', 'normal', ... axis increasement direction [{normal} | reverse]
    ...'XLim', xlimit, ... limits for the x-axis
    ...'YLim', ylimit, ... limits for the y-axis
    ...
    'FontName', strFontName, ... kind of fonts of labels
    'FontSize', iFontSize, ... size of fonts of labels
    'FontUnits', strFontUnit, ... units of the size of fonts
    'FontWeight', strFontWeight, ... weight of fonts of labels
    'FontAngle', strFontAngle, ... inclination of fonts of labels
    ...
    'LineWidth', fLineWidth); % width of the line of the axes

strXLabel = 'Input A';
strYLabel = 'Input B';
%
fXLabelRotation = 0.0;
%fYLabelRotation = 90.0;
fYLabelRotation = 0.0;
xlabel( strXLabel, ...
    'FontName', strFontName, ...
    'FontUnit', strFontUnit, ...
    'FontSize', iFontSize, ...
    'FontWeight', strFontWeight, ...
    'Interpreter', strInterpreter);
%
ylabel( strYLabel, ...
    'FontName', strFontName, ...
    'FontUnit', strFontUnit, ...
    'FontSize', iFontSize, ...
    'FontWeight', strFontWeight, ...
    'Interpreter', strInterpreter);
%
set(get(gca, 'XLabel'), 'Rotation', fXLabelRotation);
set(get(gca, 'YLabel'), 'Rotation', fYLabelRotation);

% in order to make matlab to do not "cut" latex-interpreted axes labels
set(gca, 'Units', 'normalized', ...
    'Position', [0.15 0.2 0.75 0.7]);

% here we select which output file extension we want
bPrintOnFile_Pdf = 0; % [0 (false) 1 (true)]
bPrintOnFile_Eps = 1; % [0 (false) 1 (true)]
% we select the file path
%
% NOTE: do NOT insert extensions!
%strFilePath = '../images/my_figure';
strFilePath = 'figure';
% we select the printing resolution
iResolution = 150;
% we select to crop or not the figure
bCropTheFigure = 1; % [0 (false) 1 (true)]
% ATTENTION: if PaperPositionMode is not 'auto' the saved file
% could have different dimensions from the one shown on the screen!
set(gcf, 'PaperPositionMode', 'auto');
% saving on file: requires some checks
if( bPrintOnFile_Pdf || bPrintOnFile_Eps )
    %
    % NOTE: if you want a .pdf with encapsulated fonts you need to save an
    % .eps and then convert it => it is always necessary to produce the .eps
    %
    % if we want to crop the figure we do it
    if( bCropTheFigure )
        print('-depsc2', sprintf('-r%d', iResolution), strcat(strFilePath, '.eps'));
    else
        print('-depsc2', '-loose', sprintf('-r%d', iResolution), strcat(strFilePath, '.eps'));
    end
    %
    % if we want the .pdf we produce it
    if( bPrintOnFile_Pdf )
        %
        % here we convert the .eps encapsulating the fonts
        system( ...
            sprintf( ...
            'epstopdf --gsopt=-dPDFSETTINGS=/prepress --outfile=%s.pdf %s.eps', ...
            strFilePath, ...
            strFilePath));
        %
    end
    %
    % if we do not want the .eps we remove it
    if( ~bPrintOnFile_Eps )
        delete(sprintf('%s.eps', strFilePath));
    end
    %
end % saving on file

