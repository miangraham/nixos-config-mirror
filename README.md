# .nix

Nix configuration for my personal machines. Manages dev environments for NixOS.

## Prerequisites

Requires [NixOS](https://nixos.org/download.html).

## Install

```console
$ git clone https://codeberg.org/mian/nixos-config.git ~/.nix
$ cd ~/.nix
$ vim box/somebox/default.nix # add box-specific items, see others in box/*
$ vim flake.nix # add box config to nixosConfigurations
$ ./update_versions.sh
$ ./rebuild_system.sh
```

## Organization

| Location | Description |
| --- | --- |
| /box | Host-specific config items and top-level entrypoints for linking to `flake.nix.` NixOS `hardware-configuration.nix` lives here. |
| /common | Shared configs used by all boxes. |
| /home | User packages. |
| /modules | Custom nixos modules to mix in config sets. Exposed as `my.<option>.enable`, etc. |
| /system | Old system-level configs still in the process of being cleaned up and moved to /modules. |

## License: [Unlicense](./UNLICENSE)

This is free and unencumbered software released into the public domain.
