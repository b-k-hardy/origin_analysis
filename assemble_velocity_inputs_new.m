clear all; close all; clc
addpath(genpath(pwd));


% define constant parameters - aren't necessary for code, but good to have for checking
FOV=[90 132 234];
Origin=[-72.0, -52.0, -213.0];
Origin = Origin .* 1e-3;

% need it all in fucking separate groups
% all with dt, PixDim, res (including the time res)

res = [30 44 78 18];             % saying 'low' etc. because can't make variable names with '.' in them
PixDim = [3.0 3.0 3.0].*1e-3;       % Convert back to correct format. cheart-image.out works in the units of the mesh, so dx given in mm
dt = 60/1000;                       % convert step size into milliseconds

% loop through binary images
iter = 1;
for i = 5:60:1025

    % reset everything
    v{1}.im = zeros(res(1:3));
    v{1}.PixDim = PixDim;
    v{1}.res = res;
    v{1}.dt = dt;
    
    v{2}.im = zeros(res(1:3));
    v{2}.PixDim = PixDim;
    v{2}.res = res;
    v{2}.dt = dt;
    
    v{3}.im = zeros(res(1:3));
    v{3}.PixDim = PixDim;
    v{3}.res = res;
    v{3}.dt = dt;

    % open velocity data
    Vel1_name = ['image-out_3mm_0_b/images/images', num2str(i), '.m.Vel1.bin'];
    Vel2_name = ['image-out_3mm_0_b/images/images', num2str(i), '.m.Vel2.bin'];
    Vel3_name = ['image-out_3mm_0_b/images/images', num2str(i), '.m.Vel3.bin'];

    fid = fopen(Vel1_name);
    Vel1 = fread(fid,inf,'*double','n');
    fclose(fid);
    Vel1 = reshape(Vel1, res(1:3));

    fid = fopen(Vel2_name);
    Vel2 = fread(fid,inf,'*double','n');
    fclose(fid);
    Vel2 = reshape(Vel2, res(1:3));

    fid = fopen(Vel3_name);
    Vel3 = fread(fid,inf,'*double','n');
    fclose(fid);
    Vel3 = reshape(Vel3, res(1:3));

    % allocate and save, making sure to convert to meters per second
    v{1}.im = Vel1./1000;
    v{2}.im = Vel2./1000;
    v{3}.im = Vel3./1000;

    out_path = ['../UM13_vel_input/3.0mm/60ms/UM13_3.0mm_60ms_v_', num2str(iter), '.mat'];
    save(out_path, 'v', '-v7.3')

    disp(iter)
    iter = iter + 1;

end

% also make mask... NOTE: I MANUALLY CHANGED THIS SO THERE'S ONLY ONE MASK PER SPATIAL RES IN DIRECTORY STRUCTURE - MORE REPEATABILITY THIS WAY
%Mask_name = 'image-out_3mm_0_b/images/images5.m.Mask.bin';
%fid = fopen(Mask_name);
%mask = fread(fid,inf,'*double','n');
%fclose(fid);

%mask = reshape(mask, res(1:3));
%out_path = '3.0mm_0_box_vel_input/UM13_3.0mm_20ms_mask.mat';
%save(out_path, 'mask', '-v7.3')
