{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
  ];

  # Cross-platform CLI packages installed into user profile
  home.packages = with pkgs; [
    bat
    eza
    fd
    fzf
    htop
    jq
    nodejs
    ripgrep
    silver-searcher-ng
    tree
    zoxide
  ];

  # Path configuration across platforms
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.asdf/shims"
    "$HOME/.dotnet/tools"
    "$HOME/.docker/bin"
    "$HOME/.yarn/bin"
    "/usr/local/share/dotnet"
    "/opt/homebrew/opt/postgresql@14/bin"
    "/opt/homebrew/opt/openjdk@11/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # Link custom executable scripts and files
  home.file."bin".source = ../../bin;
  home.file.".psqlrc".source = ../../psqlrc;
  home.file.".hushlogin".source = ../../hushlogin;
  home.file.".asdfrc".source = ../../asdfrc;

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # Used by Home Manager to track backwards compatibility
  home.stateVersion = "24.11";
}
