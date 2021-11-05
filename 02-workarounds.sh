# Workarounds
# Stuff that works but probably needs a cleaner way to install

# If you need Docker in addition to podman
#rpm-ostree install moby-engine docker-compose

# Wallpaper
# 
# Set a community wallpaper 
cp ./files/silvermorning.jpg /var/home/$USER/.local/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri file:///var/home/$USER/.local/share/backgrounds/silvermorning.jpg
