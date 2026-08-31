{
  description = "Cross-platform dotfiles (macOS + Arch Linux)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # macOS system configuration
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # User environment manager (used on both macOS and Arch Linux)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }: {
    # 1. macOS Target (nix-darwin + home-manager)
    darwinConfigurations."macbook" = darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # Set to "x86_64-darwin" for Intel Macs
      modules = [
        ./hosts/macbook
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users."ben.stephens" = import ./modules/home;
        }
      ];
    };

    # 2. Arch Linux Target (standalone home-manager)
    homeConfigurations."archlinux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        ./hosts/arch
        ./modules/home
      ];
    };
  };
}
