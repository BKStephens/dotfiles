{ config, pkgs, ... }:

{
  # Linux user configuration
  # Change these if your user or home path differs on Arch
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # Better integration for non-NixOS Linux distributions
  targets.genericLinux.enable = true;

  # Arch Linux / Hyprland specific configuration overrides
  # Omarchy manages all system defaults in ~/.config natively; we only link user overrides here
  xdg.configFile = {
    "hypr/input.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/config/hypr/input.lua";
  };

  # Nix configuration for standalone Home Manager
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
}
