# Images for Toolbx

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

| Distribution | Release | Description |
| -------------| ------- | ----------- |
| Arch         | latest  | Arch Linux  |
| Debian       | sid     | Debian Sid  |
| Ubuntu       | 18.04   | Ubuntu 18.04 LTS |
| Ubuntu       | 20.04   | Ubuntu 20.04 LTS |