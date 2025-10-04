#!/bin/sh
#========================================
# exit.sh - Exit Passwall Main Menu
#========================================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/utils/common.sh"

exit_passwall() {
    info "Exiting Passwall v1..."
    exit 0
}

[ "${0##*/}" = "exit.sh" ] && exit_passwall
