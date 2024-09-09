#!/bin/bash
# hyperv-modblock.sh
# Source the error logging script
source /usr/local/share/modlistfiles/bin/error-logging/error-logging.sh

# Set log file and log level for this script
log_file="/var/log/hyperv_disable_nvidia/hyperv-modblock.log"
log_verbose=1  # Set to log ERROR messages

# Path to the configuration file
SRC_CONF="/usr/local/share/modlistfiles/disable-nvidia-hyperv.conf"
DST_CONF="/etc/modprobe.d/disable-nvidia-hyperv.conf"

# Function to detect virtualization type
detect_virtualization() {
    local virt_type=$(systemd-detect-virt)
    echo "$virt_type"
}

# Function to detect virtualization
detect_virtualization() {
    systemd-detect-virt
}

# Main logic
VIRT_TYPE=$(detect_virtualization)

if [[ "$VIRT_TYPE" == "microsoft" ]]; then
    # Operating within Hyper-V environment
    log_write 2 "Operating within Hyper-V, added $DST_CONF ."
else
    # Operating on bare metal or virtualization type is none
    if [[ -f "$DST_CONF" ]]; then
        # If the file exists, remove it
        if rm "$DST_CONF"; then
            log_write 2 "Successfully removed $DST_CONF."
        else
            log_write 1 "Failed to remove $DST_CONF."
        fi
    else
        log_write 2 "$DST_CONF does not exist; no action needed."
    fi
fi
