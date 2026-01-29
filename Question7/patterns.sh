#!/bin/bash
# patterns.sh
# Usage: ./patterns.sh input.txt
# Writes:
#  - vowels.txt (words containing ONLY vowels)
#  - consonants.txt (words with ONLY consonants)
#  - mixed.txt (words containing both but STARTING with a consonant)
# Case-insensitive. Words are letters only (punctuation removed).

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input-file>"
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

tmp=$(mktemp)

# Normalize to lowercase, split into words (letters only), remove empty lines
tr '[:upper:]' '[:lower:]' < "$file" | tr -cs '[:alpha:]' '\n' | sed '/^$/d' > "$tmp"

vowel_pattern='^[aeiou]+$'
consonant_pattern='^[bcdfghjklmnpqrstvwxyz]+$'
# mixed: starts with a consonant and contains at least one vowel somewhere
mixed_pattern='^[bcdfghjklmnpqrstvwxyz][a-z]*[aeiou][a-z]*$'

# Produce sorted unique outputs
grep -xE "$vowel_pattern" "$tmp" 2>/dev/null | sort -u > vowels.txt || true
grep -xE "$consonant_pattern" "$tmp" 2>/dev/null | sort -u > consonants.txt || true
grep -xE "$mixed_pattern" "$tmp" 2>/dev/null | sort -u > mixed.txt || true

# Print summary to terminal
echo "Wrote $(wc -l < vowels.txt) vowel-only word(s) -> vowels.txt"
echo "Wrote $(wc -l < consonants.txt) consonant-only word(s) -> consonants.txt"
echo "Wrote $(wc -l < mixed.txt) mixed word(s) -> mixed.txt"

# cleanup
rm -f "$tmp"
