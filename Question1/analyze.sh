#!/bin/bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
  echo "Error: Please provide exactly one argument."
  exit 1
fi

# Store the argument
path=$1

# Check if path exists
if [ ! -e "$path" ]; then
  echo "Error: The path does not exist."
  exit 1
fi

# If it is a file
if [ -f "$path" ]; then
  echo "File analysis:"
  wc "$path"

# If it is a directory
elif [ -d "$path" ]; then
  echo "Directory analysis:"
  total_files=$(find "$path" -type f | wc -l)
  txt_files=$(find "$path" -type f -name "*.txt" | wc -l)

  echo "Total files: $total_files"
  echo "Text (.txt) files: $txt_files"
fi
