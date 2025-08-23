#!/bin/bash

# Enhanced Wofi-based clipboard manager using cliphist
# Improved version with better error handling and features

# Configuration
MAX_DISPLAY_LENGTH=80
NOTIFICATION_TIMEOUT=2000
WOFI_LINES=15
WOFI_WIDTH=600
WOFI_HEIGHT=400

# Style configuration (fallback gracefully if files don't exist)
WOFI_STYLE=""
WOFI_CONFIG=""
[[ -f "/home/$USER/.config/wofi/style.css" ]] && WOFI_STYLE="--style=/home/$USER/.config/wofi/style.css"
[[ -f "/home/$USER/.config/wofi/config" ]] && WOFI_CONFIG="--conf=/home/$USER/.config/wofi/config"

# Define menu options with better icons
copy_option="󰆏 Copy Selected"
delete_option="󰩺 Delete Item"
clear_option="󰎟 Clear All History"
edit_option="󰏫 Edit & Copy"
view_option="󰍉 View Full Content"
separator="────────────────"

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    command -v wofi >/dev/null || missing_deps+=("wofi")
    command -v cliphist >/dev/null || missing_deps+=("cliphist")
    command -v wl-copy >/dev/null || missing_deps+=("wl-clipboard")
    command -v notify-send >/dev/null || missing_deps+=("libnotify")
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Missing dependencies: ${missing_deps[*]}"
        notify-send -u critical "Clipboard Manager" "Missing dependencies: ${missing_deps[*]}" -t $NOTIFICATION_TIMEOUT
        exit 1
    fi
}

# Format clipboard entries for display
format_entry() {
    local entry="$1"
    local formatted
    
    # Remove newlines and limit length
    formatted=$(echo "$entry" | tr '\n' ' ' | sed 's/\s\+/ /g')
    
    if [[ ${#formatted} -gt $MAX_DISPLAY_LENGTH ]]; then
        formatted="${formatted:0:$MAX_DISPLAY_LENGTH}..."
    fi
    
    # Add type indicators
    case "$entry" in
        http*|https*|ftp*|www.*)
            echo "󰖟 $formatted"
            ;;
        *@*.*)
            echo "󰇰 $formatted"
            ;;
        [0-9]*[0-9])
            echo "󰎠 $formatted"
            ;;
        */*)
            echo "󰉋 $formatted"
            ;;
        *)
            echo "󰈙 $formatted"
            ;;
    esac
}

# Get and format clipboard history
get_formatted_history() {
    local history raw_history
    
    raw_history=$(cliphist list 2>/dev/null)
    
    if [[ -z "$raw_history" ]]; then
        echo "󰋻 No clipboard history found"
        return 1
    fi
    
    # Format each entry
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            format_entry "$line"
        fi
    done <<< "$raw_history"
    
    return 0
}

# Show wofi menu with improved styling
show_menu() {
    local options="$1"
    local prompt="$2"
    
    echo -e "$options" | wofi \
        --dmenu \
        --prompt "$prompt" \
        --insensitive \
        --lines=$WOFI_LINES \
        --width=$WOFI_WIDTH \
        --height=$WOFI_HEIGHT \
        --matching=fuzzy \
        --allow-markup \
        $WOFI_STYLE \
        $WOFI_CONFIG 2>/dev/null
}

# Delete specific entry
delete_entry() {
    local history formatted_history to_delete original_entry
    
    history=$(cliphist list 2>/dev/null)
    
    if [[ -z "$history" ]]; then
        notify-send "Clipboard Manager" "No history to delete" -t $NOTIFICATION_TIMEOUT
        return 1
    fi
    
    formatted_history=$(get_formatted_history)
    to_delete=$(show_menu "$formatted_history" "Select item to delete")
    
    if [[ -n "$to_delete" && "$to_delete" != "󰋻 No clipboard history found" ]]; then
        # Find original entry by matching formatted version
        original_entry=$(cliphist list | while IFS= read -r line; do
            formatted=$(format_entry "$line")
            if [[ "$formatted" == "$to_delete" ]]; then
                echo "$line"
                break
            fi
        done)
        
        if [[ -n "$original_entry" ]]; then
            cliphist delete <<< "$original_entry"
            notify-send "Clipboard Manager" "Entry deleted successfully" -t $NOTIFICATION_TIMEOUT
        else
            notify-send -u critical "Clipboard Manager" "Failed to delete entry" -t $NOTIFICATION_TIMEOUT
        fi
    fi
}

# Clear all history with confirmation
clear_history() {
    local confirm
    
    confirm=$(echo -e "󰜺 No\n󰸞 Yes, Clear All" | show_menu "" "Clear entire clipboard history?")
    
    if [[ "$confirm" == "󰸞 Yes, Clear All" ]]; then
        cliphist wipe
        notify-send "Clipboard Manager" "Clipboard history cleared" -t $NOTIFICATION_TIMEOUT
    else
        notify-send "Clipboard Manager" "Clear operation cancelled" -t $NOTIFICATION_TIMEOUT
    fi
}

# Edit entry before copying
edit_entry() {
    local history formatted_history to_edit original_entry edited_content
    
    history=$(cliphist list 2>/dev/null)
    
    if [[ -z "$history" ]]; then
        notify-send "Clipboard Manager" "No history to edit" -t $NOTIFICATION_TIMEOUT
        return 1
    fi
    
    formatted_history=$(get_formatted_history)
    to_edit=$(show_menu "$formatted_history" "Select item to edit")
    
    if [[ -n "$to_edit" && "$to_edit" != "󰋻 No clipboard history found" ]]; then
        # Find original entry
        original_entry=$(cliphist list | while IFS= read -r line; do
            formatted=$(format_entry "$line")
            if [[ "$formatted" == "$to_edit" ]]; then
                echo "$line"
                break
            fi
        done)
        
        if [[ -n "$original_entry" ]]; then
            # Decode and edit
            content=$(cliphist decode <<< "$original_entry")
            edited_content=$(echo "$content" | wofi \
                --dmenu \
                --prompt "Edit content" \
                --lines=1 \
                --width=800 \
                $WOFI_STYLE \
                $WOFI_CONFIG 2>/dev/null)
            
            if [[ -n "$edited_content" ]]; then
                echo "$edited_content" | wl-copy
                notify-send "Clipboard Manager" "Edited content copied to clipboard" -t $NOTIFICATION_TIMEOUT
            fi
        fi
    fi
}

# View full content of an entry
view_entry() {
    local history formatted_history to_view original_entry content
    
    history=$(cliphist list 2>/dev/null)
    
    if [[ -z "$history" ]]; then
        notify-send "Clipboard Manager" "No history to view" -t $NOTIFICATION_TIMEOUT
        return 1
    fi
    
    formatted_history=$(get_formatted_history)
    to_view=$(show_menu "$formatted_history" "Select item to view")
    
    if [[ -n "$to_view" && "$to_view" != "󰋻 No clipboard history found" ]]; then
        # Find original entry
        original_entry=$(cliphist list | while IFS= read -r line; do
            formatted=$(format_entry "$line")
            if [[ "$formatted" == "$to_view" ]]; then
                echo "$line"
                break
            fi
        done)
        
        if [[ -n "$original_entry" ]]; then
            content=$(cliphist decode <<< "$original_entry")
            
            # Show content in a dialog-like format
            echo "Content:" | cat - <(echo "$content") | wofi \
                --dmenu \
                --prompt "Full Content (Press Esc to close)" \
                --lines=20 \
                --width=800 \
                --height=500 \
                $WOFI_STYLE \
                $WOFI_CONFIG >/dev/null 2>&1
        fi
    fi
}

# Copy selected entry to clipboard
copy_entry() {
    local chosen="$1"
    local original_entry content
    
    # Find original entry
    original_entry=$(cliphist list | while IFS= read -r line; do
        formatted=$(format_entry "$line")
        if [[ "$formatted" == "$chosen" ]]; then
            echo "$line"
            break
        fi
    done)
    
    if [[ -n "$original_entry" ]]; then
        content=$(cliphist decode <<< "$original_entry")
        echo "$content" | wl-copy
        
        # Show preview of copied content
        preview=$(echo "$content" | head -c 50)
        [[ ${#content} -gt 50 ]] && preview="${preview}..."
        
        notify-send "Clipboard Manager" "Copied: $preview" -t $NOTIFICATION_TIMEOUT
    else
        notify-send -u critical "Clipboard Manager" "Failed to copy entry" -t $NOTIFICATION_TIMEOUT
    fi
}

# Main function
main() {
    # Check dependencies first
    check_dependencies
    
    # Get clipboard history
    local history formatted_history options chosen
    
    history=$(cliphist list 2>/dev/null)
    
    if [[ -z "$history" ]]; then
        notify-send "Clipboard Manager" "No clipboard history found. Copy something first!" -t $NOTIFICATION_TIMEOUT
        exit 0
    fi
    
    formatted_history=$(get_formatted_history)
    
    if [[ $? -ne 0 ]]; then
        exit 1
    fi
    
    # Combine history with action options
    options=$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s" \
        "$copy_option" \
        "$edit_option" \
        "$view_option" \
        "$separator" \
        "$delete_option" \
        "$clear_option" \
        "$separator" \
        "$formatted_history")
    
    # Show main menu
    chosen=$(show_menu "$options" "Clipboard Manager")
    
    # Exit if nothing is chosen
    [[ -z "$chosen" ]] && exit 0
    
    # Handle the choice
    case "$chosen" in
        "$copy_option")
            # Show history for copying
            selected=$(show_menu "$formatted_history" "Select item to copy")
            [[ -n "$selected" && "$selected" != "󰋻 No clipboard history found" ]] && copy_entry "$selected"
            ;;
        "$delete_option")
            delete_entry
            ;;
        "$clear_option")
            clear_history
            ;;
        "$edit_option")
            edit_entry
            ;;
        "$view_option")
            view_entry
            ;;
        "$separator"|"󰋻 No clipboard history found")
            exit 0
            ;;
        *)
            # Direct selection from history
            copy_entry "$chosen"
            ;;
    esac
}

# Execute main function
main "$@"