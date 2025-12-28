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
	xdg.portal.configPackages = [ pkgs.kdePackages.plasma-workspace ];

	services.hypridle.enable = true;
	systemd.user.services.hypridle.path = [ pkgs.quickshell ];
	systemd.user.services.hypridle.serviceConfig = { Restart="always"; };

	services.playerctld.enable = true;

	systemd.user.services.quickshell = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell pkgs.brightnessctl pkgs.wireplumber ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/quickshell/shell.qml";
	};

	systemd.user.services.wvkbd = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.wvkbd ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.wvkbd}/bin/wvkbd-deskintl --non-exclusive --hidden --fn \"Roboto Thin 24\" --bg 000000b0 --fg 000000b0 --fg-sp 000000b0 --text ffffffb0 --text-sp ffffffb0 --press e93a9ab0 --press-sp e93a9ab0";
	};

	systemd.user.services.plasma-polkit-agent = {
		description = "KDE PolicyKit Authentication Agent";
		wantedBy = [ "graphical-session.target" ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
	};

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		quickshell
		wpaperd
		wvkbd
		brightnessctl

		polkit
		kdePackages.polkit-kde-agent-1
	];
}
