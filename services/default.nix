{ config, pkgs, lib, ... }:
{
	imports = [
		./niri.nix
		./swaybg.nix
		./swayidle.nix
	];
}
