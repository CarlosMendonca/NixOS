# NixOS Configuration Repo

My NixOS configuration repo. Important notes: I don't know what I'm doing, I'm learning from others, and if you want to learn from this repo, make sure this is one of many data points in your learning journey.

## Layout

Repo is organized around the hosts that get configured:

* HyperV-NixOS: Hyper-V-based VM
* X299-NixOS: Intel desktop
* X13-NixOS: AMD-based laptop

## Usage (HyperV)

Start by creating a new gen 2 VM with 4GB of RAM or more and make sure it's connected to the local network. Disable Secure Boot and configure the VM to boot from the virtual optical drive mounting the latest minimal ISO image that you can download from https://nixos.org/download.html.

Upon boot, double check that network is working and elevate yourself:

```
$ sudo -i
```

Download this repo (or better yet, clone it and make your changes offline with your preferred IDE/code editor) and unzip it on your home directory:

```
$ curl -L https://github.com/CarlosMendonca/NixOS/archive/refs/heads/main.zip -O main.zip
$ unzip main.zip
```

Parition the disk however you want, but there are simple instructions on the [NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning). You can also just execute the following script to automate this:

```
$ cd ~/NixOS-main
$ chmod +x scripts/setup-HyperV-NixOS.sh
$ ./scripts/setup-HyperV-NixOS.sh
```

If you want to check that the flake is working, you can run the check command (the `--experimental-features` may not be required in the future):

```
$ nix flake check --experimental-features 'nix-command flakes'
```

The outptus available on this flake are the pre-configured machines references by their hostnames. To get a sense of the outputs available on this flake, run the show command:

```
$ nix flake show --experimental-features 'nix-command flakes'
```

To install this flake, simply run the nix-install command while specifying the path to the flake (current dir, in this case) and which specific output (the machine hostname, in this case):

```
$ nixos-install --flake .#HyperV-NixOS
```

If everything went well, you can `reboot now` to boot from the disk. Going forward, you should be able to remote login via ssh provided that you configured the public key on the `users/<username>.nix` file.

## Getting Started (bare metal)

From the miminal ISO image, configure Wi-Fi:
```
$ sudo -i
$ systemctl start wpa_supplicant
$ wpa_cli
```

From `wpa_cli` do:
```
> add_network
> set_network 0 ssid "SSID"
> set_network 0 psk "password"
> enable_network 0
> quit
```

Partition the disk and leave the Windows boot partition (`SYSTEM`) alone.

Mount partitions.

Install with:
```
$ nixos-install --flake .#X13-NixOS
```

Set the password for user `carlos` with:
```
$ nixos-enter --root /mnt -c "passwd carlos"
$ reboot now
```

## TO-DOs

* Expand to Darwin
* Implement statix
* Secrets
* Disk encryption
* Hibernation
* Overlays, to modify packages if necessary
* Terminal and vscode themes
* nixfmt

### DONE
* Gnome keybindings for `show-screenshot-ui=['<Shift><Super>s']`, see https://discourse.nixos.org/t/nixos-options-to-configure-gnome-keyboard-shortcuts/7275
* Gnome fractional scaling, see https://discourse.nixos.org/t/how-to-set-fractional-scaling-via-nix-configuration-for-gnome-wayland/56774
* GDM and Gnome wallpapers 
* Flakes
* home-manager