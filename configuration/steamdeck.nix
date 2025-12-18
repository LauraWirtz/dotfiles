{ config, pkgs, ... }:
{
	powerManagement = {
		enable = true;
		scsiLinkPolicy = "med_power_with_dipm";
		cpufreq.min = 419175;
		cpuFreqGovernor = "ondemand";
	};
	services.power-profiles-daemon.enable = false;
	powerManagement.powertop.enable = true;

	networking.hostName = "laura-steamdeck";

	services.logind.powerKey = "suspend";

	services.xserver.xkb.layout = "us, de";

	hardware.bluetooth.enable = true;

	programs.steam.enable = true;
	programs.gamescope.enable = true;
	programs.steam.extest.enable = true;
	services.inputplumber.enable = true;

	environment.systemPackages = with pkgs; [
		powertop
	];
}
