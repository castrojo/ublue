# ublue - Fedora Silverblue for Ubuntu Users

TLDR: I've been using Ubuntu since 2004, however I want a modern [modern image based desktop](https://blog.verbum.org/2020/08/22/immutable-%E2%86%92-reprovisionable-anti-hysteresis/). Can I have my cake and eat it too? 

## Scope

This is a proof-of-concept, ideally it's enough to get gears turning and starting conversations, it is by no means a a proper implementation. 
This POC is using Silverblue, but do check out [openSUSE's MicroOS](https://microos.opensuse.org/), alternative implementations of similar ideas is always a good idea. 

## Features

[@mrckndt's playbook](https://github.com/mrckndt/silverblue-playbook) comes with some nice features that fit with our flow:

- rpm-ostree is set to stage updates by default, so it just does it automatically.
- systemd service units to update all the flatpaks by default once a day.

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

1. Install [Fedora Silverblue](https://docs.fedoraproject.org/en-US/fedora-silverblue/installation/) - probably don't do this on a lived in machine, just browse the repo and cherry pick
1. On first boot, clone this repo: `git clone https://github.com/castrojo/ublue.git`
1. `cd ublue`
1. `./00-install-apps.sh`
1. Get a coffee, and then reboot your computer (Important!)
1. Run `./01-desktop.sh`

This script is terrible, it's written wrong, it doesn't check for anything properly, somethings still don't work, it basically a history file saved in a file. Make something better, turn on github sponsors, and I'll be the first one sending you money on the regular. Bring the cloud native dream to the people. Just please, for the love of all that is holy, don't make another distro. 

To revert (and I mean, totally revert, you've been warned):

1. `dconf reset -f /`
1. `rpm-ostree reset` then reboot

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
- Josh Berkus, Wayne Witzel, Marco Ceppi, Martin Wimpress, Alan Pope, and Bob Killen for idea bouncing, putting up with my rambling, rando dconf tips, etc.
