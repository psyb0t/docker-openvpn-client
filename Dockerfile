# Use the latest Alpine as the base image
FROM alpine:latest

# Install OpenVPN
RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    openvpn

# Add a script to run OpenVPN, Transmission, and Nginx
COPY start-openvpn-client.sh /start-openvpn-client.sh
RUN chmod +x /start-openvpn-client.sh

# Set the entrypoint to the script
ENTRYPOINT ["/start-openvpn-client.sh"]
