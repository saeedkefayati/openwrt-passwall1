#!/bin/sh
# =============================
# Passwall v1 Installer
# =============================

REPO_URL="https://github.com/saeedkefayati/passwall1.git"
TARGET_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"

info "Step 1: Checking prerequisites..."
check_command git

info "Step 2: Clone or update repository..."
if [ ! -d "$TARGET_DIR" ]; then
    git clone "$REPO_URL" "$TARGET_DIR" || { echo "[ERROR] Failed to clone repo"; exit 1; }
else
    git -C "$TARGET_DIR" reset --hard
    git -C "$TARGET_DIR" clean -fd
    git -C "$TARGET_DIR" pull || { echo "[ERROR] Failed to update repo"; exit 1; }
fi

BASE_DIR="$TARGET_DIR"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

info "Step 3: Grant execute permissions to all .sh files..."
find "$BASE_DIR" -type f -name "*.sh" -exec chmod +x {} \;

info "Step 4: Create CLI shortcut..."
cat <<EOF > "$PASSWALL_BIN_DIR"
#!/bin/sh
cd "$BASE_DIR"
git pull
exec ./main.sh
EOF
chmod +x "$PASSWALL_BIN_DIR"

info "Shortcut ready: run '${PASSWALL_COMMAND}' from anywhere."

info "Step 5: Passwall is ready. Run it anytime using:"
"$PASSWALL_COMMAND"
