echo "Add VSCode as an overlay"
# vscode via a flatpak that can access system/toolbox environments isn't a good UX yet, so we compromise here:

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
rpm-ostree install code

# If you need Docker in addition to podman
#rpm-ostree install moby-engine docker-compose

echo "You need to reboot!"