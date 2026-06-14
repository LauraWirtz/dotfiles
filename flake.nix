{
	description = "Laura Base Flake";

	inputs = {
 		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

 		lanzaboote.url = "github:nix-community/lanzaboote/2a9c6ba61f2e1bd6eaf4e1e12aca77699bf7ea95";
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
					./programs
					./services
					./configuration/configuration.nix
					./configuration/pc.nix
					./hardware/pc.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./home/pc/home.nix
							];
						};
					}
				];
			};
			nixosConfigurations.laura-steamdeck = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					lanzaboote.nixosModules.lanzaboote
					./programs
					./services
					./configuration/configuration.nix
					./configuration/steamdeck.nix
					./hardware/steamdeck.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./home/steamdeck/home.nix
							];
						};
					}
				];
			};
		};
}
