#!/usr/bin/env bash
#  ┳┓┏┓┏┳┓┏┳┓┏┓┳┓┓┏
#  ┣┫┣┫ ┃  ┃ ┣ ┣┫┗┫
#  ┻┛┛┗ ┻  ┻ ┗┛┛┗┗┛
#                  



BAT_PATH="/sys/class/power_supply/BAT1"

# Check if battery path exists
if [ ! -d "$BAT_PATH" ]; then
    echo "Battery not found"
    exit 1
fi

# Read battery percentage and status
battery_percentage=$(<"$BAT_PATH/capacity")
battery_status=$(<"$BAT_PATH/status")

# Define icons
battery_icons=(󰂃 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰁹)
charging_icon="󰂄"

# Determine icon index
icon_index=$((battery_percentage / 10))
(( battery_percentage == 100 )) && icon_index=9

# Choose icon
battery_icon=${battery_icons[$icon_index]}
[[ "$battery_status" == "Charging" ]] && battery_icon=$charging_icon

# Output
echo "$battery_percentage% $battery_icon"
