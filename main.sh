#!/bin/bash

# Load all modules
for action in install update uninstall start stop restart enable disable; do
    source ./modules/$action.sh
done

# Operation menu
echo "Please select an operation for Passwall v1:"
echo "1) Install"
echo "2) Update"
echo "3) Uninstall"
echo "4) Start"
echo "5) Stop"
echo "6) Restart"
echo "7) Enable"
echo "8) Disable"
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
    *) echo "Invalid choice." ;;
esac
