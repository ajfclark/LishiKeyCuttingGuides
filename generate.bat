@echo off

set "openscad=C:\Program Files\OpenSCAD\openscad.exe"

set model=%1
set zero_cut_root_depth=%2
set depth_step=%3
set pin_1_from_shoulder=%4
set total_depths=%5
set zero_cut_number=%6

set wide_mode=%7
set pin_spacing=%8
set total_pins=%9

set /a loop_end=%5-1

cd %~dp0

if /I "%wide_mode%" EQU "wide" GOTO wide

:: Default mode.
for /L %%D IN (1,1,%loop_end%) DO (
    "%openscad%" ^
        -D "zero_cut_root_depth=%zero_cut_root_depth%" ^
        -D "depth_step=%depth_step%" ^
        -D "pin_1_from_shoulder=%pin_1_from_shoulder%" ^
        -D "total_depths=%total_depths%" ^
        -D "depth_index=%%D" ^
        -o "generated\%model% Cutter Guide - %%D.stl" guide.scad
)

goto :eof

:: Wide mode.
:wide
for /L %%D IN (1,1,%loop_end%) DO (
    "%openscad%" ^
        -D "zero_cut_root_depth=%zero_cut_root_depth%" ^
        -D "depth_step=%depth_step%" ^
        -D "pin_1_from_shoulder=%pin_1_from_shoulder%" ^
        -D "total_depths=%total_depths%" ^
        -D "depth_index=%%D" ^
        -D "wide_mode=true" ^
        -D "pin_spacing=%pin_spacing%" ^
        -D "total_pins=%total_pins%" ^
        -o "generated\%model% Wide Cutter Guide - %%D.stl" guide.scad
)
