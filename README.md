## Fedora Silverblue for Ubuntu Expatriates

> **Warning**
> Fedora 37 will be the last version of this that I update, now that Fedora Silverblue supports building and booting from OCI images we will move to a cloud-native approach, hope to see you there! https://github.com/ublue-os

TLDR: I've been using Ubuntu since 2004, however I want a [modern image based desktop](https://blog.verbum.org/2020/08/22/immutable-%E2%86%92-reprovisionable-anti-hysteresis/).
Can I have my cake and eat it too?
This is not a new distribution (whew!), just a different set of defaults and apps scripted up, with a dash of container goodies so I can still also use Ubuntu. 

- Check out my guest appearance on the [Linux Downtime podcast](https://www.youtube.com/embed/CiyjZwd4Jrs) to see how I ended up here.
- Check out [awesome-immutable](https://castrojo.github.io/awesome-immutable/) for a general list of systems like this, there's different ways to do this.

The intended audience are cloud leaning developers who use Linux desktops, the niche of the niche.
However it's also a great gaming setup, traditional desktop, or whatever you're using now because it's also just Fedora.
If you're looking for a more reliable way to do this then [Jim Campbell's ansible playbook](https://github.com/j1mc/ansible-silverblue) is probably a good place to start.
Let's open our minds and do a mashup ... Here's a video tour, or keep scrolling down!

[![Video Overview](https://img.youtube.com/vi/PM5exNztbXE/maxresdefault.jpg)](https://youtu.be/PM5exNztbXE)

## Scope

This script is mostly trying to replicate Ubuntu's desktop and terminal experience. It changes the default GNOME to a more familiar Ubuntu dock setup, and then sets up the [Ubuntu Cloud Image](https://cloud-images.ubuntu.com/) as a [Distrobox](https://distrobox.privatedns.org/) so that your CLI experience remains the same as Ubuntu.

![Screenshot from 2021-11-06 16-06-50](https://user-images.githubusercontent.com/1264109/140622498-81d00c9a-fa59-4ea0-9393-7d33511d59a3.png)

If you want a more in depth view of what's happening I encourage you to take this apart and see what it's doing so you can learn about what I'm trying to do, and of course let me know about what you're building so we can celebrate. 

## Features

:heart: :heart: :heart: WARNING: You are changing system defaults and pushing more into the container land than usual, please be respectful of our OSS family and be thoughtful before filing issues with either Fedora or the maintainers of the cloud images. Thanks! 

After installing all the components, you will get:

- A Fedora Silverblue installation with an Ubuntu style desktop
  - Works on Fedora Silverblue 37 (Use an older release for 36)
- Fedora and Ubuntu userspaces provided by [distrobox](https://github.com/89luca89/distrobox)
  - Ctrl-alt-t will open a host terminal. (Use this for rpm-ostree and flatpak operations)
  - Ctrl-alt-u will open an Ubuntu container. (Use this for every day usage)
  - Ctrl-alt-f will open a Fedora container. (Use this for every day usage)
- All the proper multimedia and browser stuff installed so all media works out of the box
- rpm-ostree is set to stage updates by default, so it just does it automatically
- systemd service units to update all the flatpaks four times a day to match the update cadence of Ubuntu
- Keep Ubuntu app defaults and panel layout
  - While this is a mashup, let's respect Ubuntu's choices here by default, you know how to change stuff
  - But add apps that the intended audience love and need like vscode
- Optionally install:
  - Work apps -  Zoom, Slack, Standard Notes, Signal, Element, etc.
  - Fun apps - Discord and Steam (Last release of flatpak fixed many of Steam's issues, it works much better now, try it)
- The excellent [Extensions Manager](https://www.omgubuntu.co.uk/2022/01/gnome-extension-manager-app-easy-install) application is included to manage your GNOME extensions. Note that extensions.gnome.org won't work due to sandboxing, so this is a work around until all that is sorted in the future.

I replaced the distro Firefox with the flatpak from upstream.
As per upstream Silverblue, you want your apps to be either in containers (where you install them via apt/dnf) and your desktop apps to come via flatpaks. 

Maintenance: The gotcha is you gotta shutdown/reboot your PC on the regular (whatever matches your workflow).
This is the price the UNIX gods demand for the removal of `dpkg-reconfigure -a` from your life.
I just shut it down at the end of each workday. Your reward is little-to-zero host OS maintenance. 

### Desktop Changes

While upstream GNOME is fine I've been using a seb128-built desktop for most of my adult life, it's my home, so I made some changes. 

- Enabled appindicators since so many apps need them and they're useful
- Sound output switcher so that you can easily switch between headphones and speakers as you go from meeting to meeting
- Dash-to-dock - familiarity, I default it to the left ubuntu-like setup

This is not a distro, so no patches, etc, basically looking at the default setup in Ubuntu and mirroring it in Fedora.
Tailor to your taste.
I decided to use the distro packages for these extensions instead of snagging them from extensions.gnome.org. Sometimes these break so I turn off the version checking.
YOLO not my circus, not my monkeys.

## Instructions

1. Install [Fedora Silverblue](https://docs.fedoraproject.org/en-US/fedora-silverblue/installation/) - probably don't do this on an existing system, just browse the repo and cherry pick if you're interested.
2. Make sure you're up to date with `rpm-ostree update` and a reboot if necessary 
3. Clone this repo: `git clone https://github.com/castrojo/ublue.git`
4. `cd ublue`
5. Edit the `applications.list` file to your liking, I've chosen some decent defaults.
6. Run the first part of the script: `./00-install-apps.sh`
7. Get a coffee, and then reboot your computer (Important!)
   - Read the [distrobox documentation](https://distrobox.privatedns.org/) this will be useful later on. 
8. (Optional): Run `./01-desktop.sh`: This will change the desktop to a more Ubuntu setup, if you prefer vanilla GNOME don't run this.
9. (Optional): Run `./02-integrations.sh`: This will set up a wallpaper and the Ubuntu fonts, and set up the distroboxes and keyboard shortcuts
10. (Optional): Run the various scripts in `bits/` to install vscode, tailscale, and the Ubuntu themes. We'll add little mini scripts here that are convenient for us.    

Make something better, turn on GitHub sponsors, and I'll be the first one sending you money on the regular.
Bring the cloud native dream to the people.
Just please, for the love of all that is holy, don't make another distro. 

To revert (and I mean, totally revert, you've been warned):

1. `./reset.sh` will reset the dconf database and ostree back to defaults and reboot you back to the stock Fedora experience. 

### Distrobox, your new user space

We've included [distrobox](https://github.com/89luca89/distrobox). 
We'll use this to create our Ubuntu userspace:

    distrobox-create -i docker.io/library/ubuntu:22.04 -n ubuntu

You can use [any distribution image](https://github.com/89luca89/distrobox/blob/main/docs/compatibility.md#containers-distros) that is supported by distrobox (this is a bunch!) 
You can pull from any registry:

    distrobox-create -i public.ecr.aws/amazonlinux/amazonlinux:2022 -n amazon

Follow the instructions from distrobox to use your new userspace. Whichever distro you choose, you can use the "native" package manager in the box to install applications (including graphical ones), and we generally recommend doing most of your work in distrobox. You can also add the following config into your gnome-terminal to launch into your distrobox when you open a terminal: 

![Screenshot from 2022-02-02 17-06-11](https://user-images.githubusercontent.com/1264109/152247472-07d90f41-9601-4158-a10d-7bf046f55782.png)

Using any distribution as a container via your terminal is a very powerful feature as you can now use an install just about any package from any where. Check the [distrobox homepage](https://distrobox.privatedns.org/) for more info.

Note: Silverblue comes with [toolbx](https://github.com/containers/toolbox) by default, and it's still included. Check the `images/` directory for instructions on building your own images. Both projects use podman so it's a matter of taste, the base tech is the same. 

## VSCode and other developer notes
IDEs expect access to lots of stuff, we can either follow [this guide](https://github.com/89luca89/distrobox/blob/main/docs/posts/integrate_vscode_distrobox.md) to install it inside a Distrobox or using Flatpaks.
Alternatively we compromise by overlaying vscode and directly adding the repo from upstream.

This area needs work and is changing quickly!

### Acknowledgements

- "Marco" @mrckndt for the original playbook, check it out here: https://github.com/mrckndt/silverblue-playbook
- Colin Walters and the rest of the Fedora Silverblue Team
- Richard Brown, Dario Faggioli, and the rest of the OpenSUSE MicroOS team
- Josh Berkus, Wayne Witzel, Marco Ceppi, Martin Wimpress, Alan Pope, Justin Garrisson, Adam Israel, Andrew Hazen, Ray Strode, Aaron Lake, Luca Di Maio, and Bob Killen for idea bouncing, putting up with my rambling, rando dconf tips, etc
- Charles Bonafilia's picture of the [Lagoon Nebula](https://www.astrobin.com/02osf3/), a mix of orange and blue
- Vallery Lancey for a
  [wallpaper](https://www.flickr.com/photos/timewitch/51521513914/). We felt that
  a wallpaper from one of the Ubuntu community wallpaper contest winners would
  give us the vibe we're looking for. Plus it's called Silver Morning, what a
  brilliant coincidence! 
  
# Fun Stats
  
  ![Alt](https://repobeats.axiom.co/api/embed/a8b746311ae37bead7de66fb5e735b146cefb0e8.svg "Repobeats analytics image")
