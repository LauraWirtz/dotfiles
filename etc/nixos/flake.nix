{
  description = "Laura Base Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
      };
    in {
      nixosConfigurations.laura-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          ./configuration-pc.nix
          ./hardware-pc.nix
          ./programs-generic.nix
          ./programs-pc.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.laura = { pkgs, ... }: {
              imports = [
                ./home.nix
                ./home-pc.nix
              ];
            };
          }
        ];
      };
      nixosConfigurations.laura-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          ./configuration-laptop.nix
          ./hardware-laptop.nix
          ./programs-generic.nix
#          ./programs-laptop.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.laura = { pkgs, ... }: {
              imports = [
                ./home.nix
                ./home-pc.nix
              ];
            };
          }
        ];
      };

    };
}
