#!/bin/bash
# hyperv-modblock.sh
# Source the error logging script
source /usr/local/share/modlistfiles/bin/error-logging/error-logging.sh

# Set log file and log level for this script
log_file="/var/log/hyperv-modblock.log"
log_verbose=1  # Set to log ERROR messages

# Path to the configuration file
SRC_CONF="/usr/local/share/modlistfiles/disable-nvidia-hyperv.conf"
DST_CONF="/etc/modprobe.d/disable-nvidia-hyperv.conf"

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
            log_write 1 "Failed to copy $SRC_CONF to $DST_CONF"
        else
            log_write 2 "Successfully copied $SRC_CONF to $DST_CONF"
        fi
    fi
else
    # Not in Hyper-V or virtualization type is none (native boot)
    if [[ -f "$DST_CONF" ]]; then
        rm "$DST_CONF"
        if [[ $? -ne 0 ]]; then
            log_write 1 "Failed to remove $DST_CONF"
        else
            log_write 2 "Successfully removed $DST_CONF"
        fi
    else
        log_write 2 "$DST_CONF does not exist, no action needed"
    fi
fi
