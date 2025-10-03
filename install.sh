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
    git pull
fi

cd "$REPO_DIR"
chmod +x main.sh modules/*.sh utils/*.sh

if [ ! -f "$SHORTCUT" ]; then
    echo "Creating shortcut command $SHORTCUT..."
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

echo "Launching main script..."
./main.sh