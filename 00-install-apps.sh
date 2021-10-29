#!/bin/bash
## Install applications from flathub and flathub-beta. 
## Intended for Fedora Silverblue and openSUSE MicroOS or Clear Linux
set -ex

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

install_flatpak_remote () {
    flatpak remote-add --if-not-exists $1 $2

    # TODO: Verify that the remote is setup
    # /var/lib/flatpak/repo/flathub.trustedkeys.gpg
    if [ ! -f "/var/lib/flatpak/repo/$1.trustedkeys.gpg" ]; then
        echo "Unable to verify public key"
        return 1
    fi
    return 0
}

is_ostree_idle () {
    # TODO: There's probably a cleaner way to do this.
    return $(rpm-ostree status| grep ^State | grep idle > /dev/null)
}


install_flatpak_remote flathub https://flathub.org/repo/flathub.flatpakrepo

# TODO: Prompt to enable beta repo?
install_flatpak_remote flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo


# TODO: This will fail if there are no applications to install, i.e., an empty list
## Ignore a line if it starts with # so you can leave yourself notes
grep -vE '^#' applications.list | xargs sudo /usr/bin/flatpak install flathub --assumeyes --noninteractive
grep -vE '^#' applications-beta.list | xargs sudo /usr/bin/flatpak install flathub-beta --assumeyes --noninteractive

# TODO: Maybe only do this if the file doesn't exist, or it does but it's diff than our file?
sudo cp ./files/flatpak-automatic.service /etc/systemd/system
sudo cp ./files/flatpak-automatic.timer /etc/systemd/system
sudo cp ./files/rpm-ostreed.conf /etc/

systemctl daemon-reload
systemctl enable /etc/systemd/system/flatpak-automatic.timer


# TODO: This fails if we're re-running the script and the override is already in place
## Remove Firefox from the base image, we're using the upstream flatpak instead

# Hack: using || true to suffocate an error if an override already exists.
# there should be a better way to do this.
while ! is_ostree_idle; do
    echo "Waiting for rpm-ostree..."
    sleep 5
done

rpm-ostree override remove firefox || true

# + rpm-ostree override remove firefox
# error: Transaction in progress: upgrade (download only)
#  You can cancel the current transaction with `rpm-ostree cancel`

# $ rpm-ostree status
# State: busy

## Add

# TODO: pull these from an external list?


rpm-ostree --idempotent install gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-gamemode gnome-shell-extension-frippery-move-clock gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect libratbag-ratbagd gnome-tweaks


# + rpm-ostree install gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-gamemode gnome-shell-extension-frippery-move-clock gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect libratbag-ratbagd gnome-tweaks
# error: Timeout was reached


echo "You should reboot!"

exit 0;

