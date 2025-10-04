#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

# ================================
# Set BASE_DIR based on installation
# ================================
BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"

# ================================
# Ensure required files exist
# ================================
if [ ! -f "$BASE_DIR/utils/common.sh" ]; then
    echo "[ERROR] common.sh not found in $BASE_DIR/utils/"
    exit 1
fi

if [ ! -f "$BASE_DIR/config.cfg" ]; then
    echo "[ERROR] config.cfg not found in $BASE_DIR/"
    exit 1
fi

# ================================
# Source common functions and config
# ================================
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

# ================================
# Load modules
# ================================
for action in install update uninstall start stop restart enable disable exit; do
    MODULE_FILE="$BASE_DIR/modules/$action.sh"
    if [ -f "$MODULE_FILE" ]; then
        . "$MODULE_FILE"
    else
        echo "[WARN] Module file not found: $MODULE_FILE"
    fi
done

# ================================
# Main menu loop
# ================================
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
            error "Function '$action_function' is not defined!"
            sleep 2
        fi
    else
        error "Invalid choice! Try again." 0
        sleep 2
    fi
done
