function createGroupedBarPlot(xLabels, meanData, stdData, varargin)
    % Written by Yuen-Siang Ang
    % Institute of High Performance Computing, A*STAR 
    % Updated: 1 Aug 2024
    %
    % createGroupedBarPlot creates a grouped bar plot with error bars.
    %
    % Inputs:
    %   xLabels - Vector of x-axis labels (e.g., reward levels)
    %   meanData - Matrix of mean values (rows are groups, columns are x labels)
    %   stdData - Matrix of standard errors (rows are groups, columns are x labels)
    %
    % Optional Name-Value Pair Inputs:
    %   'GroupLabels' - Cell array of labels for the groups (default: {'Group 1', 'Group 2', ...})
    %   'TitleText' - Title of the plot (default: '')
    %   'YLabelText' - Label for the y-axis (default: '')
    %   'XLabelText' - Label for the x-axis (default: '')
    %   'LineWidth' - Line width for bars and error bars (default: 2)
    %   'FontSize' - Font size for the labels and title (default: 18)
    %
    % Example:
    %   xLabels = [2:2:8];
    %   meanData = [mean(subject_propHR_HC); mean(subject_propHR_MDD)];
    %   stdData = [std(subject_propHR_HC)/sqrt(40); std(subject_propHR_MDD)/sqrt(40)];
    %   createGroupedBarPlot(xLabels, meanData, stdData, 'GroupLabels', {'Controls', 'MDD'}, 'TitleText', 'Proportion of HR/HE chosen by Reward Level', 'YLabelText', 'Proportion of HR/HE chosen');

    % Default values
    defaultGroupLabels = arrayfun(@(x) sprintf('Group %d', x), 1:size(meanData, 1), 'UniformOutput', false);
    defaultTitleText = '';
    defaultYLabelText = '';
    defaultXLabelText = '';
    defaultLineWidth = 2;
    defaultFontSize = 18;

    % Parse optional name-value pair arguments
    p = inputParser;
    addParameter(p, 'GroupLabels', defaultGroupLabels, @iscell);
    addParameter(p, 'TitleText', defaultTitleText, @ischar);
    addParameter(p, 'YLabelText', defaultYLabelText, @ischar);
    addParameter(p, 'XLabelText', defaultXLabelText, @ischar);
    addParameter(p, 'LineWidth', defaultLineWidth, @isnumeric);
    addParameter(p, 'FontSize', defaultFontSize, @isnumeric);
    parse(p, varargin{:});

    groupLabels = p.Results.GroupLabels;
    titleText = p.Results.TitleText;
    yLabelText = p.Results.YLabelText;
    xLabelText = p.Results.XLabelText;
    lineWidth = p.Results.LineWidth;
    fontSize = p.Results.FontSize;

    % Grouped bar plot
    figure;
    b = bar(xLabels, meanData', 'grouped'); hold on;

    % Error bars
    ngroups = size(meanData, 2);
    nbars = size(meanData, 1);
    for i = 1:nbars
        x = b(i).XEndPoints;
        errorbar(x, meanData(i, :), stdData(i, :), 'k', 'linestyle', 'none', 'LineWidth', lineWidth);
    end

    % Formatting
    set(gca, 'FontSize', fontSize, 'LineWidth', lineWidth);
    for i = 1:nbars
        b(i).LineWidth = lineWidth;
    end
    ylabel(yLabelText);
    xlabel(xLabelText);
    legend(groupLabels, 'FontSize', fontSize);
    axis tight; 
    title(titleText, 'FontSize', fontSize);
end
