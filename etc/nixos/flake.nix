{
	description = "Laura Base Flake";

	inputs = {
 		nixpkgs.url = "github:NixOS/nixpkgs/master";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		nixpkgs-floorp.url = "github:NixOS/nixpkgs/d1bc54ae6c7870053c5038710de8a9847b434700";
	};

	outputs = { self, nixpkgs, home-manager, nixpkgs-floorp, ... }:
		let
			system = "x86_64-linux";
			overlay-floorp = final: prev: { floorp = import nixpkgs-floorp { inherit system; }; };
		in {
			nixosConfigurations.laura-pc = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-floorp ]; })
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
