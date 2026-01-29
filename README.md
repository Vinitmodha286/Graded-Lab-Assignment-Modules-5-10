# Graded Lab Assignment (Modules 5–10)

This repository contains solutions for the **Graded Lab Assignment (Modules 5–10)**.  
Each question is implemented in a **separate folder (Question1 to Question10)** as required.

All scripts and programs were executed in a Linux environment using GitHub Codespaces.  
Screenshots, outputs, and explanations are included for each question.

---
### Question 1 – File and Directory Analysis (Shell Script)
- Script: `analyze.sh`
- Accepts exactly one argument (file or directory)
- Displays:
  - Lines, words, and characters for files
  - Total files and `.txt` files for directories
- Handles invalid arguments and paths gracefully

---

### Question 2 – Log File Analysis (Shell Script)
- Script: `analyze_logs.sh`
- Reads a log file in the format:
YYYY-MM-DD HH:MM:SS LEVEL MESSAGE

yaml
Copy code
- Displays:
- Total log entries
- Count of INFO, WARNING, and ERROR messages
- Most recent ERROR message
- Generates a report file `logsummary_<date>.txt`

---

### Question 3 – Student Result Validation (Shell Script)
- Script: `validate_results.sh`
- Reads student data from `marks.txt`
- Passing marks: 33
- Outputs:
- Students who passed all subjects
- Students who failed exactly one subject
- Count of students in each category

---

### Question 4 – Email Cleaning and Classification (Shell Script)
- Script: `emailcleaner.sh`
- Processes `emails.txt`
- Extracts:
- Valid email addresses into `valid.txt`
- Invalid email addresses into `invalid.txt`
- Removes duplicate valid email entries
- Uses `grep`, `sort`, `uniq`, and redirection

---

### Question 5 – Directory Comparison (Shell Script)
- Script: `sync.sh`
- Compares two directories `dirA` and `dirB`
- Lists:
- Files only in `dirA`
- Files only in `dirB`
- Files present in both with matching contents
- Files present in both with different contents
- Uses `cmp` for content comparison (no file modification)

---

### Question 6 – Text Metrics Analysis (Shell Script)
- Script: `metrics.sh`
- Analyzes `input.txt`
- Displays:
- Longest word
- Shortest word
- Average word length
- Total number of unique words
- Uses pipes with `tr`, `sort`, `uniq`, `wc`, and `awk`

---

### Question 7 – Word Pattern Classification (Shell Script)
- Script: `patterns.sh`
- Reads a text file and categorizes words into:
- `vowels.txt` – words with only vowels
- `consonants.txt` – words with only consonants
- `mixed.txt` – words starting with a consonant and containing vowels
- Case-insensitive processing

---

### Question 8 – Background File Move (Shell Script)
- Script: `bg_move.sh`
- Accepts a directory path
- Moves each file into a `backup/` subdirectory
- Each move runs in the background using `&`
- Displays PID of each background process
- Uses `wait`, `$$`, and `$!` to manage processes

---

### Question 9 – Zombie Process Prevention (C Program)
- Program: `zombie_demo.c`
- Creates multiple child processes using `fork()`
- Children exit immediately
- Parent reaps terminated children using `waitpid()`
- Demonstrates prevention of zombie processes
- Parent prints PID of each cleaned-up child

---

### Question 10 – Signal Handling Demonstration (C Program)
- Program: `signal_demo.c`
- Parent process runs indefinitely
- One child sends `SIGTERM` after 5 seconds
- Another child sends `SIGINT` after 10 seconds
- Parent handles each signal differently and exits gracefully
- Demonstrates custom signal handling using `signal()`

---


