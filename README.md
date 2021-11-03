# ublue - Fedora Silverblue for Ubuntu Users

TLDR: I've been using Ubuntu since 2004, however I want a [modern image based desktop](https://blog.verbum.org/2020/08/22/immutable-%E2%86%92-reprovisionable-anti-hysteresis/). Can I have my cake and eat it too? This is not a new distribution (whew!), just a different set of defaults and apps scripted up, with a dash of container goodies so can still also use Ubuntu. 

## Scope

This is a proof-of-concept, ideally it's enough to get gears turning and starting conversations, it is by no means a a proper implementation. 
This POC is using Silverblue, but do check out [openSUSE's MicroOS](https://microos.opensuse.org/), alternative implementations of similar ideas is always a good idea. 

![Tada](https://user-images.githubusercontent.com/1264109/139602527-6f2135e5-a035-49e7-b716-2ed9e57dfc68.png)

If you want a more in depth view of what's happening, here's a [live video of me convincing Marco to try this](https://www.twitch.tv/videos/1193532435?t=00h22m32s) where we walk through the process. 


## Features

:heart: :heart: :heart: WARNING: You are changing system defaults and pushing more into the container land than usual, please be respectful of our OSS family and be thoughtful before filing issues with either Fedora or the maintainers of the cloud images. Thanks! 

[@mrckndt's playbook](https://github.com/mrckndt/silverblue-playbook) comes with some nice features that fit with our flow:

- rpm-ostree is set to stage updates by default, so it just does it automatically.
- systemd service units to update all the flatpaks four times a day to match the update cadence of Ubuntu 

If this scares you then you're in the wrong place, if you're ready to not only burn the ships but torpedo them just to make sure we don't end up back in the old world, read on. I have selected a default set of apps that I use that I notice lots of other people use, feel free to change them up, it's only a default:

- Work apps - vscode, zoom, slack, standard notes, signal, riot, mailspring
- Fun apps - discord, steam, and lutris
- A selection of browsers - Firefox, Brave, Chrome, Edge

I replaced the distro Firefox with the flatpak from upstream. As per upstream Silverblue, you want your apps to be either in containers (where you install them via apt/dnf) and your desktop apps to come via flatpaks. 

Maintenance: The gotcha is you gotta shutdown/reboot your PC on the regular (whatever matches your workflow). This is the price the UNIX gods demand for the removal of dpkg-reconfigure -a from your life. I just shut it down at the end of each workday. Your reward is little to zero host OS maintenance. 

### Desktop Changes

While upstream GNOME is fine I've been using a seb128-built desktop for most of my adult life, it's my home, so I made some changes. 

- Enabled appindicators since so many apps need them and they're useful
- Sound output switcher so that you can easily switch between headphones and speakers as you go from meeting to meeting
- Move the clock to the right - familiarity
- Dash-to-dock - familiarity, I default it to the left ubuntu-like setup
- gsconnect - Phone integration with my desktop is useful

This is not a distro, so no patches, etc, basically looking at the default setup in Ubuntu and mirroring it in Fedora. Tailor to your taste. I decided to use the distro packages for these extensions instead of snagging them from extensions.gnome.org. Sometimes these break so I turn off the version checking. YOLO not my mess I'm just dealing with it, seems to work. 

## Instructions

1. Install [Fedora Silverblue](https://docs.fedoraproject.org/en-US/fedora-silverblue/installation/) - probably don't do this on an existing system, just browse the repo and cherry pick if you're interested. 
1. On first boot, clone this repo: `git clone https://github.com/castrojo/ublue.git`
1. `cd ublue`
1. Edit the `applications.list` and `applications-beta.list` files to your liking.
1. `./00-install-apps.sh`
1. Get a coffee, and then reboot your computer (Important!)
   - Read the [toolbox documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/) and [README](https://github.com/containers/toolbox#readme), this will be useful later on. 
1. Run `./01-desktop.sh`
1. Optionally run `./02-workarounds.sh` for vscode, using this via flatpak has many limitations so we're layering them. Look in here if you need Docker in addition to podman, and the Yaru theme. 

This script is terrible, it's written wrong, it doesn't check for anything properly, somethings still don't work, it basically a history file saved in a file. Make something better, turn on github sponsors, and I'll be the first one sending you money on the regular. Bring the cloud native dream to the people. Just please, for the love of all that is holy, don't make another distro. 

To revert (and I mean, totally revert, you've been warned):

1. `./reset.sh` will reset the dconf database and ostree back to defaults and reboot you back to the stock Fedora experience. 

### Installing a toolbox

[Toolbox](https://github.com/containers/toolbox) is a neat tool that lets you run Linux distro cloud containers and then enter into them. The neater magic is it also transparently mounts your home directory for you, so we'll use an Ubuntu cloud image as our "userspace" in a terminal, similar to the how WSL does it. This enables us to bring all our old scripts, dotfiles with us into this new workflow, we want to be more efficient not force reset your unix brain. 

By default doing `toolbox enter` will prompt you to create a Fedora container and take you inside. This works fine and even installing graphical applications works! 

- `./files/build-debian-toolbox.sh` will build a bullseye container
- `./files/build-ubuntu-toolbox.sh` will build an ubuntu container, however this is broken.

@jmennius has kindly built a 20.04 container, thanks! Let's use that for now:

    toolbox create --image registry.hub.docker.com/jmennius/ubuntu-toolbox:20.04 ubuntu

You can then do `toolbox enter ubuntu` to go into the toolbox. Future versions of these scripts will build an image for you as part of the installation process so you can verify it and add custom packages. If you set the toolboxes to launch on gnome-terminal execution you can have a more seamless experience:  

![toolbox](https://user-images.githubusercontent.com/1264109/139595535-fd1b8955-1b4a-4b70-ac9b-a4287c590cfb.png)

See the [Fedora documentation on keyboard shortcuts](https://docs.fedoraproject.org/en-US/quick-docs/proc_setting-key-shortcut/) to assign the terminals to shortcuts. A rememberable one would be to keep `Ctrl-Alt-T` as the default non-toolbox terminal so you can do host things, and then `Ctrl-Alt-U` for the terminal that executes `toolbox enter ubuntu`. The U stands for Ubuntu :smile: Over time you may find yourself needing the host terminal less and less, expect to be very dependent on it if you're new. 

NOTE: Graphical versions of applications WORK in these containers, so if there's an app you need in Ubuntu that is not in Fedora or something then apt install it and fire it up! 

## Todo

- https://github.com/containers/toolbox is crucial to this.
	- People have [PRed images for Ubuntu](https://github.com/containers/toolbox/pull/878) and [other distros](https://github.com/containers/toolbox/pull/861) but the default (and more reliable) toolbox experience is still Fedora. Over time I hope more distributions are adopted for this model, as it would be nice to have all the cloud-provider specific distros for people who need them, etc.
  - Basically, have as many options as users can have on WSL. :D
- Still can't set ctrl-alt-t to open a terminal lol. 
- Martin Pitt [has a script](https://piware.de/gitweb/?p=bin.git;a=blob;f=build-debian-toolbox) for building your own Debian/Ubuntu images on the spot if you want to do it by hand. (This is what I'm using now)
- Speaking of, here's advanced mode, and entire developer workflow living in git that can be splatted onto a machine:
  - https://piware.de/post/2020-12-13-ostree-sway/


### Acknowledgements

- "Marco" @mrckndt for the original playbook, check it out here: https://github.com/mrckndt/silverblue-playbook
- Colin Walters and the rest of the Fedora Silverblue Team
- Richard Brown and the rest of the MicroOS team
- Josh Berkus, Wayne Witzel, Marco Ceppi, Martin Wimpress, Alan Pope, Justin Garrisson, Adam Israel, Aaron Lake, and Bob Killen for idea bouncing, putting up with my rambling, rando dconf tips, etc.
