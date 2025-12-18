{ config, pkgs, ... }:
{
	programs.steam.enable = true;
	programs.gamescope.enable = true;
	environment.systemPackages = with pkgs; [
		dolphin-emu
		cemu
		ryubing
		melonDS
		gnome-mines
	];
}
