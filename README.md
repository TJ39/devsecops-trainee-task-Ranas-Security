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

