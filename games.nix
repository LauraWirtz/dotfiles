{ config, pkgs, ... }:
{
	programs.steam.enable = true;
	programs.gamescope.enable = true;
	environment.systemPackages = with pkgs; [
		azahar
		dolphin-emu
		melonds
		eden
	];
}
