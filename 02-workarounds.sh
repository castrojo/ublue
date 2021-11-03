# Workarounds
# Stuff that works but probably needs a cleaner way to install

echo "Add VSCode as an overlay"
# vscode via a flatpak that can access system/toolbox environments isn't a good UX yet, so we compromise here:

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
rpm-ostree --idempotent install code

# If you need Docker in addition to podman
#rpm-ostree install moby-engine docker-compose

# Theme
# Theme infra is always changing so I just use the Fedora theme, uncomment
# this if you want the Ubuntu theme, default to light theme, but you can
# choose the dark theme 
#
echo "Adding the Ubuntu yaru theme"
rpm-ostree --idempotent install yaru-theme
gsettings set org.gnome.desktop.wm.preferences theme "Yaru"
#gsettings set org.gnome.desktop.wm.preferences theme "Yaru-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Yaru"
gsettings set org.gnome.desktop.interface icon-theme "Yaru"
gsettings set org.gnome.desktop.sound theme-name "Yaru"

# Wallpaper
# 
# Set a community wallpaper 
cp ./files/silvermorning.jpg /var/home/$USER/.local/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri file:///var/home/$USER/.local/share/backgrounds/silvermorning.jpg

echo "You need to reboot!"