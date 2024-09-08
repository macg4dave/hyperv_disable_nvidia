#!/bin/bash

# Log file for error messages
LOG_FILE="/var/log/hyperv-xorg.log"

# Paths to Xorg configuration files
HYPERV_CONF="/usr/local/share/modlistfiles/hyperv/xorg.conf"
NVIDIA_CONF="/usr/local/share/modlistfiles/nvidia/xorg.conf"
DST_CONF="/etc/X11/xorg.conf"

# Function to log errors
log_error() {
    echo "$(date): $1" >> $LOG_FILE
}

# Function to calculate checksum of a file
get_checksum() {
    if [[ -f "$1" ]]; then
        /usr/bin/md5sum "$1" | awk '{ print $1 }'
    else
        echo "0"
    fi
}

# Function to detect virtualization type
detect_virtualization() {
    local VIRT_ENV=$(systemd-detect-virt)
    echo "$VIRT_ENV"
}

# Get current Xorg configuration checksum
DST_CHECKSUM=$(get_checksum "$DST_CONF")

# Detect environment: NVIDIA or Hyper-V
VIRT_ENV=$(detect_virtualization)

if [[ "$VIRT_ENV" == "microsoft" ]]; then
    # Running inside Hyper-V
    SRC_CONF="$HYPERV_CONF"
else
    SRC_CONF="$NVIDIA_CONF"
fi

# Get the source Xorg configuration checksum
SRC_CHECKSUM=$(get_checksum "$SRC_CONF")

# Compare checksums and copy if necessary
if [[ "$SRC_CHECKSUM" != "$DST_CHECKSUM" ]]; then
    cp "$SRC_CONF" "$DST_CONF"
    if [[ $? -ne 0 ]]; then
        log_error "Failed to copy $SRC_CONF to $DST_CONF"
    else
        echo "$(date): Successfully copied $SRC_CONF to $DST_CONF" >> $LOG_FILE
    fi
else
    echo "$(date): No changes in $SRC_CONF; $DST_CONF is up-to-date" >> $LOG_FILE
fi

if [[ "$(systemd-detect-virt)" == "none" ]]; then
    # Restart Plymouth on bare metal to avoid hanging issues
    systemctl restart plymouth-quit.service
    if [[ $? -ne 0 ]]; then
        log_error "Failed to restart plymouth-quit.service"
    fi
fi
