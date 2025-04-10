#!/usr/bin/env bash
#  ┳┓┏┓┏┳┓┓ ┏┏┓┳┓┓┏┓
#  ┃┃┣  ┃ ┃┃┃┃┃┣┫┃┫ 
#  ┛┗┗┛ ┻ ┗┻┛┗┛┛┗┛┗┛
#                   



CONFIG="$HOME/.config/hypr/hyprlock.conf"
show_ssid=$(grep -Po '^\$wifi-mode\s*=\s*\K\S+' "$CONFIG")

# Validate config result
if [ -z "$show_ssid" ]; then
    echo "Username not found in hyprlock.conf."
    exit 1
fi

# Check Wi-Fi is enabled
if [ "$(nmcli -t -f WIFI g)" != "enabled" ]; then
    echo "󰤮  Wi-Fi Off"
    exit 0
fi

# Get active Wi-Fi info
IFS=':' read -r active ssid signal_strength <<< "$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')"

# If not connected
if [ -z "$active" ]; then
    echo "󰤮  No Wi-Fi"
    exit 0
fi

# Clamp signal_strength between 0–100
signal_strength=$(( signal_strength < 0 ? 0 : (signal_strength > 100 ? 100 : signal_strength) ))

# Icon scale: 0–24: 0, 25–49: 1, etc.
wifi_icons=(󰤯 󰤟 󰤢 󰤥 󰤨)
icon_index=$(( signal_strength / 25 ))
wifi_icon="${wifi_icons[$icon_index]}"

# Output
if [ "$show_ssid" = true ]; then
    echo "$wifi_icon $ssid"
else
    echo "$wifi_icon Connected"
fi
