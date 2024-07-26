@echo off

set "openscad=C:\Program Files\OpenSCAD\openscad.exe"

set model=%1
set zero_cut_root_depth=%2
set depth_step=%3
set pin_1_from_shoulder=%4
set total_depths=%5

set /a loop_end=%5-1

cd %~dp0

for /L %%D IN (0,1,%loop_end%) DO (
    "%openscad%" ^
        -D "zero_cut_root_depth=%zero_cut_root_depth%" ^
        -D "depth_step=%depth_step%" ^
        -D "pin_1_from_shoulder=%pin_1_from_shoulder%" ^
        -D "total_depths=%total_depths%" ^
        -D "depth_index=%%D" ^
        -o "generated\%model% Cutter Guide - %%D.stl" guide.scad
)
