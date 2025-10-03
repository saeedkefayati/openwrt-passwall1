#!/bin/sh

REPO_DIR="/root/passwall1"
REPO_URL="https://github.com/saeedkefayati/passwall1.git"
SHORTCUT="/usr/bin/passwall1"

echo "Step 1: Installing git..."
opkg update
opkg install git

echo "Step 2: Clone or update repository..."
cd /root
if [ ! -d "$REPO_DIR" ]; then
    echo "Repository not found. Cloning..."
    git clone "$REPO_URL"
else
    echo "Repository exists. Pulling latest changes..."
    cd "$REPO_DIR"
    git reset --hard
    git clean -fd
    git pull
fi

cd "$REPO_DIR"

echo "Step 3: Granting execute permissions to all .sh files..."
find "$REPO_DIR" -type f -name "*.sh" -exec chmod +x {} \;

if [ ! -f "$SHORTCUT" ]; then
    echo "Step 4: Creating shortcut command $SHORTCUT..."
    cat <<'EOF' > "$SHORTCUT"
#!/bin/sh
REPO_DIR="/root/passwall1"
cd "$REPO_DIR"
git pull
./main.sh
EOF
    chmod +x "$SHORTCUT"
    echo "Shortcut command created. You can now run 'passwall1' from anywhere."
fi

echo "Step 5: Launching main script..."
./main.sh
