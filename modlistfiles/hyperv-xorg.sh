#!/bin/bash

# Log file for error messages
LOG_FILE="/var/log/hyperv-detect.log"

# Source and destination paths
HYPERV_CONF="/usr/local/share/modlistfiles/hyperv/xorg.conf"
NVIDIA_CONF="/usr/local/share/modlistfiles/nvidia/xorg.conf"
DST_CONF="/etc/X11/xorg.conf"

# Function to log errors
log_error() {
    echo "$(date): $1" >> $LOG_FILE
}

# Check if running inside Hyper-V
if [[ "$(systemd-detect-virt)" == "microsoft" ]]; then
    # Inside Hyper-V: use the hyperv xorg.conf
    if [[ ! -f "$DST_CONF" ]]; then
        cp "$HYPERV_CONF" "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to copy $HYPERV_CONF to $DST_CONF"
        fi
    fi
else
    # Not in Hyper-V: use the nvidia xorg.conf
    if [[ ! -f "$DST_CONF" ]]; then
        cp "$NVIDIA_CONF" "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to copy $NVIDIA_CONF to $DST_CONF"
        fi
    else
        rm "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to remove $DST_CONF"
        fi
    fi
fi
