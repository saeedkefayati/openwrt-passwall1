#!/bin/sh
# =============================
# Passwall v1 Installer
# =============================


TARGET_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"
PASSWALL_BIN_DIR="${PASSWALL_BIN_DIR:-/usr/bin/passwall1}"
PASSWALL_COMMAND="${PASSWALL_COMMAND:-passwall1}"
REPO_URL="https://github.com/saeedkefayati/passwall1.git"
TARGET_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"

echo "[INFO] Step 1: Checking prerequisites..."
command -v git >/dev/null 2>&1 || { echo "[ERROR] git is required"; exit 1; }

echo "[INFO] Step 2: Clone or update repository..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "[INFO] Cloning Passwall repository to $TARGET_DIR"
    git clone "$REPO_URL" "$TARGET_DIR" || { echo "[ERROR] Failed to clone repo"; exit 1; }
else
    echo "[INFO] Updating Passwall repository at $TARGET_DIR"
    git -C "$TARGET_DIR" reset --hard
    git -C "$TARGET_DIR" clean -fd
    git -C "$TARGET_DIR" pull || { echo "[ERROR] Failed to update repo"; exit 1; }
fi

BASE_DIR="$TARGET_DIR"

if [ ! -f "$BASE_DIR/utils/common.sh" ] || [ ! -f "$BASE_DIR/config.cfg" ]; then
    echo "[ERROR] Required files not found in $BASE_DIR"
    exit 1
fi
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

echo "[INFO] Step 3: Grant execute permissions to all .sh files..."
find "$BASE_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "[INFO] Create CLI shortcut..."
cat <<EOF > "$PASSWALL_BIN_DIR"
#!/bin/sh
cd "$TARGET_DIR" || exit 1
git pull
exec ./main.sh
EOF
chmod +x "$PASSWALL_BIN_DIR"

echo "[INFO] Shortcut ready: run '$PASSWALL_COMMAND' from anywhere."

echo "[INFO] Passwall is ready. Run it anytime using:"
"$PASSWALL_COMMAND"
