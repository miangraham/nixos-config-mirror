{ pkgs, ... }:
box: pkgs.writeShellScriptBin "${box}_deploy" ''
  set -e

  # Build
  mkdir -p ./builds
  nix build .#nixosConfigurations.${box}.config.system.build.toplevel --out-link ./builds/${box}
  OUTPUT=$(readlink ./builds/${box})
  echo "Built: ''${OUTPUT}"

  # Copy
  nix copy "''${OUTPUT}" --to ssh://ian@${box}

  # Switch profiles
  SWITCH_CMD="/run/current-system/sw/bin/nix-env -p /nix/var/nix/profiles/system --set ''${OUTPUT} && /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
  ssh -t ${box} "sudo sh -c \"''${SWITCH_CMD}\""
''
