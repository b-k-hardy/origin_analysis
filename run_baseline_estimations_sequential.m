clear all; close all; clc
%addpath(genpath(pwd));
addpath(genpath('../vwerp'))

for i = 0:2

    opts.resample = 4;

    v_path = ['3.0mm_', num2str(i), '_vel_input/UM13_3.0mm_60ms_v'];
    mask_path = ['3.0mm_', num2str(i), '_vel_input/UM13_3.0mm_60ms_mask.mat'];
    inlet_path = ['3.0mm_', num2str(i), '_vel_input/UM13_3.0mm_60ms_inlet.mat'];
    outlet_path = ['3.0mm_', num2str(i), '_vel_input/UM13_3.0mm_60ms_outlet.mat'];

    out_path = ['3.0mm_', num2str(i), '_pressure'];
    out_name = 'UM13_3.0mm_60ms_P_STE';

    % Load data without 'popping' unknowns into workspace
    mask = load(mask_path, 'mask');
    mask = mask.mask;

    inlet = load(inlet_path, 'inlet');
    inlet = inlet.inlet;

    outlet = load(outlet_path, 'outlet');
    outlet = outlet.outlet;

    get_ste_pressure_estimate_sequential_baseline(v_path, out_path, out_name, mask, inlet, outlet, [], opts);

end