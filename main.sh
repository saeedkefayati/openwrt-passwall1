#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

# -------------------------------
# Load all scripts
# -------------------------------
. "./config.cfg"
. "./utils/common.sh"
. "./modules/install.sh"
. "./modules/update.sh"
. "./modules/uninstall.sh"
. "./modules/start.sh"
. "./modules/stop.sh"
. "./modules/restart.sh"
. "./modules/enable.sh"
. "./modules/disable.sh"
. "./modules/exit.sh"

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
        if command -v "$action_function" >/dev/null 2>&1; then
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
