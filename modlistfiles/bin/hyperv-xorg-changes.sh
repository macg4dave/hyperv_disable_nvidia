#!/bin/bash

# Define paths
CURRENT_XORG="/etc/X11/xorg.conf"
BACKUP_XORG="/usr/local/share/hyperv-disable-nvidia/nvidia/xorg.conf"
HYPERV_XORG="/usr/local/share/hyperv-disable-nvidia/hyperv/xorg.conf"

source /usr/local/share/modlistfiles/bin/error-logger/error-logger.sh

# Set log file and log level for the script
log_file="/var/log/hyperv_disable_nvidia/hyperv-xorg-changes.log"
log_verbose=1  # ERROR level logging

# Detect running environment
VIRT_TYPE=$(systemd-detect-virt)

# Check if running in a virtualized environment (like Hyper-V)
if [[ "$VIRT_TYPE" == "microsoft" ]]; then
    log_write 3 "Running inside Hyper-V, script will not execute."
    exit 0
fi

# Calculate checksums for comparison
current_checksum=$(md5sum "$CURRENT_XORG" | cut -d ' ' -f 1)
hyperv_checksum=$(md5sum "$HYPERV_XORG" | cut -d ' ' -f 1)

# Prevent action if the current xorg.conf is the Hyper-V version
if [[ "$current_checksum" == "$hyperv_checksum" ]]; then
    log_write 3 "Current Xorg configuration is the Hyper-V version, no action needed."
    exit 0
fi

# Check if the Xorg configuration file exists
if [[ ! -f "$CURRENT_XORG" ]]; then
    log_write 1 "No current Xorg configuration file found at $CURRENT_XORG."
    exit 1
fi

# Check against the backup checksum
backup_checksum=$(md5sum "$BACKUP_XORG" | cut -d ' ' -f 1)

# Compare checksums and backup if different
if [[ "$current_checksum" != "$backup_checksum" ]]; then
    cp "$CURRENT_XORG" "$BACKUP_XORG"
    log_write 2 "Updated backup Xorg configuration from $CURRENT_XORG to $BACKUP_XORG."
else
    log_write 3 "No changes detected in Xorg configuration."
fi
