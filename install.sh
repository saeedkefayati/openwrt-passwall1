#!/bin/sh
# =============================
# Passwall v1 Installer
# =============================

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

REPO_URL="https://github.com/saeedkefayati/passwall1.git"

info "Step 1: Checking prerequisites..."
check_command git || error "Git is required. Please install it first."
check_command git-http || error "git-http is required. Please install it."

info "Step 2: Clone or update repository..."
cd /root
if [ ! -d "$PASSWALL_INSTALL_DIR" ]; then
    info "Repository not found. Cloning..."
    git clone "$REPO_URL"
else
    info "Repository exists. Pulling latest..."
    cd "$PASSWALL_INSTALL_DIR" || error "Cannot enter $PASSWALL_INSTALL_DIR"
    git reset --hard
    git clean -fd
    git pull || error "Failed to update repository."
fi

cd "$PASSWALL_INSTALL_DIR" || error "Cannot enter $PASSWALL_INSTALL_DIR"

info "Step 3: Grant execute permissions to all .sh files..."
find "$PASSWALL_INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

info "Step 4: Create or Update CLI shortcut..."
cat <<'EOF' > "$SHORTCUT"
#!/bin/sh
REPO_DIR="$PASSWALL_BIN_DIR"
cd "$REPO_DIR"
git pull
./main.sh
EOF
chmod +x "$PASSWALL_BIN_DIR"
info "Shortcut ready: run '${PASSWALL_COMMAND}' from anywhere."

info "Step 5: Launching main script..."
./main.sh
