{
	description = "Laura Base Flake";

	inputs = {
 		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
					./configuration/configuration.nix
					./configuration/pc.nix
					./hardware/pc.nix
					./niri/niri.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./home/pc/home.nix
								./niri/home.nix
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
					({ config, pkgs, ... }: { nixpkgs.overlays = [
						(final: prev:
							{
								extest = prev.extest.overrideAttrs (previousAttrs: rec {
									version = "0d068672fdaefd6f6565036ddd8e6949ee82eb63";
									src = prev.fetchFromGitHub {
										owner = "Supreeeme";
										repo = "extest";
										rev = "${version}";
										hash = "sha256-4SVZD0aHKsn97B5bhCf7URR6iQhJlYGALKWhDg+lGhU=";
									};
									cargoDeps = prev.rustPlatform.importCargoLock {
										lockFile = src + "/Cargo.lock";
										allowBuiltinFetchGit = true;
									};
									cargoHash = null;
								});
						})
						(final: prev:
							{
								wvkbd = prev.wvkbd.overrideAttrs (previousAttrs: rec {
									makeFlags = [ "LAYOUT=deskintl" ];
								});
						})
					]; })
					./configuration/configuration.nix
					./configuration/steamdeck.nix
					./hardware/steamdeck.nix
					./niri/niri.nix
 					./kde.nix
					./games.nix
					home-manager.nixosModules.home-manager {
						home-manager.users.laura = { pkgs, ... }: {
							imports = [
								./home/home.nix
								./niri/home.nix
							];
						};
					}
				];
			};
		};
}
