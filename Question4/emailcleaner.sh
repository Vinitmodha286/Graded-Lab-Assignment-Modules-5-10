#!/bin/bash
# emailcleaner.sh
# Usage: ./emailcleaner.sh emails.txt
# Valid format for this assignment: letters_and_digits@letters.com
# (local part: letters and digits only; domain: letters only; TLD: .com)

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <emails-file>"
  exit 1
fi

file="$1"

# validate file
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

# temporary files
candidates=$(mktemp)
valid_tmp=$(mktemp)
invalid_tmp=$(mktemp)

# extract candidate email-like tokens from the file (handles emails embedded in text)
grep -oE '\b[^[:space:]@]+@[^[:space:]]+\b' "$file" > "$candidates" || true

# Define the "valid" pattern required by the assignment:
# - local part: letters and digits only (one or more)
# - domain: letters only (one or more)
# - .com TLD
valid_pattern='^[A-Za-z0-9]+@[A-Za-z]+\.com$'

# split candidates into valid and invalid sets (exact whole-line match)
grep -xE "$valid_pattern" "$candidates" > "$valid_tmp" || true
grep -xEv "$valid_pattern" "$candidates" > "$invalid_tmp" || true

# remove duplicates and sort
sort "$valid_tmp" | uniq > valid.txt
sort "$invalid_tmp" | uniq > invalid.txt

valid_count=$(wc -l < valid.txt)
invalid_count=$(wc -l < invalid.txt)

echo "Found ${valid_count} unique valid email(s) -> valid.txt"
echo "Found ${invalid_count} unique invalid email(s) -> invalid.txt"

# cleanup temp files
rm -f "$candidates" "$valid_tmp" "$invalid_tmp"
