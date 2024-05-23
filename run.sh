#!/bin/bash

# Exit immediately if a command exits with a non-zero status, and treat unset variables as an error
set -euo pipefail

# Constants
OPENVPN_STARTED=0
TUN_FILE="/dev/net/tun"
VPN_CONFIG_FILE="/vpn-config.ovpn"
VPN_AUTH_FILE="/vpn-auth.txt"
IP_REPORTER_URL="https://api.ipify.org"

# Function to log messages
log() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$timestamp $message"
}

# Function to cleanly stop processes
cleanup() {
    log "Caught signal or error, stopping OpenVPN"

    if [[ -n "${openvpn_pid-}" ]]; then
        kill -SIGTERM "$openvpn_pid" 2>/dev/null || true
        wait "$openvpn_pid" 2>/dev/null || true
    fi

    log "All processes have been stopped. Exiting."
    exit 1
}

# Function to get the public IP address
get_public_ip() {
    curl -s "$IP_REPORTER_URL"
}

REAL_IP=$(get_public_ip)
CURRENT_IP="$REAL_IP"

# Function to monitor the public IP continuously
monitor_ip() {
    while true; do
        CURRENT_IP=$(get_public_ip)
        log "Public IP: $CURRENT_IP"

        if [[ "$CURRENT_IP" == "$REAL_IP" && $OPENVPN_STARTED -eq 1 ]]; then
            log "REAL IP EXPOSED!!! CURRENT IP: $CURRENT_IP == REAL IP: $REAL_IP"
            cleanup
        fi

        sleep 10
    done
}

# Trap termination signals and errors
trap cleanup SIGINT SIGTERM ERR

# Start the IP monitor in the background
monitor_ip &
monitor_ip_pid=$!

log "Ensuring the TUN device is available..."

mkdir -p /dev/net
if [ ! -c "$TUN_FILE" ]; then
    mknod $TUN_FILE c 10 200
    chmod 600 $TUN_FILE
fi

if [ ! -f "$VPN_CONFIG_FILE" ]; then
    log "OpenVPN configuration file not found: $VPN_CONFIG_FILE"
    cleanup
fi

log "Starting OpenVPN..."
openvpn_cmd="openvpn --config $VPN_CONFIG_FILE"

if [ -f "$VPN_AUTH_FILE" ]; then
    openvpn_cmd="$openvpn_cmd --auth-user-pass $VPN_AUTH_FILE"
fi

$openvpn_cmd &
openvpn_pid=$!
if ! kill -0 $openvpn_pid 2>/dev/null; then
    log "Failed to start OpenVPN."
    cleanup
fi

# Wait for the VPN to establish a connection
sleep 10

OPENVPN_STARTED=1

# Wait for all processes to finish
wait "$openvpn_pid"
openvpn_status=$?

kill $monitor_ip_pid 2>/dev/null

# Check the exit statuses
if [[ $openvpn_status -ne 0 ]]; then
    cleanup
fi

log "All processes completed successfully. Exiting."
exit 0
