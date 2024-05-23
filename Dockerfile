# Use the latest Alpine as the base image
FROM alpine:latest

# Install OpenVPN
RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    openvpn

# Add a script to run OpenVPN, Transmission, and Nginx
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Set the entrypoint to the script
ENTRYPOINT ["/run.sh"]
