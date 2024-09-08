#!/bin/bash
# Usage on your script
# source /path/to/error-logging.sh

# log_file="/path/to/logfile.log"
# log_verbose=2  # Set global verbose level

# log_write 1 "This is an ERROR message"
# log_write 2 "This is a NORMAL message"
# log_write 3 "This is an INFO message"  # This won't be logged if verbose level is 2

# Default settings
log_verbose=1
log_type=1
log_file="./default.log"
log_message="No message set for error-logging.sh"

# Function to check and create log file path
log_create_path() {
    local log_file=$1
    local dir=$(dirname "$log_file")
    [[ ! -d "$dir" ]] && mkdir -p "$dir"
}

# Function to write log
log_write() {
    local level=$1
    local message=$2
    local datetime=$(date +'%Y-%m-%d %H:%M:%S')
    local formatted_message="$datetime - $message"

    [[ $level -le $log_verbose ]] && {
        log_create_path "$log_file"
        echo "$formatted_message" >> "$log_file"
        return 0
    }
    return 1
}

# Export log functions for sourcing
export -f log_write log_create_path log_usage
