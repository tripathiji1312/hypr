#!/bin/bash

# Enhanced Wofi WiFi Manager for Arch Hyprland
# Improved version with better error handling and functionality

# Configuration
WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE device | grep wifi | head -n1 | cut -d: -f1)
NOTIFICATION_TIMEOUT=3000

# Color and style configuration for wofi
WOFI_STYLE="--style=/home/$USER/.config/wofi/style.css"
WOFI_CONFIG="--conf=/home/$USER/.config/wofi/config"

# Check if NetworkManager is running
check_nm_running() {
    if ! systemctl is-active --quiet NetworkManager; then
        notify-send -u critical "Network Error" "NetworkManager is not running"
        exit 1
    fi
}

# Check if wofi is installed
check_dependencies() {
    if ! command -v wofi &> /dev/null; then
        notify-send -u critical "Dependency Error" "wofi is not installed"
        exit 1
    fi
    
    if ! command -v nmcli &> /dev/null; then
        notify-send -u critical "Dependency Error" "NetworkManager is not installed"
        exit 1
    fi
}

# Get WiFi device automatically
get_wifi_device() {
    local device
    device=$(nmcli -t -f DEVICE,TYPE device | grep wifi | head -n1 | cut -d: -f1)
    
    if [[ -z "$device" ]]; then
        notify-send -u critical "Network Error" "No WiFi device found"
        exit 1
    fi
    
    echo "$device"
}

# Function to get network list with better formatting
get_networks() {
    # Refresh WiFi scan
    nmcli device wifi rescan 2>/dev/null
    sleep 1
    
    nmcli -t -f ACTIVE,SSID,SECURITY,SIGNAL,BARS device wifi list | awk -F: '
    {
        active = $1
        ssid = $2
        security = $3
        signal = $4
        bars = $5
        
        # Skip empty SSIDs or hidden networks
        if (ssid == "" || ssid == "--") next
        
        # Format based on connection status
        if (active == "yes") {
            printf "󰤨 %s (Connected) [%s%%]\n", ssid, signal
        } else {
            # Choose icon based on security
            if (security ~ /WPA|WEP|WPA2|WPA3/) {
                icon = "󰤡"
            } else if (security == "--" || security == "") {
                icon = "󰤟"
            } else {
                icon = "󰤢"
            }
            printf "%s %s [%s%%]\n", icon, ssid, signal
        }
    }' | sort -k3nr | uniq
}

# Function to extract SSID from formatted string
extract_ssid() {
    local network="$1"
    echo "$network" | sed -E 's/^[󰤨󰤡󰤟󰤢] //; s/ \(Connected\).*//; s/ \[.*\]//'
}

# Function to check if network is currently connected
is_connected() {
    local ssid="$1"
    nmcli -t -f ACTIVE,SSID device wifi list | grep "^yes:${ssid}:" &>/dev/null
}

# Function to disconnect from current network
disconnect_network() {
    local ssid="$1"
    local device="$2"
    
    notify-send "Network" "Disconnecting from ${ssid}..." -t $NOTIFICATION_TIMEOUT
    
    if nmcli device disconnect "$device"; then
        notify-send "Network" "Successfully disconnected from ${ssid}" -t $NOTIFICATION_TIMEOUT
        return 0
    else
        notify-send -u critical "Network Error" "Failed to disconnect from ${ssid}" -t $NOTIFICATION_TIMEOUT
        return 1
    fi
}

# Function to connect to network
connect_network() {
    local ssid="$1"
    local device="$2"
    
    notify-send "Network" "Connecting to ${ssid}..." -t $NOTIFICATION_TIMEOUT
    
    # Check if connection profile exists
    if nmcli -g NAME connection show | grep -Fxq "$ssid"; then
        # Use existing profile
        if nmcli connection up id "$ssid"; then
            notify-send "Network" "Successfully connected to ${ssid}" -t $NOTIFICATION_TIMEOUT
            return 0
        else
            notify-send -u critical "Network Error" "Failed to connect to ${ssid}" -t $NOTIFICATION_TIMEOUT
            return 1
        fi
    else
        # Create new connection - check if network requires password
        local security
        security=$(nmcli -t -f SSID,SECURITY device wifi list | grep "^${ssid}:" | cut -d: -f2 | head -n1)
        
        if [[ "$security" == "--" || "$security" == "" ]]; then
            # Open network
            if nmcli device wifi connect "$ssid" ifname "$device"; then
                notify-send "Network" "Successfully connected to ${ssid}" -t $NOTIFICATION_TIMEOUT
                return 0
            else
                notify-send -u critical "Network Error" "Failed to connect to ${ssid}" -t $NOTIFICATION_TIMEOUT
                return 1
            fi
        else
            # Secured network - prompt for password
            local password
            password=$(wofi --dmenu --password --prompt "Enter password for ${ssid}" ${WOFI_STYLE} ${WOFI_CONFIG} 2>/dev/null)
            
            if [[ -z "$password" ]]; then
                notify-send "Network" "Connection cancelled" -t $NOTIFICATION_TIMEOUT
                return 1
            fi
            
            if nmcli device wifi connect "$ssid" password "$password" ifname "$device"; then
                notify-send "Network" "Successfully connected to ${ssid}" -t $NOTIFICATION_TIMEOUT
                return 0
            else
                notify-send -u critical "Network Error" "Failed to connect to ${ssid}. Check password." -t $NOTIFICATION_TIMEOUT
                return 1
            fi
        fi
    fi
}

# Main execution
main() {
    # Perform initial checks
    check_dependencies
    check_nm_running
    
    # Get WiFi device
    WIFI_DEVICE=$(get_wifi_device)
    
    # Get networks and show menu
    local networks
    networks=$(get_networks)
    
    if [[ -z "$networks" ]]; then
        notify-send -u normal "Network" "No WiFi networks found. Make sure WiFi is enabled." -t $NOTIFICATION_TIMEOUT
        exit 0
    fi
    
    # Add special options
    local menu_options
    menu_options=$(printf "%s\n%s\n%s\n%s" \
        "󰤭 Refresh Networks" \
        "󰤮 WiFi Settings" \
        "---" \
        "$networks")
    
    # Show wofi menu
    local chosen_network
    chosen_network=$(echo "$menu_options" | wofi \
        --dmenu \
        --prompt "WiFi Networks" \
        --insensitive \
        --lines=10 \
        --width=400 \
        --height=300 \
        ${WOFI_STYLE} \
        ${WOFI_CONFIG} 2>/dev/null)
    
    # Handle empty selection
    [[ -z "$chosen_network" ]] && exit 0
    
    # Handle special options
    case "$chosen_network" in
        "󰤭 Refresh Networks")
            exec "$0"
            ;;
        "󰤮 WiFi Settings")
            nm-connection-editor &
            exit 0
            ;;
        "---")
            exit 0
            ;;
    esac
    
    # Extract SSID from selection
    local chosen_ssid
    chosen_ssid=$(extract_ssid "$chosen_network")
    
    # Handle network selection
    if [[ "$chosen_network" == *"(Connected)"* ]]; then
        # Currently connected network - offer to disconnect
        local confirm
        confirm=$(printf "No\nYes" | wofi \
            --dmenu \
            --prompt "Disconnect from ${chosen_ssid}?" \
            ${WOFI_STYLE} \
            ${WOFI_CONFIG} 2>/dev/null)
        
        if [[ "$confirm" == "Yes" ]]; then
            disconnect_network "$chosen_ssid" "$WIFI_DEVICE"
        fi
    else
        # Connect to selected network
        connect_network "$chosen_ssid" "$WIFI_DEVICE"
    fi
}

# Execute main function
main "$@"