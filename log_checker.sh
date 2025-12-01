
#!/bin/bash

#checking if a file path was provided
if [ -z "$1" ]; then
    echo "Error: No log file specified."
    exit 1

fi

LOGFILE="$1"

#Checking if the file exists
if [ ! -f "$LOGFILE" ]; then
    echo  "Error: File '$LOGFILE' does not exist"
    exit 2
fi

#Count lines
total=$(wc -l < "$LOGFILE")
info=$(grep -c "INFO" "LOGFILE")
warn=$(grep -c "WARN" "LOGFILE" )
error=$(grep -c "ERROR" "LOGFILE")

#Printing Results
echo "Total Lines: $total"
echo "Lines with INFO: $info"
echo "Lines with WARM: $warn"
echo "Lines with ERROr: $error"
