#!/bin/bash
## Install applications from flathub and flathub-beta. 
## Intended for Fedora Silverblue and openSUSE MicroOS or Clear Linux
set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

PROFILES=./profiles
source $PROFILES/common

# http://mywiki.wooledge.org/BashFAQ/044
# progressbar() {
#     local max=$((${COLUMNS:-$(tput cols)} - 2)) in n i
#     while read -r in; do
#         n=$((max*in/100))
#         printf '\r['
#         for ((i=0; i<n; i++)); do printf =; done
#         for ((; i<max; i++)); do printf ' '; done
#         printf ']'
#     done
# }

flatpak_install () {
    # Test reading in the list of apps to install and create a progress bar
    mapfile -t applications < $2

    # Remove empty lines and commented out lines
    for i in ${!applications[@]};do
        name=$(echo -e "${applications[$i]}" | sed -e 's/[[:space:]]*$//')
        if [[ $name == "" || $name == \#* ]]; then
            unset applications[$i]
        fi 
    done

    n=${#applications[@]}
    echo "Installing $n applications from $1..."

    i=0
    for application in "${applications[@]}"; do
        # echo "$((100*(++i)/n))"
        /usr/bin/flatpak install $1 --assumeyes --noninteractive --or-update $application
    done
    # Temporarily disable progress bar to track down unbound variable
    # done | progressbar
}

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

# Configure FLatpak automatic upgrades
source $PROFILES/flatpak_automatic_updates

# echo "Configuring Flatpak automatic upgrades..."
# # TODO: Maybe only do this if the file doesn't exist, or it does but it's diff than our file?
# sudo cp ./files/flatpak-automatic.service /etc/systemd/system
# sudo cp ./files/flatpak-automatic.timer /etc/systemd/system
# sudo cp ./files/rpm-ostreed.conf /etc/

# systemctl daemon-reload
# systemctl enable /etc/systemd/system/flatpak-automatic.timer
# systemctl enable rpm-ostreed-automatic.timer

# TODO: This fails if we're re-running the script and the override is already in place
## Remove Firefox from the base image, we're using the upstream flatpak instead

# Hack: using || true to suffocate an error if an override already exists.
# there should be a better way to do this.
echo "Checking base layer..."
while ! is_ostree_idle; do
    echo "Waiting for rpm-ostree..."
    sleep 5
done

if [ $(rpm-ostree override remove firefox > /dev/null) ]; then
    echo "Removed Firefox from base layer."
fi

## Add

# TODO: pull these from an external list?
# --idempotent seems to fix running this multiple times
echo "Installing layered packages..."
rpm-ostree --idempotent install gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-gamemode gnome-shell-extension-frippery-move-clock gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect libratbag-ratbagd gnome-tweaks


echo "You should reboot!"

exit 0;

