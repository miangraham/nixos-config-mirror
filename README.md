# .nix

Nix configuration for my personal machines. Manages dev environments for NixOS.

## Prerequisites

Requires [NixOS](https://nixos.org/download.html).

## Install

```console
$ git clone https://github.com/miangraham/nixos-config.git ~/.nix
$ cd ~/.nix
$ vim box/somebox/default.nix
$ vim flake.nix # add box config to nixosConfigurations
$ ./update_versions.sh
$ ./rebuild_system.sh
```

## Organization

| Location | Description |
| --- | --- |
| /box | Machine-specific config items and top-level entrypoints for linking to `flake.nix.` NixOS `hardware-configuration.nix` lives here. |
| /common | Shared configs used by all boxes. |
| /home | User packages. |
| /system | Shared system-level configs. |

## License: [Unlicense](./UNLICENSE)

This is free and unencumbered software released into the public domain.
