#!/bin/bash

# Check argument provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 2
fi

LOGFILE="$1"

# Check file exists
if [ ! -f "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' does not exist."
    exit 2
fi

# Static mode count
ERROR_COUNT=$(grep -c "ERROR" "$LOGFILE")
WARN_COUNT=$(grep -c "WARN" "$LOGFILE")
INFO_COUNT=$(grep -c "INFO" "$LOGFILE")

echo "===== Log Summary ====="
echo "ERROR lines: $ERROR_COUNT"
echo "WARN lines:  $WARN_COUNT"
echo "INFO lines:  $INFO_COUNT"
echo "========================"

# exist codes
if [ "$ERROR_COUNT" -gt 0 ]; then
    exit 1
else
    exit 0
fi

