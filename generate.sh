#!/bin/bash

model=$1
tab_side=$2
zero_cut_root_depth=$3
depth_step=$4
pin_1_from_shoulder=$5
total_depths=$6
zero_cut_number=$7

wide_mode=$8
pin_spacing=$9
total_pins=${10}

loop_end=$((total_depths-1))

cd `dirname $0`

if [[ "$wide_mode" != "wide" ]]; then
    for i in $(seq 1 $loop_end);
    do
        openscad \
            -D "tab_side=\"$tab_side\"" \
            -D "zero_cut_root_depth=$zero_cut_root_depth" \
            -D "depth_step=$depth_step" \
            -D "pin_1_from_shoulder=$pin_1_from_shoulder" \
            -D "total_depths=$total_depths" \
            -D "zero_cut_number=$zero_cut_number" \
            -D "depth_index=$i" \
            -o "generated/$model Cutter Guide - $i.stl" guide.scad
    done
else
    for i in $(seq 1 $loop_end);
    do
        openscad \
            -D "tab_side=\"$tab_side\"" \
            -D "zero_cut_root_depth=$zero_cut_root_depth" \
            -D "depth_step=$depth_step" \
            -D "pin_1_from_shoulder=$pin_1_from_shoulder" \
            -D "total_depths=$total_depths" \
            -D "zero_cut_number=$zero_cut_number" \
            -D "depth_index=$i" \
            -D "wide_mode=true" \
            -D "pin_spacing=$pin_spacing" \
            -D "total_pins=$total_pins" \
            -o "generated/$model Wide Cutter Guide - $i.stl" guide.scad
    done
fi
