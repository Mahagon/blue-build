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
    sudo /usr/libexec/set-vr-power-profile vr \
        && echo "GPU power profile set to VR"
}

vr-off() {
    sudo /usr/libexec/set-vr-power-profile default \
        && echo "GPU power profile reset to default"
}
