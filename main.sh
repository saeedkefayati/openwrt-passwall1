#!/bin/sh

# =============================
# Passwall v1 Main Script
# =============================

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

# -----------------------------
# Load Modules
# -----------------------------
for action in install update uninstall start stop restart enable disable exit; do
    [ -f "./modules/$action.sh" ] && . "./modules/$action.sh"
done

# -----------------------------
# Load Config
# -----------------------------
CONFIG_FILE="./config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    echo "❌ Config file not found!"
    exit 1
fi

# -----------------------------
# Function: Clear Terminal
# -----------------------------
clear_terminal() {
    if command -v printf >/dev/null 2>&1; then
        printf "\033c"
    elif command -v clear >/dev/null 2>&1; then
        clear
    elif command -v reset >/dev/null 2>&1; then
        reset
    else
        echo "No method to clear terminal available"
    fi
}

# -----------------------------
# Function: Show Banner
# -----------------------------
show_banner() {
echo "-------------------------------------------------"
echo " _____ _____ _____ _____ _ _ _ _____ __    __    "
echo "|  _  |  _  |   __|   __| | | |  _  |  |  |  |   "
echo "|   __|     |__   |__   | | | |     |  |__|  |__ "
echo "|__|  |__|__|_____|_____|_____|__|__|_____|_____|"
echo "                                                 "
echo "             PASSWALL v1 MANAGEMENT              "
echo "-------------------------------------------------"
echo "         now you can passwall1 command           "
echo "-------------------------------------------------"
}

# -----------------------------
# Function: Show Core Status
# -----------------------------
show_core_status() {
    echo "              Core Component Status              "

    CONFIG_FILE="./config.cfg"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ Config file not found!"
        echo "-------------------------------------------------"
        return
    fi

    grep -E '^SERVICE_[0-9]+' "$CONFIG_FILE" | while IFS= read -r line; do
        value=$(echo "$line" | cut -d'=' -f2- | tr -d '"')
        name=$(echo "$value" | cut -d'|' -f1)
        path=$(echo "$value" | cut -d'|' -f2)
        
        if [ -x "$path" ] || command -v "$path" >/dev/null 2>&1; then
            if echo "$path" | grep -q "/init.d/"; then
                if "$path" status >/dev/null 2>&1; then
                    status="${GREEN}Running${NC}"
                else
                    status="${YELLOW}Stopped${NC}"
                fi
            else
                base_proc=$(basename "$path")
                if pgrep -x "$base_proc" >/dev/null 2>&1; then
                    status="${GREEN}Running${NC}"
                else
                    status="${YELLOW}Stopped${NC}"
                fi
            fi
        else
            status="${RED}Not Installed${NC}"
        fi
        
        printf "%-12s : %b\n" "$name" "$status"
    done

    echo "-------------------------------------------------"
}


# -----------------------------
# Main Menu Loop
# -----------------------------
while true; do
    clear_terminal
    show_banner
    show_core_status

    echo "Please select an operation for Passwall v1:"

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
            echo "❌ Function '$action_function' is not defined!"
            sleep 2
        fi
    else
        echo "❌ Invalid choice! Please try again."
        sleep 2
    fi
done