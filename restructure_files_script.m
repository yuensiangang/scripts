% Define the source and target directories
sourceDir = 'MRI data';
targetDir = 'Nursing_MRI_data';

% Check if the target directory exists, if not, create it
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% List all subject folders in the source directory
subjects = dir(fullfile(sourceDir, 'STREAM*'));
subjects = subjects([subjects.isdir]); % Filter only directories

% Define session and condition mappings
sessions = {'session1', 'session2'};
conditions = {'Pre', 'Post', 'V2_Pre', 'V2_Post'};
functionalTests = {'stroop', 'mid'};

% Iterate over each subject to reorganize the data
for i = 16 %1:length(subjects)
    subjectName = subjects(i).name;
    fprintf('Processing subject: %s\n', subjectName);
    
    for j = 1:length(sessions)
        session = sessions{j};
        fprintf('  Session: %s\n', session);
        
        for k = 1:length(conditions)
            condition = conditions{k};
            
            % Skip mismatched session and condition pairs
            if contains(condition, 'V2') ~= strcmp(session, 'session2')
                continue;
            end
            
            fprintf('    Condition: %s\n', condition);
            % Prepare the new directory structure for this subject/session
            newSubDir = sprintf('%s_%s', subjectName, session);
            newSubDirPath = fullfile(targetDir, newSubDir);
            if ~exist(newSubDirPath, 'dir')
                mkdir(newSubDirPath);
            end
            
            % Handle anatomical files
            if contains(condition, 'Pre')
                anatDestPath = fullfile(newSubDirPath, 'anat');
                if ~exist(anatDestPath, 'dir')
                    mkdir(anatDestPath);
                end
                copyDICOMFiles(fullfile(sourceDir, subjectName, sprintf('%s_%s', subjectName, condition), 'scans'), anatDestPath, 't1_mprage');
            end
            
            % Handle functional files
            for test = functionalTests
                funcDestPath = fullfile(newSubDirPath, sprintf('func_%s_%s', test{1}, lower(condition)));
                if ~exist(funcDestPath, 'dir')
                    mkdir(funcDestPath);
                end
                copyDICOMFiles(fullfile(sourceDir, subjectName, sprintf('%s_%s', subjectName, condition), 'scans'), funcDestPath, strcat(test{1},'$')); % Updated to match only folders ending with the test name
            end
        end
    end
end

function copyDICOMFiles(srcPath, destPath, keyword)
% Finds folders containing a specific keyword (e.g., 't1_mprage', 'stroop', 'mid'),
% and copies their DICOM files to the destination path.

    dirs = dir(srcPath);
    for i = 1:length(dirs)
        dirName = dirs(i).name;
        if dirs(i).isdir && contains(dirName, keyword(1:end-1)) && (~endsWith(dirName, '_SBRef'))
            fprintf('      Copying DICOM files from: %s\n', dirName);
            srcDICOMPath = fullfile(srcPath, dirName, 'resources', 'DICOM');
            files = dir(fullfile(srcDICOMPath, '*.dcm'));
            for j = 1:length(files)
                copyfile(fullfile(files(j).folder, files(j).name), destPath);
            end
        end
    end
end
