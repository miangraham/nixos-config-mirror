{ pkgs, ... }:
{
  enable = true;
  package = pkgs.starship;
  settings = {
    aws.disabled = true;
    package.disabled = true;

    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold green)";
    };

    # cmd_duration.disabled = true;
    cmd_duration = {
      min_time = 5000;
    };
    # hostname.ssh_only = false;
    # username.show_always = true;
    # nix_shell.heuristic = true;

    # from https://starship.rs/presets/nerd-font.html
    aws.symbol = "  ";
    buf.symbol = " ";
    c.symbol = " ";
    conda.symbol = " ";
    dart.symbol = " ";
    docker_context.symbol = " ";
    elixir.symbol = " ";
    elm.symbol = " ";
    fossil_branch.symbol = " ";
    git_branch.symbol = " ";
    golang.symbol = " ";
    guix_shell.symbol = " ";
    haskell.symbol = " ";
    haxe.symbol = " ";
    hg_branch.symbol = " ";
    hostname.ssh_symbol = " ";
    java.symbol = " ";
    julia.symbol = " ";
    lua.symbol = " ";
    memory_usage.symbol = "󰍛 ";
    meson.symbol = "󰔷 ";
    nim.symbol = "󰆥 ";
    nix_shell.symbol = " ";
    nodejs.symbol = " ";
    package.symbol = "󰏗 ";
    pijul_channel.symbol = " ";
    python.symbol = " ";
    rlang.symbol = "󰟔 ";
    ruby.symbol = " ";
    rust.symbol = " ";
    scala.symbol = " ";

  };
}
