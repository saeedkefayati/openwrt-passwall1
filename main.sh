#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

# -------------------------------
# Load all scripts
# -------------------------------
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "${SCRIPT_DIR}/config.cfg"
. "${SCRIPT_DIR}/utils/common.sh"
. "${SCRIPT_DIR}/modules/install.sh"
. "${SCRIPT_DIR}/modules/update.sh"
. "${SCRIPT_DIR}/modules/uninstall.sh"
. "${SCRIPT_DIR}/modules/start.sh"
. "${SCRIPT_DIR}/modules/stop.sh"
. "${SCRIPT_DIR}/modules/restart.sh"
. "${SCRIPT_DIR}/modules/enable.sh"
. "${SCRIPT_DIR}/modules/disable.sh"
. "${SCRIPT_DIR}/modules/exit.sh"

# -------------------------------
# Main menu loop
# -------------------------------
while true; do
    clear_terminal
    show_banner
    show_core_status

    printf "Select an operation for Passwall v1:"
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
        if command -v "$action_function" >/dev/null 2>&1; then
            $action_function
        else
            echo "[ERROR] Function '$action_function' is not defined!"
            sleep 1.5
        fi
    else
        echo "[ERROR] Invalid choice! Try again."
        sleep 1.5
    fi
done
