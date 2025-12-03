#!/bin/bash

# ===========================
# Log Checker Script
# ===========================

check_log() {
    local LOGFILE="$1"

    # Check file exists
    if [ ! -f "$LOGFILE" ]; then
        echo "Error: File '$LOGFILE' does not exist."
        return 2
    fi

    # STATIC MODE COUNTS (force grep exit code to 0)
    ERROR_COUNT=$(grep -c "ERROR" "$LOGFILE" 2>/dev/null)
    WARN_COUNT=$(grep -c "WARN" "$LOGFILE" 2>/dev/null)
    INFO_COUNT=$(grep -c "INFO" "$LOGFILE" 2>/dev/null)

    echo "===== Log Summary ====="
    echo "ERROR lines: $ERROR_COUNT"
    echo "WARN lines:  $WARN_COUNT"
    echo "INFO lines:  $INFO_COUNT"
    echo "========================"

    # EXIT CODES
    if [ "$ERROR_COUNT" -gt 0 ]; then
        return 1   # fail
    else
        return 0   # pass
    fi
}

# ===========================
# Integration Test Mode
# ===========================
run_tests() {
    echo "Running integration tests..."

    # Test 1: Bad log (should fail)
    BAD_LOG=$(mktemp)
    echo "ERROR: something went wrong" > "$BAD_LOG"
    check_log "$BAD_LOG"
    result=$?
    if [ $result -ne 1 ]; then
        echo "Test failed: checker passed on bad log (exit=$result)"
        rm -f "$BAD_LOG"
        exit 1
    else
        echo "Bad log test passed"
    fi
    rm -f "$BAD_LOG"

    # Test 2: Good log (should pass)
    GOOD_LOG=$(mktemp)
    echo "INFO: all systems normal" > "$GOOD_LOG"
    check_log "$GOOD_LOG"
    result=$?
    if [ $result -ne 0 ]; then
        echo "Test failed: checker failed on good log (exit=$result)"
        rm -f "$GOOD_LOG"
        exit 1
    else
        echo "Good log test passed"
    fi
    rm -f "$GOOD_LOG"

    echo "All tests passed"
    exit 0
}

# ===========================
# Main Logic
# ===========================
if [ "$1" == "self-test" ]; then
    run_tests
elif [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile> | self-test"
    exit 2
else
    check_log "$1"
    exit $?
fi

