#!/bin/bash
# sync.sh
# Usage: ./sync.sh dirA dirB
# Compares two directories:
# - lists files only in dirA
# - lists files only in dirB
# - for common files (same relative path) checks whether contents match (using cmp, non-destructive)

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <dirA> <dirB>"
  exit 1
fi

dirA=$1
dirB=$2

# validate directories
if [ ! -e "$dirA" ]; then
  echo "Error: Path does not exist: $dirA"
  exit 1
fi
if [ ! -e "$dirB" ]; then
  echo "Error: Path does not exist: $dirB"
  exit 1
fi
if [ ! -d "$dirA" ]; then
  echo "Error: Not a directory: $dirA"
  exit 1
fi
if [ ! -d "$dirB" ]; then
  echo "Error: Not a directory: $dirB"
  exit 1
fi

# temporary files
tmpA=$(mktemp)
tmpB=$(mktemp)
common=$(mktemp)

trap 'rm -f "$tmpA" "$tmpB" "$common"' EXIT

# produce lists of files relative to each directory root, sorted
find "$dirA" -type f -printf '%P\n' | sort > "$tmpA"
find "$dirB" -type f -printf '%P\n' | sort > "$tmpB"

# files only in A
onlyA=$(mktemp)
comm -23 "$tmpA" "$tmpB" > "$onlyA"

# files only in B
onlyB=$(mktemp)
comm -13 "$tmpA" "$tmpB" > "$onlyB"

# common files (present in both)
comm -12 "$tmpA" "$tmpB" > "$common"

# Prepare counters and lists
matched_list=$(mktemp)
different_list=$(mktemp)
matched_count=0
different_count=0

while IFS= read -r file; do
  # compare contents without modifying files
  if cmp -s "$dirA/$file" "$dirB/$file"; then
    echo "$file" >> "$matched_list"
    ((matched_count++))
  else
    echo "$file" >> "$different_list"
    ((different_count++))
  fi
done < "$common"

# Report filename
date_str=$(date +%F)
report="sync_report_${date_str}.txt"

{
  echo "Sync report comparing: $dirA  <->  $dirB"
  echo "Report date: $date_str"
  echo ""
  echo "Files only in $dirA:"
  if [ -s "$onlyA" ]; then
    cat "$onlyA"
  else
    echo "None"
  fi
  echo ""
  echo "Files only in $dirB:"
  if [ -s "$onlyB" ]; then
    cat "$onlyB"
  else
    echo "None"
  fi
  echo ""
  echo "Common files (contents MATCH): ($matched_count)"
  if [ -s "$matched_list" ]; then
    cat "$matched_list"
  else
    echo "None"
  fi
  echo ""
  echo "Common files (contents DIFFER): ($different_count)"
  if [ -s "$different_list" ]; then
    cat "$different_list"
  else
    echo "None"
  fi
} > "$report"

# Also print summary to terminal
echo "Files only in $dirA:"
if [ -s "$onlyA" ]; then cat "$onlyA"; else echo "None"; fi
echo ""
echo "Files only in $dirB:"
if [ -s "$onlyB" ]; then cat "$onlyB"; else echo "None"; fi
echo ""
echo "Common files (contents MATCH): ($matched_count)"
if [ -s "$matched_list" ]; then cat "$matched_list"; else echo "None"; fi
echo ""
echo "Common files (contents DIFFER): ($different_count)"
if [ -s "$different_list" ]; then cat "$different_list"; else echo "None"; fi

echo ""
echo "Report saved to: $report"

# cleanup temporary small lists for matched/different/onlyA/onlyB
rm -f "$onlyA" "$onlyB" "$matched_list" "$different_list"
