{ pkgs, ... }:

{
  # Disable nix-darwin daemon management since Determinate installer manages it
  nix.enable = false;

  # zsh is the default shell
  programs.zsh.enable = true;

  # macOS primary user account configuration
  system.primaryUser = "ben.stephens";
  users.users."ben.stephens" = {
    name = "ben.stephens";
    home = "/Users/ben.stephens";
  };

  # Corporate CA certificate environment variables
  environment.variables = {
    REQUESTS_CA_BUNDLE = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
    NODE_EXTRA_CA_CERTS = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
    SSL_CERT_FILE = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
    AWS_CA_BUNDLE = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
    CURL_CA_BUNDLE = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
    HTTPLIB2_CA_CERTS = "/Library/Application Support/DocuSign/zscaler-ca-bundle.pem";
  };

  # Homebrew declarative management (GUI apps and macOS casks)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none"; # Change to "zap" or "uninstall" if you want full declarative control
    };
    taps = [];
    brews = [];
    casks = [
      # Examples of GUI apps on macOS:
      # "ghostty"
      # "1password"
      # "raycast"
    ];
  };

  # macOS system preferences / defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
