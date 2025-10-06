#!/bin/sh
# =============================
# Passwall v1 Installer
# =============================

# ================================
# Variables
# ================================
PASSWALL_INSTALL_DIR="/root/passwall1"
PASSWALL_BIN_DIR="/usr/bin/passwall1"
PASSWALL_COMMAND="passwall1"
REPO_URL="https://github.com/saeedkefayati/passwall1.git"

# ================================
# Step 1: Clone or update repository
# ================================
if [ ! -d "$PASSWALL_INSTALL_DIR" ]; then
    echo "[INFO] Cloning Passwall repository to $PASSWALL_INSTALL_DIR"
    git clone "$REPO_URL" "$PASSWALL_INSTALL_DIR" || { echo "[ERROR] Failed to clone repo"; exit 1; }
else
    echo "[INFO] Updating Passwall repository at $PASSWALL_INSTALL_DIR"
    git -C "$PASSWALL_INSTALL_DIR" reset --hard
    git -C "$PASSWALL_INSTALL_DIR" clean -fd
    git -C "$PASSWALL_INSTALL_DIR" pull || { echo "[ERROR] Failed to update repo"; exit 1; }
fi

# ================================
# Step 2: Grant execute permissions
# ================================
cd "$PASSWALL_INSTALL_DIR" || exit
find "$PASSWALL_INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

# ================================
# Step 3: Create CLI shortcut
# ================================
cat <<EOF > "$PASSWALL_BIN_DIR"
#!/bin/sh
REPO_DIR="$PASSWALL_INSTALL_DIR"
cd "\$REPO_DIR"
git pull
./main.sh
EOF
chmod +x "$PASSWALL_BIN_DIR"

echo "[INFO] Shortcut ready: run '$PASSWALL_COMMAND' from anywhere."

# ================================
# Step 4: Run main.sh
# ================================
echo "[INFO] Launching Passwall..."
./main.sh
