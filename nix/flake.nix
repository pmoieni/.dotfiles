{
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";

    # neovim overlay
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # hardware.url = "github:nixos/nixos-hardware";
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

      make-nix-packages = ps: attrs:
        import ps ({
          inherit system;
          config = {
            allowAliases = false;
            allowUnfree = true;
          };
        } // attrs);

      pkgs = make-nix-packages nixpkgs { };
      pkgs-unstable = make-nix-packages nixpkgs-unstable { };

      make-hm-packages = ps: attrs:
        import ps ({
          inherit system;
          config = {
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        } // attrs);

      hm-pkgs = make-hm-packages nixpkgs { };
      hm-pkgs-unstable = make-hm-packages nixpkgs-unstable { };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs pkgs pkgs-unstable; };
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "pmoieni@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = hm-pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            pkgs-unstable = hm-pkgs-unstable;
          };
          modules = [
            ./home-manager/home.nix
          ];
        };
      };
    };
}
