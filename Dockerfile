FROM python:3.12-slim

# Creating  non-root user
RUN useradd -m appuser

# Setting working directory
WORKDIR /app

# Copy script into container
COPY env_info.sh /app/env_info.sh
RUN chmod +x /app/env_info.sh

# Switching to non-root user
USER appuser

# Default command
CMD ["./env_info.sh"]
