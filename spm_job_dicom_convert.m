
% Add SPM12 to the MATLAB path (update this path to your SPM12 installation)
%addpath('/Volumes/i230814/spm12');
addpath('E:\spm12');

% Navigate to directory where subject folders are located
%dataDir = '/Volumes/i230814/Nursing_MRI_data_test';
dataDir = 'E:\Nursing_MRI_data_test';

% Get a list of all subject folders in the data directory
subjects = dir(fullfile(dataDir, '*_session*'));
subjects = subjects([subjects.isdir]); % filter out anything that's not a directory

% Loop through each subject directory
for i = [43 45] %1:length(subjects) 118-125
    subjDir = fullfile(dataDir, subjects(i).name);
    
    % For anatomical and functional data
    %for dtype = {'anat', 'func_stroop_pre', 'func_stroop_post', 'func_mid_pre', 'func_mid_post'}
    for dtype = {'anat', 'func_stroop_v2_pre', 'func_stroop_v2_post', 'func_mid_v2_pre', 'func_mid_v2_post'}
    
        dicomDir = fullfile(subjDir, dtype{1});
        
        % Specify output directory for NIfTI files
        % Currently set to be same as DICOM directory
        niftiOutDir = dicomDir;
        
        % Configure job for DICOM to NIfTI conversion
        matlabbatch{1}.spm.util.import.dicom.data = cellstr(spm_select('FPList', dicomDir, '^(?!._).*\.dcm$'));
        matlabbatch{1}.spm.util.import.dicom.root = 'flat';
        matlabbatch{1}.spm.util.import.dicom.outdir = {niftiOutDir};
        matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
        
        % Run the job
        fprintf('Executing the batch for %s...\n', subjects(i).name);
        spm_jobman('initcfg');
        spm('defaults', 'FMRI');
        spm_jobman('run', matlabbatch);

        % Clear the batch for the next iteration
        clear matlabbatch;

    end
end
