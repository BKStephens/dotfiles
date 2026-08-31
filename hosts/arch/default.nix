{ pkgs, ... }:

{
  # Linux user configuration
  # Change these if your user or home path differs on Arch
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # Better integration for non-NixOS Linux distributions
  targets.genericLinux.enable = true;

  # Nix configuration for standalone Home Manager
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
}
