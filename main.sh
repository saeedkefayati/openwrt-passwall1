#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

CONFIG_FILE="./config.cfg"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Status script not found."
    exit 1
fi
. "$CONFIG_FILE"


COMMON_FILE="./utils/common.sh"
if [ ! -f "$COMMON_FILE" ]; then
    echo "Error: Network script not found."
    exit 1
fi
. "$COMMON_FILE"


# Load all module scripts
for action in install update uninstall start stop restart enable disable exit; do
    MODULE_PATH="./modules/$action.sh"
    [ -f "$MODULE_PATH" ] && . "$MODULE_PATH"
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
