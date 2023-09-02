#!/bin/bash
#
xrandr --newmode "2560x1440R1"  241.50  2560 2608 2640 2720  1440 1443 1448 1481 +hsync -vsync
xrandr --addmode HDMI-1 "2560x1440R1"
xrandr --output HDMI-1 --mode "2560x1440R1"
xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 2560x1440R1 --pos 1080x0 --rotate normal --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate left
