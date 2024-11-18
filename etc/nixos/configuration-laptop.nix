{ config, pkgs, ... }:
{
	networking.hostName = "laura-laptop";

		fileSystems."/etc/nixos" = {
		depends = [ "/home/laura/dotfiles/etc/nixos" ];
		device = "/home/laura/dotfiles/etc/nixos";
		fsType = "none";
		options = [ "bind"];
	};


	services.xserver.xkb.layout = "de";
	console.keyMap = "de";
	boot.kernelParams = [ "psmouse.synatics_intertouch=0" ];

	services.logind.lidSwitch = "hibernate";
	services.tlp.enable = true;
	services.tlp.settings = {
	START_CHARGE_THRESH_BAT0=60;
	STOP_CHARGE_THRESH_BAT0=80;
	};
	services.flatpak.enable = true;
}
