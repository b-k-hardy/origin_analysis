function run_baseline_estimations_bash(dx, i)

    addpath(genpath('../vwerp'))

    opts.resample = 4;

    v_path = ['vel_input/', dx, '_' i, '/UM13_', dx, '_60ms_v'];
    mask_path = ['vel_input/', dx, '_' i, '/UM13_', dx, '_mask.mat'];
    inlet_path = ['vel_input/', dx, '_' i, '/UM13_', dx, '_inlet.mat'];
    outlet_path = ['vel_input/', dx, '_' i, '/UM13_', dx, '_outlet.mat'];

    out_path = ['P_STE/', dx, '_' i'];
    out_name = ['UM13_', dx, '_60ms_P_STE_', i];

    % Load data without 'popping' unknowns into workspace
    mask = load(mask_path, 'mask');
    mask = mask.mask;

    inlet = load(inlet_path, 'inlet');
    inlet = inlet.inlet;

    outlet = load(outlet_path, 'outlet');
    outlet = outlet.outlet;

    get_ste_pressure_estimate_sequential_baseline(v_path, out_path, out_name, mask, inlet, outlet, [], opts);

end