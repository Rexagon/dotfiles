#!/usr/bin/env bash

xset s off -dpms 

killall -q polybar

autorandr --change
feh --bg-fill ~/Pictures/wallpaper/town.png

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bar_left >>/tmp/polybar_left.log 2>&1 &
#polybar bar_right >>/tmp/polybar_right.log 2>&1 &

echo "Bars launched..."
