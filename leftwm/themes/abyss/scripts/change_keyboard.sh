#!/bin/sh

# This file let us to change the keyboard layout

layout_idx=$(cat keyboard_layouts | awk "NR==1 { print $1 }")
number_layouts=$(cat keyboard_layouts | awk "NR==2 { print NF }")

if [ $layout_idx -lt $number_layouts ]; then
    layout_idx=$((layout_idx + 1))
else
    layout_idx=1
fi

setxkbmap $(cat keyboard_layouts | awk -v i=$layout_idx "NR==2 { print $i }")

