#!/bin/bash
## Install a base set of bits to mimic the Ubuntu experience
## Intended for Fedora Silverblue and openSUSE MicroOS or Clear Linux
set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

BITS=./bits
source $BITS/common

echo "Enabling FlatHub.."
flatpak remote-modify --enable flathub
echo "Installing Flatpak(s)..."
flatpak_install_remote flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak_install flathub applications.list

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

if rpm-ostree override remove firefox firefox-langpacks > /dev/null; then
    echo "Removed Firefox from base layer."
fi

# --idempotent seems to fix running this multiple times
echo "Installing layered packages..."
cat layered-packages.list | rpm-ostree --idempotent install `xargs`

echo "You should reboot!"
exit 0;
