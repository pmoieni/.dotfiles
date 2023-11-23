{
    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

        # Nixpkgs unstable
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-23.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        
        # neovim overlay
        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

        # hardware.url = "github:nixos/nixos-hardware";
        # nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        ...
    } @ inputs: let
        inherit (self) outputs;
        system = "x86_64-linux";
        unstable = import inputs.nixpkgs-unstable {
            system = system;
            config.allowUnfree = true;
        };
    in {
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs unstable;};
                modules = [./nixos/configuration.nix];
            };
        };

        homeConfigurations = {
            "pmoieni@nixos" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = {inherit inputs outputs unstable;};
                modules = [./home-manager/home.nix];
            };
        };
    };
}
