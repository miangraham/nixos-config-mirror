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

## License: CC0 [![License: CC0-1.0](https://licensebuttons.net/p/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/)

To the extent possible under law, [M. Ian Graham](https://github.com/miangraham) has waived all copyright and related or neighboring rights to dot-nix. This work is published from: Japan.
