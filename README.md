# .nix

Nix configuration for my personal machines. Manages dev environments for NixOS and Darwin.

## Prerequisites

Requires a system-level [NixOS](https://nixos.org/download.html) or [nix-darwin](https://github.com/LnL7/nix-darwin) installation. `nix-env` alone is not enough.

## Install System (Global)

```console
$ git clone https://github.com/miangraham/dot-nix.git ~/.nix
$ cd ~/.nix
$ vim box/somebox/default.nix
$ ln -s box/somebox/default.nix ./configuration.nix
$ ./rebuild_system.sh
```

## Install Home (NixOS only)

```console
$ cd ~/.nix
$ ./install_home.sh
```
