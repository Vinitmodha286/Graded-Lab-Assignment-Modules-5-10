#!/bin/bash
# bg_move.sh
# Usage: ./bg_move.sh <directory>
# Moves each regular file in <directory> into a subdirectory named backup/
# Each move runs in the background (&). The script prints each background PID ($!) and
# waits for all of them to finish using wait.
# Script PID: $$

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

dir="$1"

# Validate
if [ ! -e "$dir" ]; then
  echo "Error: Path does not exist: $dir"
  exit 1
fi
if [ ! -d "$dir" ]; then
  echo "Error: Not a directory: $dir"
  exit 1
fi
if [ ! -r "$dir" ]; then
  echo "Error: Directory is not readable: $dir"
  exit 1
fi

backup="$dir/backup"
mkdir -p "$backup" || { echo "Error creating backup directory: $backup"; exit 1; }

echo "Script PID: $$"

# arrays for PIDs and mapping PID->file
declare -a pids
declare -A pid_to_file

count=0
# iterate over items in directory (top-level files only)
for filepath in "$dir"/*; do
  [ -e "$filepath" ] || continue   # skip if glob didn't match
  # skip the backup directory itself
  if [ "$filepath" = "$backup" ]; then
    continue
  fi
  if [ -f "$filepath" ]; then
    # perform move in a background subshell to keep the mv atomic even with spaces
    ( mv -- "$filepath" "$backup/" ) &
    pid=$!
    pids+=("$pid")
    pid_to_file[$pid]="$filepath"
    echo "Started move: '$(basename "$filepath")' -> '$(basename "$backup")/'  PID: $pid"
    ((count++))
  fi
done

if [ "$count" -eq 0 ]; then
  echo "No regular files to move in: $dir"
  exit 0
fi

echo "Waiting for $count background process(es) to finish..."

# wait for each PID and report its exit status
for pid in "${pids[@]}"; do
  if wait "$pid"; then
    status=0
  else
    status=$?
  fi
  file="${pid_to_file[$pid]}"
  echo "PID $pid (file: '$(basename "$file")') finished with exit status: $status"
done

echo "All background moves complete."
