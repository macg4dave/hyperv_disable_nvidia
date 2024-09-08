#!/bin/bash
# hyperv-detect-runner.sh
# Source the error logging script
source /usr/local/share/modlistfiles/bin/error-logger.sh

# Set log file and log level for this script
log_file="/var/log/hyperv-detect-runner.log"
log_verbose=1  # Set to log ERROR messages

# Paths to the scripts
MODBLOCK_SCRIPT="/usr/local/share/modlistfiles/hyperv-modblock.sh"
XORG_SCRIPT="/usr/local/share/modlistfiles/hyperv-xorg.sh"

# Run the hyperv-modblock.sh script
if [[ -f "$MODBLOCK_SCRIPT" ]]; then
    bash "$MODBLOCK_SCRIPT"
    if [[ $? -ne 0 ]]; then
        log_write 1 "Failed to run $MODBLOCK_SCRIPT"
    fi
else
    log_write 1 "$MODBLOCK_SCRIPT not found"
fi

# Run the hyperv-xorg.sh script
if [[ -f "$XORG_SCRIPT" ]]; then
    bash "$XORG_SCRIPT"
    if [[ $? -ne 0 ]]; then
        log_write 1 "Failed to run $XORG_SCRIPT"
    fi
else
    log_write 1 "$XORG_SCRIPT not found"
fi

