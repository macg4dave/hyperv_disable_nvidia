#!/bin/bash

# Usage function to display commands
usage() {
    echo "Usage: $0 [-l <log level>] [-f <log file>] <log message>"
    echo "Log levels: 1=NORMAL, 2=ERROR, 3=INFO, 4=DEBUG"
    exit 1
}

# Default log level and file
LOG_LEVEL=1  # Default to NORMAL
LOG_FILE=""

# Parse options
while getopts "l:f:h" opt; do
    case $opt in
        l) LOG_LEVEL=$OPTARG ;;
        f) LOG_FILE=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

# Check if log message is provided
log_message="$*"
if [ -z "$log_message" ]; then
    usage
fi

# Function to ensure log file path exists and write the log message
write_log_file() {
    local message=$1
    local log_file=$2

    if [ -n "$log_file" ]; then
        local dir
        dir=$(dirname "$log_file")

        # Check if directory exists, create it if necessary
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
        fi

        # Append log message to the file
        echo "$message" >> "$log_file"
    fi
}

# Function for logging
log() {
    local level=$1
    local message=$2
    local datetime=$(date +'%Y-%m-%d %H:%M:%S')
    
    # Map log level numbers to names
    declare -A levels
    levels=([1]="NORMAL" [2]="ERROR" [3]="INFO" [4]="DEBUG")

    # Only log messages that match the current level or are more severe
    if [ $level -le $LOG_LEVEL ]; then
        echo "$datetime - ${levels[$level]}: $message"
        write_log_file "$datetime - ${levels[$level]}: $message" "$LOG_FILE"
    fi
}

# Log based on LOG_LEVEL
log $LOG_LEVEL "$log_message"
