#!/usr/bin/env bash

# Helper functions to switch the AMD GPU power profile for VR.
# AMD GPUs downclock between frames by default, which causes judder
# and reprojection issues in VR. Switching to the "vr" power profile
# keeps clocks stable and dramatically improves frame timing.
#
# Usage:
#   vr-on    - set GPU to VR power profile (run before launching SteamVR)
#   vr-off   - reset GPU to default power profile

vr-on() {
    local card
    card=$(find /sys/class/drm -maxdepth 1 -name 'card[0-9]*' -not -name '*-*' | head -1)
    if [[ -z "$card" ]]; then
        echo "Error: no GPU found in /sys/class/drm" >&2
        return 1
    fi
    local pp_file="$card/device/pp_power_profile_mode"
    if [[ ! -f "$pp_file" ]]; then
        echo "Error: $pp_file not found - is this an AMD GPU?" >&2
        return 1
    fi
    echo "vr" | sudo tee "$pp_file" > /dev/null
    echo "GPU power profile set to VR ($(basename "$card"))"
}

vr-off() {
    local card
    card=$(find /sys/class/drm -maxdepth 1 -name 'card[0-9]*' -not -name '*-*' | head -1)
    if [[ -z "$card" ]]; then
        echo "Error: no GPU found in /sys/class/drm" >&2
        return 1
    fi
    local pp_file="$card/device/pp_power_profile_mode"
    if [[ ! -f "$pp_file" ]]; then
        echo "Error: $pp_file not found - is this an AMD GPU?" >&2
        return 1
    fi
    echo "bootup_default" | sudo tee "$pp_file" > /dev/null
    echo "GPU power profile reset to default ($(basename "$card"))"
}
