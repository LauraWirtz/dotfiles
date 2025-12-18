{ config, pkgs, ... }:
{
 	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;
	services.gnome.core-apps.enable = false;
 	services.gnome.core-developer-tools.enable = false;
	services.gnome.games.enable = false;
	environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs xterm ];
	
	environment.systemPackages = with pkgs; [
		gnome-extension-manager
		gnomeExtensions.gjs-osk
		gnomeExtensions.dash-to-panel
		gnomeExtensions.just-perfection
		gnomeExtensions.arcmenu
		gnomeExtensions.pip-on-top
		gnomeExtensions.battery-time-percentage-compact

		gnome-text-editor
		gnome-console
		nautilus
		gnome-tweaks
	];
}
