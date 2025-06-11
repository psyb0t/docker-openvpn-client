FROM alpine:3.20

# Install OpenVPN and other necessary tools
RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    openvpn && \
    rm -rf /var/cache/apk/*

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Set the entrypoint to the script
ENTRYPOINT ["/run.sh"]
