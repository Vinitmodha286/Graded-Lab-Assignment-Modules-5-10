#!/bin/bash

# analyze_logs.sh
# Usage: ./analyze_logs.sh logfile

# Check argument count
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <logfile>"
  exit 1
fi

log="$1"

# Validate file exists and is readable
if [ ! -e "$log" ]; then
  echo "Error: File does not exist: $log"
  exit 1
fi

if [ ! -f "$log" ]; then
  echo "Error: Path is not a regular file: $log"
  exit 1
fi

if [ ! -r "$log" ]; then
  echo "Error: File is not readable: $log"
  exit 1
fi

# Count total entries (lines)
total=$(wc -l < "$log")
total=${total//[[:space:]]/} # trim whitespace

# Count INFO, WARNING, ERROR using awk (robust)
info=$(awk '$3=="INFO"{i++} END{print (i+0)}' "$log")
warning=$(awk '$3=="WARNING"{i++} END{print (i+0)}' "$log")
error=$(awk '$3=="ERROR"{i++} END{print (i+0)}' "$log")

# Most recent ERROR line (last ERROR entry)
most_recent_error=$(awk '$3=="ERROR"{last=$0} END{ if(last) print last }' "$log")

# Create a dated report file
date_str=$(date +%F)   # YYYY-MM-DD
report="logsummary_${date_str}.txt"

{
  echo "Log summary for: $log"
  echo "Report date: $date_str"
  echo ""
  echo "Total entries: $total"
  echo "INFO: $info"
  echo "WARNING: $warning"
  echo "ERROR: $error"
  echo ""
  echo "Most recent ERROR entry:"
  if [ -n "$most_recent_error" ]; then
    echo "$most_recent_error"
  else
    echo "No ERROR entries found."
  fi
} > "$report"

# Print the results to the terminal as well
echo "Total entries: $total"
echo "INFO: $info"
echo "WARNING: $warning"
echo "ERROR: $error"
echo ""
echo "Most recent ERROR entry:"
if [ -n "$most_recent_error" ]; then
  echo "$most_recent_error"
else
  echo "No ERROR entries found."
fi

echo ""
echo "Report saved to: $report"
