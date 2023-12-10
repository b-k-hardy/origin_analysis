#!/usr/bin/env bash


for i in {0..4}; do

    v_path="vel_input/1.5mm_$i/UM13_1.5mm_60ms_v"
    mask_path="vel_input/1.5mm_$i/UM13_1.5mm_mask.mat"
    inlet_path="vel_input/1.5mm_$i/UM13_1.5mm_inlet.mat"
    outlet_path="vel_input/1.5mm_$i/UM13_1.5mm_outlet.mat"

    out_path="P_STE/1.5mm_$i"
    out_name="UM13_1.5mm_60ms_P_STE_$i.mat"

    matlab -nodisplay -singleCompThread -r "addpath(genpath('../vwerp')); mask = load(${mask_path@Q}, 'mask'); mask = mask.mask; disp(size(mask));
    inlet = load(${inlet_path@Q}, 'inlet'); inlet = inlet.inlet; outlet = load(${outlet_path@Q}, 'outlet'); outlet = outlet.outlet;
    opts.resample=2; get_ste_pressure_estimate_sequential_baseline(${v_path@Q}, ${out_path@Q}, ${out_name@Q}, mask, inlet, outlet, [], opts); exit" & 

done
