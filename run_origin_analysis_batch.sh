#!/usr/bin/env bash

dx='2.0mm'

for i in {0..4}; do

    matlab -nodisplay -singleCompThread -batch "run_baseline_estimations_bash(${dx@Q}, ${i@Q})" & 

done
wait