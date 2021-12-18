# ublue - Fedora Silverblue for Ubuntu Users

TLDR: I've been using Ubuntu since 2004, however I want a [modern image based desktop](https://blog.verbum.org/2020/08/22/immutable-%E2%86%92-reprovisionable-anti-hysteresis/).
Can I have my cake and eat it too?
This is not a new distribution (whew!), just a different set of defaults and apps scripted up, with a dash of container goodies so can still also use Ubuntu. 

The intended audience are cloud leaning developers who use Linux desktops, the niche of the niche.
Realistically I don't want to maintain this longer than I have to, this is a crutch that I need and then at some point I'll end up on the default desktop.
The cloud image I'll need until I retire because old habits die hard and it's good. Let's open our minds and do a mashup ...

## Scope

This is a proof-of-concept, ideally it's enough to get gears turning and starting conversations, it is by no means a a proper implementation. 
This POC is using Silverblue, but do check out [openSUSE's MicroOS](https://microos.opensuse.org/), alternative implementations of similar ideas is always a good idea. 

![Screenshot from 2021-11-06 16-06-50](https://user-images.githubusercontent.com/1264109/140622498-81d00c9a-fa59-4ea0-9393-7d33511d59a3.png)

If you want a more in depth view of what's happening, here's a [live video of me convincing Marco to try this](https://www.twitch.tv/videos/1193532435?t=00h22m32s) where we walk through the process, and [a tour with Wimpy](https://www.twitch.tv/videos/1196023856) where we go into more detail. 


## Features

:heart: :heart: :heart: WARNING: You are changing system defaults and pushing more into the container land than usual, please be respectful of our OSS family and be thoughtful before filing issues with either Fedora or the maintainers of the cloud images. Thanks! 

[@mrckndt's playbook](https://github.com/mrckndt/silverblue-playbook) comes with some nice features that fit with our flow:

- rpm-ostree is set to stage updates by default, so it just does it automatically.
- systemd service units to update all the flatpaks four times a day to match the update cadence of Ubuntu 

If this scares you then you're in the wrong place, if you're ready to not only burn the ships but torpedo them just to make sure we don't end up back in the old world, read on.
I have selected a default set of apps that I use that I notice lots of other people use, feel free to change them up, it's only a default:

- Keep Ubuntu app defaults and panel layout
  - While this is a mashup, let's respect Ubuntu's choices here by default, you know how to change stuff
  - But add apps that the intended audience love and need like vscode
- Optionally install:
  - Work apps -  zoom, slack, standard notes, signal, riot, mailspring
  - Fun apps - discord and Steam (Last release of flatpak fixed many of Steam's issues, it works much better now, try it)
  - A selection of browsers - Firefox, Brave, Chrome, Edge

I replaced the distro Firefox with the flatpak from upstream.
As per upstream Silverblue, you want your apps to be either in containers (where you install them via apt/dnf) and your desktop apps to come via flatpaks. 

Maintenance: The gotcha is you gotta shutdown/reboot your PC on the regular (whatever matches your workflow).
This is the price the UNIX gods demand for the removal of dpkg-reconfigure -a from your life.
I just shut it down at the end of each workday. Your reward is little to zero host OS maintenance. 

### Desktop Changes

While upstream GNOME is fine I've been using a seb128-built desktop for most of my adult life, it's my home, so I made some changes. 

- Enabled appindicators since so many apps need them and they're useful
- Sound output switcher so that you can easily switch between headphones and speakers as you go from meeting to meeting
- Move the clock to the right - familiarity
- Dash-to-dock - familiarity, I default it to the left ubuntu-like setup
- gsconnect - Phone integration with my desktop is useful

This is not a distro, so no patches, etc, basically looking at the default setup in Ubuntu and mirroring it in Fedora.
Tailor to your taste.
I decided to use the distro packages for these extensions instead of snagging them from extensions.gnome.org. Sometimes these break so I turn off the version checking.
YOLO not my circus, not my monkeys.

## Instructions

1. Install [Fedora Silverblue](https://docs.fedoraproject.org/en-US/fedora-silverblue/installation/) - probably don't do this on an existing system, just browse the repo and cherry pick if you're interested. 
1. On first boot, clone this repo: `git clone https://github.com/castrojo/ublue.git`
1. `cd ublue`
1. Edit the `applications.list` and `applications-beta.list` files to your liking.
1. `./00-install-apps.sh`
1. Get a coffee, and then reboot your computer (Important!)
   - Read the [toolbx documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/) and [README](https://github.com/containers/toolbox#readme), this will be useful later on. 
1. Run `./01-desktop.sh`
1. Optionally run the various scripts in `bits/` to install vscode, tailscale, and the ubuntu themes. We'll add little mini scripts here that are convenient for us.    

This script is terrible, it's written wrong, it doesn't check for anything properly, somethings still don't work, it basically a history file saved in a file.
Make something better, turn on github sponsors, and I'll be the first one sending you money on the regular.
Bring the cloud native dream to the people.
Just please, for the love of all that is holy, don't make another distro. 

To revert (and I mean, totally revert, you've been warned):

1. `./reset.sh` will reset the dconf database and ostree back to defaults and reboot you back to the stock Fedora experience. 

### Installing a toolbx

[Toolbx](https://github.com/containers/toolbox) is a neat tool that lets you run Linux distro cloud containers and then enter into them. 
It's in the process of being renamed from "toolbox" to "toolbx" so there's still some confusion as of now so just FYI.
The neater magic is it also transparently mounts your home directory for you, so we'll use an Ubuntu cloud image as our "userspace" in a terminal, similar to the how WSL does it.
This enables us to bring all our old scripts, dotfiles with us into this new workflow, we want to be more efficient not force reset your unix brain. 

By default doing `toolbox enter` will prompt you to create a Fedora container and take you inside.
This works fine and even installing graphical applications works!

`./99-build-images.sh` will build all of the images in the `images/` folder. Right now that includes:

| Distro | Release | Tag |
| ------ | ------- | --- |
| Arch   | latest  | arch:latest |
| Debian | bullseye | debian:bullseye |
| Debian | sid | debian:sid |
| Ubuntu | 18.04 | ubuntu:18.04 |
| Ubuntu | 20.04 | ubuntu:20.04 |
| Ubuntu | 22.04 | ubuntu:22.04 | 

To build a single image:

```bash
# Build Ubuntu 20.04
podman build -t ubuntu:20.04 -f images/ubuntu/20.04/Containerfile
```

One the images are built, you can create the container by tag, i.e.,

```bash
# Create a container named my-project
toolbox create --image ubuntu-20.04 -c my-project
```

You can then do `toolbox enter my-project` to go into the toolbx. 

If you set the toolboxes to launch on gnome-terminal execution you can have a more seamless experience:  

![toolbox](https://user-images.githubusercontent.com/1264109/139595535-fd1b8955-1b4a-4b70-ac9b-a4287c590cfb.png)

See the [Fedora documentation on keyboard shortcuts](https://docs.fedoraproject.org/en-US/quick-docs/proc_setting-key-shortcut/) to assign the terminals to shortcuts.
A rememberable one would be to keep `Ctrl-Alt-T` as the default non-toolbox terminal so you can do host things, and then `Ctrl-Alt-U` for the terminal that executes `toolbox enter ubuntu`.
The U stands for Ubuntu :smile:
Over time you may find yourself needing the host terminal less and less, expect to be very dependent on it if you're new. 

NOTE: Graphical versions of applications WORK in these containers, so if there's an app you need in Ubuntu that is not in Fedora or something then apt install it and fire it up! 

## VSCode and other developer notes

IDEs expect access to lots of stuff, so we compromise by overlaying vscode and directly adding the repo from upstream.
Check out [this post](https://discussion.fedoraproject.org/t/toolbox-and-visual-studio-code-remote-containers/27987) on setting up vscode with toolboxes, it might be useful for your workflow and is tracking issues with the various projects on what it would take to have vscode running as a flatpak but being able to directly access your toolboxes.

When you're inside a toolbx you might be confused that you can't run containers from inside the toolbx. You can `alias podman="flatpak-spawn --host podman"` to let you call podman so you can fire up containers while still in your familiar toolbx.
Thanks [Adam Kaplan](https://twitter.com/AdamBKaplan/status/1453059428677296130)!

This area needs work and is changing quickly!

## Todo

- https://github.com/containers/toolbox is crucial to this.
	- People have [PRed images for Ubuntu](https://github.com/containers/toolbox/pull/878) and [other distros](https://github.com/containers/toolbox/pull/861) but the default (and more reliable) toolbx experience is still Fedora. Over time I hope more distributions are adopted for this model, as it would be nice to have all the cloud-provider specific distros for people who need them, etc.
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
- Vallery Lancey for a
  [wallpaper](https://www.flickr.com/photos/timewitch/51521513914/). We felt that
  a wallpaper from one of the Ubuntu community wallpaper contest winners would
  give us the vibe we're looking for. Plus it's called Silver Morning, what a
  brilliant coincidence! 
  
# Fun Stats
  
  ![Alt](https://repobeats.axiom.co/api/embed/a8b746311ae37bead7de66fb5e735b146cefb0e8.svg "Repobeats analytics image")
