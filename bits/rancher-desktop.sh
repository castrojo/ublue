#!/bin/bash
# Install Rancher Desktop AppImage
set -u

# Parameters
APP_IMAGE_DIR=$HOME/.local/bin
APP_NAME=rancher-desktop
APP_IMAGE_FULL_PATH=$APP_IMAGE_DIR/$APP_NAME.AppImage
APP_IMAGE_SOURCE=https://download.opensuse.org/repositories/isv:/Rancher:/stable/AppImage/rancher-desktop-latest-x86_64.AppImage
DESKTOP_FILE_DIR=$HOME/.local/share/applications

# Determine the path of the executing BASH script
BITS_DIR="$(dirname "${BASH_SOURCE[0]}")"
BITS_DIR="$(realpath "${BITS_DIR}")"

# Disclaimer
echo "This profile will install or update the Rancher Desktop AppImage"
echo ""
echo "Press any key to continue, or control-c to exit"
echo ""
read -n1 -s

# Create Backup of existing AppImage
if test -f "$APP_IMAGE_FULL_PATH"; then
    echo "Found existing Rancher Desktop AppImage"
    echo "For easy rollback we will create a backup under $APP_IMAGE_FULL_PATH.bak"
    echo ""
    # Remove old Backup
    if test -f "$APP_IMAGE_FULL_PATH.bak"; then
        echo "Removing AppImage backup $APP_IMAGE_FULL_PATH.bak"
        echo ""
        rm -f $APP_IMAGE_FULL_PATH.bak
    fi
    # Create new backup
    echo "Creating AppImage backup $APP_IMAGE_FULL_PATH.bak"
    echo ""
    mv $APP_IMAGE_FULL_PATH $APP_IMAGE_FULL_PATH.bak
fi

# Download AppImage
echo "Downloading AppImage from $APP_IMAGE_SOURCE to $APP_IMAGE_FULL_PATH"
echo ""
wget -O $APP_IMAGE_FULL_PATH $APP_IMAGE_SOURCE

# Set correct permission
echo "Make AppImage executable"
echo ""
chmod +x $APP_IMAGE_FULL_PATH 

# Create .desktop entry
if test -f "$DESKTOP_FILE_DIR/$APP_NAME.desktop"; then
    echo "Desktop entry $DESKTOP_FILE_DIR/$APP_NAME.desktop already exists"
    echo ""
else
    echo "Creating Desktop entry $DESKTOP_FILE_DIR/$APP_NAME.desktop"
    echo ""
    cd $BITS_DIR
    cp ../files/$APP_NAME.desktop $DESKTOP_FILE_DIR/$APP_NAME.desktop
fi

# Configure docker context
# Set environment variable for fish
if [ ~/.config/fish/config.fish ] && ! grep -Fq "DOCKER_CONTEXT" ~/.config/fish/fish_variables; then
    echo "Configuring environment variable 'DOCKER_CONTEXT' for fish..."
    fish -c 'set -Ux DOCKER_CONTEXT "rancher-desktop"'
fi

# Set environment variable for zsh
if [ -f ~/.zshrc ] && ! grep -Fq "DOCKER_CONTEXT" ~/.zshrc; then
    echo "Configuring environment variable 'DOCKER_CONTEXT' for zsh..."
    echo "" >> ~/.zshrc
    echo "# Load docker context for rancher-desktop" >> ~/.zshrc
    echo 'export DOCKER_CONTEXT="rancher-desktop"' >> ~/.zshrc
fi

# Set environment variable for bash
if [ -f ~/.bashrc ] && ! grep -Fq "DOCKER_CONTEXT" ~/.bashrc; then
    echo "Configuring environment variable 'DOCKER_CONTEXT' for bash..."
    echo "" >> ~/.bashrc
    echo "# Load docker context for rancher-desktop" >> ~/.bashrc
    echo 'export DOCKER_CONTEXT="rancher-desktop"' >> ~/.bashrc
fi
