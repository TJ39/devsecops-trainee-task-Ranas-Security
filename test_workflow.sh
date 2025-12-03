#!/bin/bash

echo "Running automated workflow validation..."

# Test 1: Clean log (should pass)
echo "INFO: everything okay" > test_clean.log
./log_checker.sh test_clean.log
CLEAN_EXIT=$?

# Test 2: Error log (should fail)
echo "ERROR: something broke" > test_error.log
./log_checker.sh test_error.log
ERROR_EXIT=$?

# Evaluate results
if [[ $CLEAN_EXIT -eq 0 && $ERROR_EXIT -ne 0 ]]; then
    echo "PASS: Workflow behaves correctly."
    exit 0
else
    echo "FAIL: Workflow does not behave as expected."
    echo "CLEAN_EXIT=$CLEAN_EXIT"
    echo "ERROR_EXIT=$ERROR_EXIT"
    exit 1
fi
