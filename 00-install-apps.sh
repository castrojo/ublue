#!/bin/bash
## Install a base set of bits to mimic the Ubuntu experience
## Intended for Fedora Silverblue and openSUSE MicroOS or Clear Linux
set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

BITS=./bits
source $BITS/common

echo "Installing Flatpak(s)..."
flatpak_install_remote flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak_install flathub applications.list

read -n 1 -p "Do you wish to use Flathub beta? (Y/n) " beta
echo ""
case $beta in
    [Yy]* ) 
        flatpak_install_remote flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
        flatpak_install flathub-beta applications-beta.list
esac

# Configure Flatpak automatic upgrades
source $BITS/flatpak_automatic_updates

# Anonymously count the machine https://coreos.github.io/rpm-ostree/countme/
# Swap this out if you never want to be counted:
#
# systemctl mask --now rpm-ostree-countme.timer
#

systemctl enable rpm-ostree-countme.timer

echo "Checking base layer..."
while ! is_ostree_idle; do
    echo "Waiting for rpm-ostree..."
    sleep 5
done

if rpm-ostree override remove firefox > /dev/null; then
    echo "Removed Firefox from base layer."
fi

# TODO: pull these from an external list?
# --idempotent seems to fix running this multiple times
echo "Installing layered packages..."
rpm-ostree --idempotent install \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-sound-output-device-chooser \
    gnome-shell-extension-gamemode \
    gnome-shell-extension-frippery-move-clock \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-gsconnect \
    libratbag-ratbagd \
    gnome-tweaks \
    distrobox

echo "You should reboot!"
exit 0;

