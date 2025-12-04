#!/bin/bash
set -euo pipefail
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

    # Safe counts — prevents "0\n0" errors
    ERROR_COUNT=$(grep -c "ERROR" "$LOGFILE" 2>/dev/null || echo 0)
    WARN_COUNT=$(grep -c "WARN" "$LOGFILE" 2>/dev/null || echo 0)
    INFO_COUNT=$(grep -c "INFO" "$LOGFILE" 2>/dev/null || echo 0)

    echo "===== Log Summary ====="
    echo "ERROR lines: $ERROR_COUNT"
    echo "WARN  lines: $WARN_COUNT"
    echo "INFO  lines: $INFO_COUNT"
    echo "========================"

    # If any errors exist → fail
    if [ "$ERROR_COUNT" -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# ===========================
# Integration Test Mode
# ===========================
run_tests() {
    echo "Running integration tests..."

    # Test 1: Bad log (should fail)
    BAD_LOG=$(mktemp)
    echo "ERROR: something broke" > "$BAD_LOG"

    check_log "$BAD_LOG"
    result=$?

    if [ $result -ne 1 ]; then
        echo "❌ Test failed: bad log did NOT return exit 1"
        rm -f "$BAD_LOG"
        exit 1
    else
        echo "✔ Bad log test passed"
    fi
    rm -f "$BAD_LOG"

    # Test 2: Good log (should pass)
    GOOD_LOG=$(mktemp)
    echo "INFO: all good" > "$GOOD_LOG"

    check_log "$GOOD_LOG"
    result=$?

    if [ $result -ne 0 ]; then
        echo "❌ Test failed: good log did NOT return exit 0"
        rm -f "$GOOD_LOG"
        exit 1
    else
        echo "✔ Good log test passed"
    fi
    rm -f "$GOOD_LOG"

    echo "🎉 All integration tests passed"
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


