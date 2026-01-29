{ config, pkgs, lib, ... }:
{
	services.upower.enable = true;
	services.udisks2.enable = true;

	environment.pathsToLink = [
		"/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
	];

 	services.greetd = {
 		enable = lib.mkDefault true;
 		settings = rec {
			initial_session = {
				command = with pkgs; "${pkgs.niri}/bin/niri-session";
				user = "laura";
			};
			default_session = initial_session;
 		};
 	};

	programs.niri.enable = true;
	programs.niri.useNautilus = false;

	security.polkit.enable = true;

	xdg.portal.enable = true;
	xdg.portal.wlr.enable = true;
	xdg.portal.extraPortals = [
		pkgs.kdePackages.xdg-desktop-portal-kde
		pkgs.xdg-desktop-portal-gnome
		pkgs.xdg-desktop-portal-gtk
	];
	xdg.portal.configPackages = [ pkgs.kdePackages.plasma-workspace ];

	services.playerctld.enable = true;

	systemd.user.services.quickshell = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell pkgs.brightnessctl pkgs.wireplumber pkgs.dbus pkgs.sunsetr pkgs.tlp-pd];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/quickshell/shell.qml";
	};
	systemd.user.services.plasma-polkit-agent = {
		description = "KDE PolicyKit Authentication Agent";
		wantedBy = [ "graphical-session.target" ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
	};

	qt = {
		enable = true;
		platformTheme = "kde";
		style = "breeze";
	};
	environment.sessionVariables.XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		quickshell
		wpaperd
		sunsetr
		brightnessctl

		polkit
		kdePackages.polkit-kde-agent-1

# 		kdePackages.kirigami
# 		kdePackages.kirigami-addons
# 		kdePackages.qqc2-breeze-style
# 		kdePackages.qqc2-desktop-style
		kdePackages.kde-gtk-config
		kdePackages.libplasma
		kdePackages.plasma-integration
	];
}
