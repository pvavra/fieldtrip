function nmt_spm_write_deformationinv(mrifullpath)
% nmt_spm_write_deformationinv(mrifullpath)
%
% writes out the forward and inverse deformation fields
% associated with an MRI normalized with SPM8 (or SPM12 'OldNorm')
%
% input: full path of MRI in subject space (e.g. /home/nemo/data/Subject.nii)
% also requires: normalized MRI (wSubject.nii) generated by SPM
%                normalization transform file (Subject_SN.mat)


[mridir,mrifilebase,mrifileext] = fileparts(mrifullpath);
mrifile = [mrifilebase mrifileext];

snmat=fullfile(mridir,[mrifilebase '_sn.mat']);
yimg=fullfile(mridir,['y_' mrifile]);
norm_mrifullpath = fullfile(mridir,['w' mrifile]);

cwd=pwd;    % remember current working directory
cd(mridir); % because SPM wants to write files to 'pwd'
spm_jobman('initcfg');

%% generate deformation field (MNI -> individual MRI)
%  [this block not needed for MRI-MNI or MNI-MRI conversions
%   but preserved for possible future use]
%
% matlabbatch{1}.spm.util.defs.comp{1}.sn2def.matname = {snmat};
% matlabbatch{1}.spm.util.defs.comp{1}.sn2def.vox = NaN(1,3);
% matlabbatch{1}.spm.util.defs.comp{1}.sn2def.bb = NaN(2,3);
% matlabbatch{1}.spm.util.defs.ofname = mrifilebase;
% matlabbatch{1}.spm.util.defs.fnames = '';
% matlabbatch{1}.spm.util.defs.interp = 1;

%% generate inverse deformation field (individual MRI -> MNI)
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname = {snmat};
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.vox = NaN(1,3);
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.bb = NaN(2,3);
matlabbatch{1}.spm.util.defs.comp{1}.inv.space = {norm_mrifullpath};
matlabbatch{1}.spm.util.defs.ofname = ['i' mrifilebase];
matlabbatch{1}.spm.util.defs.fnames = '';
matlabbatch{1}.spm.util.defs.interp = 1;

spm_jobman('run',matlabbatch);

cd(cwd); % change back to original working directory