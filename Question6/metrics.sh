#!/bin/bash
# metrics.sh
# Usage: ./metrics.sh input.txt
# Outputs: longest word, shortest word, average word length, total unique words
# Tools used: tr, sort, uniq, wc, awk, sed

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input.txt>"
  exit 1
fi

file="$1"

# Validate file
if [ ! -e "$file" ]; then
  echo "Error: File does not exist: $file"
  exit 1
fi
if [ ! -f "$file" ]; then
  echo "Error: Path is not a regular file: $file"
  exit 1
fi
if [ ! -r "$file" ]; then
  echo "Error: File is not readable: $file"
  exit 1
fi

# Extract words:
# - convert to lowercase
# - replace any non-alphanumeric characters with newlines
# - remove empty lines
words_stream=$(tr '[:upper:]' '[:lower:]' < "$file" | tr -cs '[:alnum:]' '\n' | sed '/^$/d')

# If no words found, exit gracefully
if [ -z "$words_stream" ]; then
  echo "No words found in file: $file"
  exit 0
fi

# Longest word
longest=$(echo "$words_stream" | awk ' { if(length($0) > max) { max=length($0); w=$0 } } END{ if(max) print w; }')

# Shortest word
shortest=$(echo "$words_stream" | awk ' { if(min=="" || length($0) < min) { min=length($0); w=$0 } } END{ if(min) print w; }')

# Average word length (two decimal places)
average=$(echo "$words_stream" | awk '{ sum+=length($0); count++ } END { if(count>0) printf "%.2f", sum/count; else print "0.00" }')

# Total number of unique words
unique_count=$(echo "$words_stream" | sort | uniq | wc -l | tr -d ' ')

# Print results
echo "Longest word: $longest"
echo "Shortest word: $shortest"
echo "Average word length: $average"
echo "Total unique words: $unique_count"
