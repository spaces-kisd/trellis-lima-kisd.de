#!/bin/bash
set -e

# 1. Configuration
# Define the exact URL
URL="https://github.com/lima-vm/lima/releases/download/v2.0.3/lima-2.0.3-Linux-x86_64.tar.gz"
FILENAME=$(basename "$URL")

# Define install paths (User Directory - No Root Needed)
INSTALL_BIN="$HOME/.local/bin"
INSTALL_SHARE="$HOME/.local/share/lima"

# 2. Check & Download
if [ ! -f "$FILENAME" ]; then
    echo "Downloading $FILENAME..."
    curl -L -O "$URL"
else
    echo "$FILENAME already exists. Skipping download."
fi

# 3. Create Directories
mkdir -p "$INSTALL_BIN"
mkdir -p "$INSTALL_SHARE"

# 4. Extract
echo "Extracting..."
mkdir -p lima-temp
tar -xvf "$FILENAME" -C lima-temp

# 5. Install Binary and Shared Files
echo "Installing limactl to $INSTALL_BIN..."
mv lima-temp/bin/limactl "$INSTALL_BIN/"

echo "Installing share files to $INSTALL_SHARE..."
# Copy contents safely, then remove temp
cp -r lima-temp/share/lima/* "$INSTALL_SHARE/" 2>/dev/null || mv lima-temp/share/lima/* "$INSTALL_SHARE/"

# Cleanup
rm -rf lima-temp

# 6. PATH Configuration (Critical for VS Code)
echo "--------------------------------------------------------"
echo "Installation successful."
echo "Checking your PATH configuration..."

# We check if the install path is currently in the PATH variable
if [[ ":$PATH:" != *":$INSTALL_BIN:"* ]]; then
    echo ""
    echo "⚠️  WARNING: $INSTALL_BIN is NOT in your current PATH."
    echo ""
    echo "To make this work in VS Code Tasks (and everywhere else),"
    echo "you must add it to your startup files."
    echo ""
    echo "Run the following commands to fix it:"
    echo ""

    # Check for Zsh (standard on macOS and many Linux distros now)
    if [ -n "$ZSH_VERSION" ] || [[ "$SHELL" == */zsh ]]; then
        echo "  # For Zsh (Recommended for VS Code support):"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshenv"
        echo ""
        echo "  # For interactive shells:"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
    else
        # Fallback for Bash
        echo "  # For Bash:"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
    fi
    echo ""
    echo "After running the commands above, RESTART VS Code completely."
else
    echo "✅ $INSTALL_BIN is already in your PATH."
fi
echo "--------------------------------------------------------"

# 7. Verification
# We use the full path to verify the binary works immediately
"$INSTALL_BIN/limactl" --version
