#!/bin/bash
#hyperv-detect-runner.sh
# Paths to the scripts
MODBLOCK_SCRIPT="/usr/local/share/modlistfiles/hyperv-modblock.sh"
XORG_SCRIPT="/usr/local/share/modlistfiles/hyperv-xorg.sh"

# Log file for errors
LOG_FILE="/var/log/hyperv-detect-runner.log"

# Function to log errors
log_error() {
    echo "$(date): $1" >> $LOG_FILE
}

# Run the hyperv-modblock.sh script
if [[ -f "$MODBLOCK_SCRIPT" ]]; then
    bash "$MODBLOCK_SCRIPT"
    if [[ $? -ne 0 ]]; then
        log_error "Failed to run $MODBLOCK_SCRIPT"
    fi
else
    log_error "$MODBLOCK_SCRIPT not found"
fi

# Run the hyperv-xorg.sh script
if [[ -f "$XORG_SCRIPT" ]]; then
    bash "$XORG_SCRIPT"
    if [[ $? -ne 0 ]]; then
        log_error "Failed to run $XORG_SCRIPT"
    fi
else
    log_error "$XORG_SCRIPT not found"
fi
