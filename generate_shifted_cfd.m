clear all; close all; clc;
addpath(genpath('../vwerp'))
% add this path to call the resampling functions

% generating CFD shifted. Outlet planes differ slightly between models, so I'm making a ground truth for each
% STE field (basically shifting by slightly different constants)

for i = 0:2

    outlet_path = ['3.0mm_', num2str(i), '_vel_input/UM13_3.0mm_60ms_outlet.mat'];
    outlet = load(outlet_path);
    outlet = outlet.outlet;

    % upsample and dilate outlet plane the way STE does
    outlet = upsample_image(outlet, 4);
    outlet = DilateMask(outlet);

    % load in the relevant pressure field
    P_CFD_path = ['3.0mm_', num2str(i), '_pressure/UM13_0.75mm_60ms_P_CFD_unshifted.mat'];
    P_CFD = load(P_CFD_path, 'P', 'mask', 'PixDim');
    P = P_CFD.P;
    mask = P_CFD.mask;
    dx = P_CFD.PixDim;
    clearvars P_CFD

    outlet = outlet.*mask;  % NEED TO .* with MASK SO THAT ONLY LOOKING AT VALUE INSIDE PRESSURE FIELD
    % otherwise offset will be down-weighted with zeros

    % need to do subtraction in a loop
    for k = 1:size(P,4)
        P_frame = P(:,:,:,k);
        offset = sum(P_frame(:) .* outlet(:)) / sum(outlet(:));
        P(:,:,:,k) = (P(:,:,:,k)-offset).*mask;
    end

    disp([num2str(i), ' completed'])
    
    out_path = ['3.0mm_', num2str(i), '_pressure/UM13_0.75mm_60ms_P_CFD_shifted.mat'];

    % save output
    save(out_path, 'dx', 'P', 'mask');

end