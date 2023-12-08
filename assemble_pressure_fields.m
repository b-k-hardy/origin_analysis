clear all; close all; clc
addpath(genpath(pwd));


% define constant parameters - aren't necessary for code, but good to have for checking
FOV=[102 144 243];
Origin=[-73.0, -53.0, -212.0];
Origin = Origin .* 1e-3;

% need it all in fucking separate groups
% all with dt, PixDim, res (including the time res)

res = [136 192 324 17];             % saying 'low' etc. because can't make variable names with '.' in them
PixDim = [0.75 0.75 0.75].*1e-3;       % Convert back to correct format. cheart-image.out works in the units of the mesh, so dx given in mm
dt = 60/1000;                       % convert step size into milliseconds

P = zeros(res);

% loop through binary images
iter = 1;
for i = 35:60:995

    % reset everything -- it *would* be cool to keep pressure as a vWERP struct, but that makes interfacing with python fucking terrible
    % Conclusion: just make a mat file thingy
    % open pressure data
    Pres1_name = ['image-out_3mm_P2/images/images', num2str(i), '.m.Pres1.bin'];

    fid = fopen(Pres1_name);
    Pres1 = fread(fid,inf,'*double','n');
    fclose(fid);
    Pres1 = reshape(Pres1, res(1:3));

    P(:,:,:,iter) = Pres1*0.00750061683;

    disp(iter)
    iter = iter + 1;

end

% also make mask...
fid = fopen('image-out_3mm_P2/images/images35.m.Mask.bin');
mask = fread(fid,inf,'*double','n');
fclose(fid);
mask = reshape(mask, res(1:3));

save('3.0mm_2_pressure/UM13_0.75mm_60ms_P_CFD_unshifted.mat', 'P', 'dt', 'res', 'PixDim', 'mask', '-v7.3')
