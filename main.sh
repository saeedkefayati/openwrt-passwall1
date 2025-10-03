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

    cores="passwall xray hysteria sing-box"

    for proc in $cores; do
        if [ -x "/usr/bin/$proc" ] || [ -x "/etc/init.d/$proc" ] || command -v "$proc" >/dev/null 2>&1; then
            if pgrep -x "$proc" >/dev/null 2>&1; then
                status="${GREEN}Running${NC}"
            else
                status="${YELLOW}Stopped${NC}"
            fi
        else
            status="${RED}Not Installed${NC}"
        fi

        # Capitalize
        first_char=$(echo "$proc" | cut -c1 | tr '[:lower:]' '[:upper:]')
        rest=$(echo "$proc" | cut -c2-)
        name="$first_char$rest"

        printf "%-12s : %b\n" "$name" "$status"
    done

    echo "-------------------------------------------------"
}

# -----------------------------
# Load all modules
# -----------------------------
for action in install update uninstall start stop restart enable disable; do
    [ -f "./modules/$action.sh" ] && . "./modules/$action.sh"
done

# -----------------------------
# Main Menu Loop
# -----------------------------
while true; do
    clear_terminal
    show_banner
    show_core_status

    echo "Please select an operation for Passwall v1:"
    echo "1) Install"
    echo "2) Update"
    echo "3) Uninstall"
    echo "4) Start"
    echo "5) Stop"
    echo "6) Restart"
    echo "7) Enable"
    echo "8) Disable"
    echo "9) Exit"

    read -p "Your choice: " op_choice

    case $op_choice in
        1) install_passwall ;;
        2) update_passwall ;;
        3) uninstall_passwall ;;
        4) start_passwall ;;
        5) stop_passwall ;;
        6) restart_passwall ;;
        7) enable_passwall ;;
        8) disable_passwall ;;
        9) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}Invalid choice! Please try again.${NC}"; sleep 2 ;;
    esac
done
