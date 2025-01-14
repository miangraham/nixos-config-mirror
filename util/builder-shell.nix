{ inputs, system, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  deployCmd = import ./deploy-cmd.nix { inherit pkgs; };
  inherit (pkgs.lib.attrsets) mapAttrs' nameValuePair;
  deployCmds = with builtins; mapAttrs' (n: _: nameValuePair "${n}_deploy" (deployCmd n)) (readDir ../box);
in
pkgs.mkShell {
  name = "builder-shell";

  packages = with pkgs; [
    git
    nvd
  ];

  buildInputs = builtins.attrValues (deployCmds // {
    nixup = pkgs.writeShellScriptBin "nixup" ''
      set -e
      if [[ $(git status --porcelain) ]]; then
        echo "Outstanding git changes. Refusing to update."
        exit 1
      fi

      nix flake update
      git add flake.lock

      # Preview changes
      nixos-rebuild build --flake '.#'
      nvd diff /run/current-system ./result
      rm ./result
      read -r -p "Press ENTER to commit."

      git commit -m "version bump"
    '';

    dryrun_system = pkgs.writeShellScriptBin "dryrun_system" ''
      set -e
      nixos-rebuild dry-build --flake '.#' --show-trace
    '';

    diffbuild = pkgs.writeShellScriptBin "diffbuild" ''
      set -e
      nixos-rebuild build --flake '.#' --show-trace
      nvd diff /run/current-system ./result
      rm ./result
    '';

    rebuild_system = pkgs.writeShellScriptBin "rebuild_system" ''
      set -e
      sudo nixos-rebuild switch --flake '.#' --print-build-logs
      sudo nix store sign -k /var/keys/nix-cache-key.priv --all
    '';

    sdbuild = pkgs.writeShellScriptBin "sdbuild" ''
      set -e
      nix build .#nixosConfigurations.''${1}.config.system.build.sdImage --out-link ./builds/''${1}sdimage
    '';

    clean = pkgs.writeShellScriptBin "clean" ''
      set -e
      home-manager expire-generations '-14 days'
      sudo nix-collect-garbage --delete-older-than 14d

      home-manager generations
      sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    '';
  });
}
