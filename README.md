# DevSecOps Trainee Tasks – Ranas Security

This repository contains solutions for the DevSecOps-trainee-task
It includes Bash automation scripts, a secure Docker container setup, repository hygiene improvements, and a GitHub Action for automated log checking.


#  Task 1 – Log Checker Script

#File: log_checker.sh

A Bash script that analyzes a log file and reports the number of `ERROR`, `WARN`, and `INFO` entries.  
It is designed for automated log analysis and integrates into CI pipelines.

#Features**
- Takes a log file as a equired command-line argument
- Validates that the file exists
- Counts:
  - `ERROR` lines
  - `WARN` lines
  - `INFO` lines
- Prints results in a clean readable summary
- Returns meaningful exit codes (important for automation and CI)

#Exit Codes
 Exit Code | Meaning |
|----------|---------|
| 0        | No ERROR lines found 
| 1        | At least one ERROR line found 
| 2        | Incorrect usage or file not found 

#Usage
bash
chmod +x log_checker.sh
./log_checker.sh sample.log


#-Containerized Environment Info Script

 # Build:
 docker build -t env-info .

 #Run: docker run -e APP_ENV-production env-info

 This container: - Uses a slim Python base image
 - Creates a non-root user
 - Runs a basic script that prints environments 

#-Git Workflow
 This repository uses clear, meaningful commit messages:
 - feat: add log checker script 
- feat: add containerized env info script 
- docs: update README with usage examples

-Security Notes 
See SECURITY_NOTES.md for DevSecOps reasoning about container security.


#Task 2 – Improvements
1. Repository Hygiene

- Added .gitignore to prevent committing temporary and swap files

- Cleaned up editor-generated files

- Improved folder and project structure

2. Improved log_checker.sh

The script now:

- Accepts a log file as a required argument

- Validates file existence

- Counts ERROR, WARN, and INFO lines

- Prints results in a clean readable format

#Exits with:

1 → if at least one ERROR is found

0 → if no ERROR lines exist

2 → if incorrect usage or missing file

#Usage:

chmod +x log_checker.sh
./log_checker.sh sample.log

3. GitHub Actions Workflow

A pipeline has been added under .github/workflows/log-check.yml.

It:

- Runs on every push & pull request

- Executes log_checker.sh sample.log

- Fails if the script exits with a non-zero status

This ensures automated static log checking.

# CI: Log Checker
This repository includes a GitHub Actions workflow that:
- runs log_checker.sh sample.log on every push and PR,
- fails (red) if ERROR appears in the log,
- passes (green) otherwise.


#Task 5 — Automated Meta-Testing (Self-Validation of the CI System)

This repository includes a meta-testing mechanism that automatically verifies whether the main CI log-checking workflow behaves correctly.
It ensures that:

A clean log correctly results in a CI Pass, and

An error log correctly results in a CI Fail.

This removes the need for manual testing (e.g., echo "trigger"), and makes the  DevSecOps pipeline behave  with self-validation built in.

📄 test_workflow.sh — Meta-Test Script

This script generates two test logs and checks whether the log_checker.py tool returns the correct exit codes.

#How It Works

Creates sample_clean.log → contains no error keywords

Expected result: log checker returns success

Creates sample_error.log → contains simulated error text

Expected result: log checker returns failure

If either behavior is incorrect, the script exits with code 1, causing the CI to fail.

###.github/workflows/test-the-test.yml — Automated Meta-Test Workflow

This GitHub Action runs the test_workflow.sh script on every push or pull request, ensuring the log checker is always functioning correctly.
What This Meta-Testing Proves
Scenario	Expected Result	Validates
sample_clean.log contains no errors	CI passes	Log checker correctly ignores clean logs
sample_error.log contains "ERROR"	CI fails	Log checker correctly detects real issues

This provides CI robustness and ensures the  DevSecOps pipeline behaves predictably without manual intervention.

###Self-Test Mode (Integration Test)

The log checker includes a built-in self-test that validates its own behavior without requiring manual creation of test logs.

**How to run the self-test**
./log_checker.sh self-test

**What it verifies**

The self-test automatically performs two checks:

-Bad log case (expected to fail with exit code 1)

-Creates a temporary log file containing an ERROR line

-Ensures the log checker exits with 1 (failure)

-Good log case (expected to pass with exit code 0)

-Creates a temporary log file with only INFO lines

-Ensures the log checker exits with 0 (success)

If both conditions are correctly validated, the script prints:

All tests passed


This is used in CI to verify that the tool works correctly on both clean and failing logs.
