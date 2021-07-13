#!/bin/bash
## Install applications from flathub and flathub-beta. 
## Intended for Fedora Silverblue and openSUSE MicroOS
set -ex
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

## Ignore a line if it starts with # so you can leave yourself notes
grep -vE '^#' applications.list | xargs sudo /usr/bin/flatpak install flathub --assumeyes --noninteractive
grep -vE '^#' applications-beta.list | xargs sudo /usr/bin/flatpak install flathub-beta --assumeyes --noninteractive

## Remove Firefox from the base image
# rpm-ostree override remove firefox
# echo "You should reboot!"