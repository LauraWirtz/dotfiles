{
	description = "Laura Base Flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/master";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... }:
		let
			system = "x86_64-linux";
		in {
			nixosConfigurations.laura-pc = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					({ config, pkgs, ... }: {
						nixpkgs.overlays = [
							(final: prev: {
								yuzu = import (builtins.fetchGit {
									url = "https://github.com/NixOS/nixpkgs/";
									rev = "619c4b605e267f2eae56458d72070d4726ae1a31";
								}) { inherit system; };
							})
						];
					})
					./configuration.nix
					./configuration-pc.nix
					./configuration-hyprland.nix
#					./configuration-plasma.nix
					./configuration-greetd-hypr.nix
#					./configuration-sddm.nix
#					./configuration-gnome.nix
					./hardware-pc.nix
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
					./configuration.nix
					./configuration-laptop.nix
					./configuration-hyprland.nix
					./configuration-greetd-hypr.nix
					./hardware-laptop.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home.nix
								./home-laptop.nix
							];
						};
					}
				];
			};

		};
}
