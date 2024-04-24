%-----------------------------------------------------------------------
% Job saved on 12-Apr-2024 10:08:08 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

% Define the main directory where the subject folders are located
mainDir = '/Volumes/i230814/Nursing_MRI_data_test';

% List all subject folders
subjects = dir(fullfile(mainDir, '*session*'));
subjects = subjects([subjects.isdir]); % filter out anything that's not a directory

for i = 21:29 %:length(subjects) 
    subjectDir = fullfile(mainDir, subjects(i).name);
    
    % Determine the correct func directory based on session suffix
    if contains(subjects(i).name, 'session1')
        funcDir = fullfile(subjectDir, 'func_stroop_post'); % session 1
    elseif contains(subjects(i).name, 'session2')
        funcDir = fullfile(subjectDir, 'func_stroop_v2_post'); % session 2
    end
    anatDir = fullfile(subjectDir, 'anat');
    
    anatFile = spm_select('FPList', anatDir, '^s.*\.nii$');
    funcFiles = spm_select('FPList', funcDir, '^f.*\.nii$');
    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Anat';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{anatFile}};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'func_stroop_pre';
    %%
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(funcFiles)}';
    %%
    matlabbatch{3}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Named File Selector: func_stroop_pre(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{4}.spm.temporal.st.scans{1}(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{4}.spm.temporal.st.nslices = 60;
    matlabbatch{4}.spm.temporal.st.tr = 0.719;
    matlabbatch{4}.spm.temporal.st.ta = 0.707016666666667;
    matlabbatch{4}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60];
    matlabbatch{4}.spm.temporal.st.refslice = 1;
    matlabbatch{4}.spm.temporal.st.prefix = 'a';
    matlabbatch{5}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{5}.spm.spatial.coreg.estwrite.source(1) = cfg_dep('Named File Selector: Anat(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{5}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    matlabbatch{6}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate & Reslice: Coregistered Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
    matlabbatch{6}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{6}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{6}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{6}.spm.spatial.preproc.tissue(1).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,1'};
    matlabbatch{6}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{6}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(2).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,2'};
    matlabbatch{6}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{6}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(3).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,3'};
    matlabbatch{6}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{6}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(4).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,4'};
    matlabbatch{6}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{6}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(5).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,5'};
    matlabbatch{6}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{6}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(6).tpm = {'/Volumes/i230814/spm12/tpm/TPM.nii,6'};
    matlabbatch{6}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{6}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{6}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{6}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{6}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{6}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{6}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{6}.spm.spatial.preproc.warp.write = [0 1];
    matlabbatch{6}.spm.spatial.preproc.warp.vox = NaN;
    matlabbatch{6}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                                  NaN NaN NaN];
    matlabbatch{7}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{7}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{7}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                              78 76 85];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{7}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{8}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{8}.spm.spatial.smooth.fwhm = [3 3 3];
    matlabbatch{8}.spm.spatial.smooth.dtype = 0;
    matlabbatch{8}.spm.spatial.smooth.im = 0;
    matlabbatch{8}.spm.spatial.smooth.prefix = 's';

    % Execute the batch
    fprintf('Executing the batch for %s...\n', subjects(i).name);
    spm_jobman('initcfg');
    spm_jobman('run', matlabbatch);
    fprintf('Completed preprocessing for %s\n', subjects(i).name);
    
    % Clear the batch for the next iteration
    clear matlabbatch;
end

fprintf('All preprocessing complete.\n');