{ config, pkgs, ... }:

{
  home.packages = [ pkgs.neovim ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Link Neovim configuration directly to the live dotfiles repo
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/config/nvim";
  };
}
