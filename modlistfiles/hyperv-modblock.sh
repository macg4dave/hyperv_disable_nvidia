#!/bin/bash

# Log file for error messages
LOG_FILE="/var/log/hyperv-detect.log"

# Path to the configuration file
SRC_CONF="/usr/local/share/modlistfiles/disable-nvidia-hyperv.conf"
DST_CONF="/etc/modprobe.d/disable-nvidia-hyperv.conf"

# Function to log errors
log_error() {
    echo "$(date): $1" >> $LOG_FILE
}

# Check if running inside Hyper-V
if [[ "$(systemd-detect-virt)" == "microsoft" ]]; then
    # Inside Hyper-V
    if [[ ! -f "$DST_CONF" ]]; then
        cp "$SRC_CONF" "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to copy $SRC_CONF to $DST_CONF"
        fi
    fi
else
    # Not in Hyper-V (native boot)
    if [[ -f "$DST_CONF" ]]; then
        rm "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to remove $DST_CONF"
        fi
    fi
fi
