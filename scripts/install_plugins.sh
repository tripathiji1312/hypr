#!/bin/bash

echo "Starting Hyprland Plugin Installation..."
echo "This script requires sudo to install Hyprland headers via hyprpm."

# Update hyprpm and install headers
echo "Updating hyprpm..."
hyprpm update || { echo "Failed to update hyprpm."; exit 1; }

# Add the official plugins repository
echo "Adding official plugins repository..."
hyprpm add https://github.com/hyprwm/hyprland-plugins || { echo "Failed to add repository."; exit 1; }

# Enable the plugins
echo "Enabling plugins..."
hyprpm enable hyprexpo
hyprpm enable hyprtrails
hyprpm enable hyprfocus

echo "Done! Please run 'hyprctl reload' to apply."
