# Security Notes

Question:
What are the risks of running random Docker images from the internet on my laptop, and how can I reduce these risks?

# Risks
- The image may contain malicious software,a payload  or backdoors that run automatically.
- The image may have hidden processes inside the container might steal environment variables or cloud credentials.
- Images can include outdated or vulnerable software that exposes the  host system allowing an attacker to exploit it.
- Docker images can escape the container through kernel vulnerabilities.
- Untrusted entrypoints or scripts may execute harmful commands.
- Large images may contain unnecessary tools, increasing the attack surface.

# How to Reduce the Risks
- Null rule, only use images from trusted sources.
- Use AVs to scan images in a virtual environment before use.
- Inspect the Dockerfile and image layers before running (`docker history`, `docker inspect`).
- Scan images with tools like Trivy or Docker Scout.
- Run containers with the least privileges (no root user).
- Use seccomp, AppArmor, or SELinux profiles to restrict system calls.
- Disable unnecessary capabilities using `--cap-drop ALL`.
- Run inside a VM for sensitive work to isolate the host.(sandboxing)
