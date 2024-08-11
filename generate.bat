@echo off

set "openscad=C:\Program Files\OpenSCAD\openscad.exe"

set model=%1
set tab_side=%2
set zero_cut_root_depth=%3
set depth_step=%4
set pin_1_from_shoulder=%5
set total_depths=%6
set zero_cut_number=%7

set wide_mode=%8
set pin_spacing=%9
set total_pins=%10

set /a loop_end=%total_depths-1

cd %~dp0

if /I "%wide_mode%" EQU "wide" GOTO wide

:: Default mode.
for /L %%D IN (1,1,%loop_end%) DO (
    "%openscad%" ^
        -D "tab_side=""%tab_side%""" ^
        -D "zero_cut_root_depth=%zero_cut_root_depth%" ^
        -D "depth_step=%depth_step%" ^
        -D "pin_1_from_shoulder=%pin_1_from_shoulder%" ^
        -D "total_depths=%total_depths%" ^
        -D "zero_cut_number=%zero_cut_number%" ^
        -D "depth_index=%%D" ^
        -o "generated\%model% Cutter Guide - %%D.stl" guide.scad
)

goto :eof

:: Wide mode.
:wide
for /L %%D IN (1,1,%loop_end%) DO (
    "%openscad%" ^
        -D "tab_side=""%tab_side%""" ^
        -D "zero_cut_root_depth=%zero_cut_root_depth%" ^
        -D "depth_step=%depth_step%" ^
        -D "pin_1_from_shoulder=%pin_1_from_shoulder%" ^
        -D "total_depths=%total_depths%" ^
        -D "zero_cut_number=%zero_cut_number%" ^
        -D "depth_index=%%D" ^
        -D "wide_mode=true" ^
        -D "pin_spacing=%pin_spacing%" ^
        -D "total_pins=%total_pins%" ^
        -o "generated\%model% Wide Cutter Guide - %%D.stl" guide.scad
)
