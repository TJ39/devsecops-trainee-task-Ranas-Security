#!/bin/bash

# ===========================
# Log Checker Script
# ===========================

# Function to check a logfile
check_log() {
    local LOGFILE="$1"

    # File must exist
    if [ ! -f "$LOGFILE" ]; then
        echo "Error: Log file '$LOGFILE' does not exist."
        return 2
    fi

    # Get counts (grep -c ALWAYS outputs one number)
    ERROR_COUNT=$(grep -c "ERROR" "$LOGFILE")
    WARN_COUNT=$(grep -c "WARN" "$LOGFILE")
    INFO_COUNT=$(grep -c "INFO" "$LOGFILE")

    echo "ERROR lines: $ERROR_COUNT"
    echo "WARN lines:  $WARN_COUNT"
    echo "INFO lines:  $INFO_COUNT"

    # Any errors → return 1
    if [ "$ERROR_COUNT" -gt 0 ]; then
        return 1
    fi

    # No errors → return 0
    return 0
}

# ===========================
# Self-test (used in CI)
# ===========================
if [ "$1" == "--self-test" ]; then
    echo "[SELF-TEST] Running internal tests..."

    # Create a temporary good log
    GOOD_LOG="good.log"
    echo "INFO: Everything OK" > "$GOOD_LOG"

    # Should PASS
    check_log "$GOOD_LOG"
    if [ $? -ne 0 ]; then
        echo "[SELF-TEST] FAIL: Good log was expected to pass."
        rm -f "$GOOD_LOG"
        exit 1
    fi

    # Create a bad log
    BAD_LOG="bad.log"
    echo "ERROR: Something bad happened" > "$BAD_LOG"

    # Should FAIL
    check_log "$BAD_LOG"
    if [ $? -eq 0 ]; then
        echo "[SELF-TEST] FAIL: Bad log was expected to fail."
        rm -f "$GOOD_LOG" "$BAD_LOG"
        exit 1
    fi

    echo "[SELF-TEST] PASS"
    rm -f "$GOOD_LOG" "$BAD_LOG"
    exit 0
fi

# ===========================
# Normal script execution
# ===========================
if [ -z "$1" ]; then
    echo "Usage: $0 <logfile> or $0 --self-test"
    exit 2
fi

check_log "$1"
exit $?

