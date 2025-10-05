#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

# -------------------------------
# Define base directory
# -------------------------------
BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"

# -------------------------------
# Load config
# -------------------------------
CONFIG_FILE="$BASE_DIR/config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    echo "❌ Config file not found at $CONFIG_FILE"
    exit 1
fi

# -------------------------------
# Load common functions
# -------------------------------
COMMON_FILE="$BASE_DIR/utils/common.sh"
if [ -f "$COMMON_FILE" ]; then
    . "$COMMON_FILE"
else
    echo "❌ Common functions file not found at $COMMON_FILE"
    exit 1
fi

# -------------------------------
# Load all module scripts
# -------------------------------
for action in install update uninstall start stop restart enable disable exit; do
    [ -f "$BASE_DIR/modules/$action.sh" ] && . "$BASE_DIR/modules/$action.sh"
done

# -------------------------------
# Main menu loop
# -------------------------------
while true; do
    clear_terminal
    show_banner
    show_core_status

    echo "Select an operation for Passwall v1:"
    i=1
    while true; do
        eval entry=\$MENU_${i}
        [ -z "$entry" ] && break
        menu_text=$(echo "$entry" | cut -d'|' -f1)
        echo "${i}) $menu_text"
        i=$((i+1))
    done

    printf "Your choice: "
    read op_choice
    eval selected=\$MENU_${op_choice}

    if [ -n "$selected" ]; then
        action_function=$(echo "$selected" | cut -d'|' -f2)
        if [ "$(type -t $action_function)" = "function" ]; then
            $action_function
        else
            echo "[ERROR] Function '$action_function' is not defined!"
            sleep 2
        fi
    else
        echo "[ERROR] Invalid choice! Try again."
        sleep 2
    fi
done
