% Define the directory where the subject folders are located
mainDir = 'E:\Nursing_MRI_data_test';

% List all subject folders (e.g., 101_session1, 101_session2, etc.)
subjects = dir(fullfile(mainDir, '*session*'));
subjects = subjects([subjects.isdir]); % filter to keep only directories

% Prepare a figure to hold all subplots
figure;

% Loop through each subject
for i = 1:45 %length(subjects)
    % Subject-specific directory paths
    subjectDir = fullfile(mainDir, subjects(i).name);

    % Determine the correct func directory based on session suffix
    if contains(subjects(i).name, 'session1')
        funcDir = fullfile(subjectDir, 'func_stroop_pre');
    elseif contains(subjects(i).name, 'session2')
        funcDir = fullfile(subjectDir, 'func_stroop_v2_pre');
    else
        warning('Unknown session type for %s', subjects(i).name);
        continue;
    end
    
    % Select the rp_*.txt file containing the motion parameters
    rpFile = dir(fullfile(funcDir, 'rp_*.txt'));
    if isempty(rpFile)
        warning('No rp_ file found for %s', subjects(i).name);
        continue;
    end
    rpFilePath = fullfile(funcDir, rpFile.name);
    
    % Read the motion parameters from the file
    motionParams = load(rpFilePath);
    
    % Plot the motion parameters
    %subplot(ceil(sqrt(length(subjects))), ceil(sqrt(length(subjects))), i);
    subplot(5,9,i);
    plot(motionParams);
    hTitle = title(sprintf('%s', subjects(i).name), 'Interpreter', 'none');
    set(hTitle, 'FontSize', 8);  % Set title font size to 8
    axis square;
    ylim([-3 3]);
    hold on;

    %xlabel('Scan number');
    %ylabel('Motion parameters');
    if i==45, legend({'X translation', 'Y translation', 'Z translation', 'X rotation', 'Y rotation', 'Z rotation'}, 'Location', 'bestoutside');, end
end

% Improve the layout
%sgtitle('Motion Parameters for Each Subject');
