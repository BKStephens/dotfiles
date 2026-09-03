{ config, pkgs, ... }:

{
  home.packages = [ pkgs.tmux ];

  # Link Tmux configuration directly to the live dotfiles repo
  xdg.configFile."tmux/tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/config/tmux/tmux.conf";
  };
}
