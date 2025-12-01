# DevSecOps Trainee Task – Ranas Security

This repository contains solutions to the trainee DevSecOps tasks, including:
- A Bash log checker script
- A non-root Docker container that prints environment information
- Documentation and security notes



# Task 1 — Log Checker

# Usage:

./log_checker.sh sample.log


# Task 2 — Containerized Environment Info Script

# Build:
 
docker build -t env-info .

#Run:
docker run -e APP_ENV-production env-info



This container:
- Uses a slim Python base image  
- Creates a non-root user  
- Runs a basic script that prints environment information  

-

# Task 3 — Git Workflow
This repository uses clear, meaningful commit messages:
- `feat: add log checker script`
- `feat: add containerized env info script`
- `docs: update README with usage examples`



# Task 4 — Security Notes
See `SECURITY_NOTES.md` for DevSecOps reasoning about container security.



# Requirements
- Linux environment (local or VM)
- Bash
- Docker (for Task 2)
