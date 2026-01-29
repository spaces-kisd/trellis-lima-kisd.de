#!/bin/bash
set -e

# Define paths
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$BIN_DIR")"
VENV_DIR="$PROJECT_ROOT/.trellis/virtualenv"
REQUIREMENTS_FILE="$PROJECT_ROOT/requirements.txt"
GALAXY_FILE="$PROJECT_ROOT/galaxy.yml"

echo "🚀 Starting Trellis Setup..."

# 1. Create Virtual Environment
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating Python virtual environment in .trellis/virtualenv..."
    python3 -m venv "$VENV_DIR"
else
    echo "✅ Virtual environment already exists."
fi

# 2. Install Python Dependencies
echo "⬇️  Installing Python dependencies..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "⚠️  No requirements.txt found."
fi

# 3. Install Ansible Galaxy Roles
echo "⬇️  Installing Ansible Galaxy roles..."
if [ -f "$GALAXY_FILE" ]; then
    ansible-galaxy install -r "$GALAXY_FILE"
else
    echo "⚠️  No galaxy.yml found."
fi

echo "--------------------------------------------------------"
echo "✅ Setup complete!"
echo "You can now start your VM with:"
echo "  ./bin/lima start"
echo "--------------------------------------------------------"
