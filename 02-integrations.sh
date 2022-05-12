# Integrations
# Stuff that works but probably needs a cleaner way to install

# Wallpaper
#
# Set a community wallpaper
set -eux
mkdir -p /var/home/$USER/.local/share/backgrounds

# A picture of the Lagoon Nebula by Charles Bonafilia
# It captures the mix of blue and orange, a nice mix of two different distributions 
cp ./files/charles.bonafilia.lagoon.nebula.jpg /var/home/$USER/.local/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri file:///var/home/$USER/.local/share/backgrounds/charles.bonafilia.lagoon.nebula.jpg
gsettings set org.gnome.desktop.background picture-options "stretched"

# Val's wallpaper
cp ./files/silvermorning.jpg /var/home/$USER/.local/share/backgrounds/
# Uncomment the next line to use this one as the default
#gsettings set org.gnome.desktop.background picture-uri file:///var/home/$USER/.local/share/backgrounds/silvermorning.jpg

# Fonts
#
# NerdFonts are basically fonts with a more rich set of emojis embeded
mkdir -p ~/.local/share/fonts
curl -sfLo "$HOME/.local/share/fonts/Ubuntu Mono Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf
curl -sfLo "$HOME/.local/share/fonts/Ubuntu Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Ubuntu/Regular/complete/Ubuntu%20Nerd%20Font%20Complete.ttf
cp -R files/fonts/ubuntu-font-family/*.ttf $HOME/.local/share/fonts/
# Flush font cache
fc-cache

# Get current profile for terminal, and update the font
current_profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -n1)
# TODO(mc): We /could/ prompt the user if they want to keep the current font, use Ubuntu Mono, or Ubuntu Mono Nerd Font?
dconf write /org/gnome/terminal/legacy/profiles:/${current_profile}use-system-font false
dconf write /org/gnome/terminal/legacy/profiles:/${current_profile}font "'UbuntuMono Nerd Font 14'"

# Make distrobox images and shortcuts
# Thanks @89luca89
# This isn't idempotent!
# So if you mess this up run `dconf reset -f /org/gnome/terminal/legacy/profiles:/`
# to reset the profiles back to default

distrobox-create -Y -i public.ecr.aws/ubuntu/ubuntu:22.04 -n ubuntu-toolbox-22
distrobox-create -Y -i registry.fedoraproject.org/fedora-toolbox:36 --name fedora-toolbox-36
./bits/distrobox-terminal-profile.sh -n ubuntu-toolbox-22 -c ubuntu-toolbox-22 -s "<Primary><Alt>u" 
./bits/distrobox-terminal-profile.sh -n fedora-toolbox-36 -c fedora-toolbox-36 -s "<Primary><Alt>f" 
