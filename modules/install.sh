#!/bin/sh

set -euo pipefail

#---------------------------------------
# Helper functions
#---------------------------------------
info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

check_command() {
  command -v "$1" >/dev/null 2>&1 || error "Required command '$1' not found"
}

#---------------------------------------
# Step 0: Pre-checks
#---------------------------------------
info "Checking required commands..."
check_command opkg
check_command wget
check_command uci

#---------------------------------------
# Step 1: Add Passwall GPG key
#---------------------------------------
add_key() {
  info "Adding Passwall GPG key..."
  if ! opkg-key list | grep -q passwall; then
    wget -O /tmp/passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
    opkg-key add /tmp/passwall.pub
  else
    info "GPG key already exists, skipping."
  fi
}

#---------------------------------------
# Step 2: Detect release & architecture
#---------------------------------------
detect_system() {
  info "Detecting OpenWrt release and architecture..."
  [ -f /etc/openwrt_release ] || error "/etc/openwrt_release not found!"
  . /etc/openwrt_release
  RELEASE=${DISTRIB_RELEASE%.*}
  ARCH=$DISTRIB_ARCH
  info "Detected OpenWrt $RELEASE on $ARCH"
}

#---------------------------------------
# Step 3: Add Passwall repositories
#---------------------------------------
add_feeds() {
  info "Adding Passwall v1 repositories..."

  [ -n "${RELEASE:-}" ] || error "RELEASE variable is not set. Run detect_system first."
  [ -n "${ARCH:-}" ] || error "ARCH variable is not set. Run detect_system first."

  FEEDS=("passwall_packages" "passwall_luci")

  for feed in "${FEEDS[@]}"; do
    if grep -q "$feed" /etc/opkg/customfeeds.conf; then
      info "Feed $feed already exists, skipping."
    else
      echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$RELEASE/$ARCH/$feed" >> /etc/opkg/customfeeds.conf
      info "Added feed $feed"
    fi
  done
}

#---------------------------------------
# Step 4: Update package lists
#---------------------------------------
update_opkg() {
  info "Updating package lists..."
  opkg update || error "Failed to update package lists"
}

#---------------------------------------
# Step 5: Install Passwall v1
#---------------------------------------
install_pkg() {
  info "Installing Passwall v1..."
  if opkg list-installed | grep -q luci-app-passwall; then
    info "Passwall already installed, skipping."
  else
    opkg install luci-app-passwall || error "Failed to install Passwall"
  fi
}

#---------------------------------------
# Step 6: Enable and start service
#---------------------------------------
enable_service() {
  info "Enabling and starting Passwall..."
  uci set passwall.@global[0].enabled='1'
  uci commit passwall
  /etc/init.d/passwall enable
  /etc/init.d/passwall restart
}

#---------------------------------------
# Main execution
#---------------------------------------
install_passwall(){
    add_key
    detect_system
    add_feeds
    update_opkg
    install_pkg
    enable_service
    info "✅ Passwall v1 installation completed successfully!"
}

