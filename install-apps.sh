#!/bin/bash
## Install applications from flathub and flathub-beta. 
## Intended for Fedora Silverblue and openSUSE MicroOS or Clear Linux
set -ex
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

## Ignore a line if it starts with # so you can leave yourself notes
grep -vE '^#' applications.list | xargs sudo /usr/bin/flatpak install flathub --assumeyes --noninteractive
grep -vE '^#' applications-beta.list | xargs sudo /usr/bin/flatpak install flathub-beta --assumeyes --noninteractive

sudo cp ./files/flatpak-automatic.service /etc/systemd/system
sudo cp ./files/flatpak-automatic.timer /etc/systemd/system
sudo cp ./files/rpm-ostreed.conf /etc/
systemctl daemon-reload
systemctl enable /etc/systemd/system/flatpak-automatic.timer

## Remove Firefox from the base image, we're using the upstream flatpak instead
rpm-ostree override remove firefox

## Add

rpm-ostree install gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-gamemode gnome-shell-extension-frippery-move-clock gnome-shell-extension-dash-to-dock gnome-shell-extension-gsconnect libratbag-ratbagd 

dconf write /org/gnome/shell/disable-extension-version-validation "true" #yolo
dconf write /org/gnome/shell/enabled-extensions "['appindicatorsupport@rgcjonas.gmail.com', 'dash-to-dock@micxgx.gmail.com', 'sound-output-device-chooser@kgshank.net', 'gsconnect@andyholmes.github.io', 'Move_Clock@rmy.pobox.com']"

./desktop.sh

echo "You should reboot!"
