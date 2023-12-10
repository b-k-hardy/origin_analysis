clear all; close all; clc;

% generating error maps


for i = 0:4
    
    % Create paths
    gt_path = ['P_CFD/1.5mm_', num2str(i), '/UM13_0.75mm_60ms_P_CFD_shifted_', num2str(i), '.mat'];

    data_path = ['P_STE/1.5mm_', num2str(i), '/UM13_1.5mm_60ms_P_STE_', num2str(i), '.mat'];
    out_path = ['P_STE/1.5mm_', num2str(i), '/UM13_1.5mm_60ms_P_ERR_', num2str(i), '.mat'];

    % BE CAREFUL ABOUT DX HERE OKAY - actually make everything 0.75 mm
    % bc of resampling...
    % load data
    P_CFD = load(gt_path);
    CFD_mask = P_CFD.mask;
    P_CFD = P_CFD.P;

    P_STE = load(data_path, 'p_STE');
    P_STE = P_STE.p_STE{1};
    STE_mask = P_STE.mask;
    dx = P_STE.dx;
    P_STE = P_STE.im;

    % p mask generation assuming things are only EXACTLY 0 outside of
    % fluid domain - probably a safe assumption % FIXME: I have some new masks saved in STE mat files? I think???? could use that instead... as long as I'm not polluting environment by loading (probably am)
    %STE_mask = double(P_STE(:,:,:,4) ~= 0);
    err_mask = double((STE_mask.*CFD_mask) ~= 0);

    P_ERR = zeros(size(P_STE));
    % create error maps
    for t=1:size(P_STE,4)
        P_ERR(:,:,:,t) = abs(P_STE(:,:,:,t)-P_CFD(:,:,:,t)).*err_mask;
    end
    % TODO: add relative error to .mat files as well! same vti too

    % save output
    mask = err_mask;
    save(out_path, 'dx', 'P_ERR', 'mask', '-v7.3');

end