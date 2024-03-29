{
  description = "Laura Base Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
#    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
      };
#      overlay-unstable-small = final: prev: {
#        unstable-small = import nixpkgs-unstable-small { inherit system; };
#      };
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
            home-manager.users.laura = import ./home.nix;
          }
        ];
      };
    };
}
