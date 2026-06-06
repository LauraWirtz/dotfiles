{
	description = "Laura Base Flake";

	inputs = {
 		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

 		lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
		lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, lanzaboote, home-manager, ... }:
		let
			system = "x86_64-linux";
		in {
			nixosConfigurations.laura-pc = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					lanzaboote.nixosModules.lanzaboote
					./configuration/configuration.nix
					./configuration/pc.nix
					./hardware/pc.nix
					./niri/niri.nix
					./niri/pc.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./home/pc/home.nix
								./niri/home/home.nix
								./niri/home/pc.nix
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
			nixosConfigurations.laura-steamdeck = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					lanzaboote.nixosModules.lanzaboote
					./configuration/configuration.nix
					./configuration/steamdeck.nix
					./hardware/steamdeck.nix
					./niri/niri.nix
					./niri/steamdeck.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./niri/home/home.nix
								./niri/home/steamdeck.nix
							];
						};
					}
				];
			};
		};
}
