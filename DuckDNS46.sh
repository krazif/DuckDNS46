#!/bin/bash

# If the script detects changes on either IPs, it will clear the records on DuckDNS then 
# after 5 seconds it will update for the new IPs. 
# - Razif 2025-03-18

# URLs to get the IPv4 and IPv6 addresses
URL_IPV4="https://ifconfig.io"
URL_IPV6="https://ifconfig.io"

# Files to store the IPv4 and IPv6 addresses
FILE_IPV4=".ipv4_address.txt"
FILE_IPV6=".ipv6_address.txt"

# DuckDNS configuration
DOMAIN="khalidkingdom" # This is your hostname, without  .duckdns.org 
TOKEN="xxxxd-xxx-xxxx-xxxx-xxxxx" # Your DuckDNS token

# DuckDNS update URL
DUCKDNS_UPDATE_URL="https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}"

# Get the current IPv4 address
CURRENT_IPV4=$(curl -s -4 "$URL_IPV4")

# Get the current IPv6 address
CURRENT_IPV6=$(curl -s -6 "$URL_IPV6")

# Function to compare and update IP addresses
compare_and_update() {
    local CURRENT_IP=$1
    local FILE=$2
    local IP_TYPE=$3

    # Check if the file exists
    if [ -f "$FILE" ]; then
        # Read the saved IP address from the file
        SAVED_IP=$(cat "$FILE")

        # Compare the current IP with the saved IP
        if [ "$CURRENT_IP" != "$SAVED_IP" ]; then
            echo "${IP_TYPE} is different"
            # Replace the content in the file with the new IP
            echo "$CURRENT_IP" > "$FILE"
            return 1
        else
            echo "same ${IP_TYPE}"
            return 0
        fi
    else
        # If the file does not exist, create it and save the current IP
        echo "$CURRENT_IP" > "$FILE"
        echo "${FILE} created with the current ${IP_TYPE}"
        return 1
    fi
}

# Compare and update IPv4 address
compare_and_update "$CURRENT_IPV4" "$FILE_IPV4" "IPv4"
IPV4_CHANGED=$?

# Compare and update IPv6 address
compare_and_update "$CURRENT_IPV6" "$FILE_IPV6" "IPv6"
IPV6_CHANGED=$?

# If either IP has changed, update DuckDNS
if [ $IPV4_CHANGED -eq 1 ] || [ $IPV6_CHANGED -eq 1 ]; then
    # Clear existing IP addresses
    curl -s "${DUCKDNS_UPDATE_URL}&clear=true&verbose=true"

    # Wait for 5 seconds
    sleep 5

    # Update DuckDNS with the new IP addresses
    curl -s "${DUCKDNS_UPDATE_URL}&ip=${CURRENT_IPV4}&ipv6=${CURRENT_IPV6}&verbose=true"
fi
