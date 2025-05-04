#!/usr/bin/env sh

# this script is to be used in conjuction with .yabairc

layout_type=$(yabai -m query --spaces --space | jq -r '.type')

if [ "$layout_type" = "bsp" ]; then
    yabai -m config mouse_follows_focus on
    yabai -m config focus_follows_mouse autoraise
else
    yabai -m config mouse_follows_focus off
    yabai -m config focus_follows_mouse off
fi

