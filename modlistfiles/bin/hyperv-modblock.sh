#!/bin/bash
#hyperv-modblock.sh
# Log file for error messages
LOG_FILE="/var/log/hyperv-modblock.log"

# Path to the configuration file
SRC_CONF="/usr/local/share/modlistfiles/disable-nvidia-hyperv.conf"
DST_CONF="/etc/modprobe.d/disable-nvidia-hyperv.conf"

# Function to log errors
log_error() {
    echo "$(date): $1" >> $LOG_FILE
}

# Function to detect virtualization type
detect_virtualization() {
    local virt_type=$(systemd-detect-virt)
    echo "$virt_type"
}

# Main logic
VIRT_TYPE=$(detect_virtualization)

if [[ "$VIRT_TYPE" == "microsoft" ]]; then
    # Inside Hyper-V
    if [[ ! -f "$DST_CONF" ]]; then
        cp "$SRC_CONF" "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to copy $SRC_CONF to $DST_CONF"
        else
            echo "$(date): Successfully copied $SRC_CONF to $DST_CONF" >> $LOG_FILE
        fi
    fi
else
    # Not in Hyper-V or virtualization type is none (native boot)
    if [[ -f "$DST_CONF" ]]; then
        rm "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_error "Failed to remove $DST_CONF"
        else
            echo "$(date): Successfully removed $DST_CONF" >> $LOG_FILE
        fi
    else
        echo "$(date): $DST_CONF does not exist, no action needed" >> $LOG_FILE
    fi
fi
