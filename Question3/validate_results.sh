#!/bin/bash
# validate_results.sh
# Usage: ./validate_results.sh marks.txt
# Passing marks for each subject: 33

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <marksfile>"
  exit 1
fi

file="$1"

# validate file exists and readable
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

pass_mark=33

passed_all_count=0
failed_one_count=0
failed_more_count=0

passed_list=()
failed_one_list=()

# read each CSV line: RollNo, Name, Marks1, Marks2, Marks3
while IFS=',' read -r roll name m1 m2 m3; do
  # trim whitespace
  roll="$(echo "$roll" | sed 's/^ *//; s/ *$//')"
  name="$(echo "$name" | sed 's/^ *//; s/ *$//')"
  m1="$(echo "$m1" | sed 's/^ *//; s/ *$//')"
  m2="$(echo "$m2" | sed 's/^ *//; s/ *$//')"
  m3="$(echo "$m3" | sed 's/^ *//; s/ *$//')"

  # skip empty lines
  if [ -z "$roll" ]; then
    continue
  fi

  # convert non-numeric marks to 0 safely
  for var in m1 m2 m3; do
    val="${!var}"
    if ! [[ "$val" =~ ^[0-9]+$ ]]; then
      val=0
    fi
    eval "$var=$val"
  done

  fails=0
  for mark in "$m1" "$m2" "$m3"; do
    if [ "$mark" -lt "$pass_mark" ]; then
      ((fails++))
    fi
  done

  if [ "$fails" -eq 0 ]; then
    ((passed_all_count++))
    passed_list+=("$roll - $name")
  elif [ "$fails" -eq 1 ]; then
    ((failed_one_count++))
    failed_one_list+=("$roll - $name")
  else
    ((failed_more_count++))
  fi
done < "$file"

# Output results
echo "Students who PASSED ALL subjects (>= $pass_mark):"
if [ "${#passed_list[@]}" -eq 0 ]; then
  echo "None"
else
  for s in "${passed_list[@]}"; do echo "$s"; done
fi

echo
echo "Students who FAILED in EXACTLY ONE subject:"
if [ "${#failed_one_list[@]}" -eq 0 ]; then
  echo "None"
else
  for s in "${failed_one_list[@]}"; do echo "$s"; done
fi

echo
echo "Counts:"
echo "Passed all: $passed_all_count"
echo "Failed exactly one: $failed_one_count"
echo "Failed more than one: $failed_more_count"
