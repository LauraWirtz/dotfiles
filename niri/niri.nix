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
	systemd.services.greetd.serviceConfig = {
# 		User="laura";
# 		Group="users";

# 		CapabilityboundingSet="";
# 		DeviceAllow="";
		NoNewPrivileges="yes";
# 		PrivateDevices="yes";
		PrivateNetwork="yes";
		PrivateTmp="yes";
 		ProtectSystem="strict";
		ProtectHome="read-only";
		ProtectKernelTunables="yes";
		ProtectKernelModules="yes";
		ProtectKernelLogs="yes";
		ProtectProc="invisible";
# 		RestrictAddressFamilies="AF_UNIX";
# 		RestrictNamespaces="yes";
		RestrictSUIDSGID="yes";
		SystemCallArchitectures="native";

# 		BindPaths="/run/user/1000/";
	};

	programs.niri.enable = true;
	programs.niri.package = pkgs.niri.override {withScreencastSupport = false;};
	programs.niri.useNautilus = false;
	services.gnome.gnome-keyring.enable = false;
	xdg.portal.config.niri = lib.mkForce {};
	xdg.portal.extraPortals = lib.mkDefault [];

	security.polkit.enable = true;

	systemd.user.services.niri.serviceConfig = {
		User="laura";
		Group="users";

#		CapabilityboundingSet="";
# 		DeviceAllow="char-gpu";
		NoNewPrivileges="yes";
# 		PrivateDevices="yes";
# 		PrivateNetwork="yes";
		PrivateTmp="yes";
#  		ProtectSystem="strict";
#		ProtectHome="read-only";
		ProtectKernelTunables="yes";
		ProtectKernelModules="yes";
		ProtectKernelLogs="yes";
		ProtectProc="invisible";
# 		RestrictAddressFamilies="AF_UNIX";
# 		RestrictNamespaces="yes";
		RestrictSUIDSGID="yes";
# 		SystemCallArchitectures="native";

		ReadWritePaths="/etc/nixos";
	};
	systemd.user.services.quickshell = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell pkgs.brightnessctl pkgs.wireplumber pkgs.dbus pkgs.sunsetr pkgs.tlp-pd pkgs.quodlibet pkgs.swayidle ];
		serviceConfig = {
			Restart="always";
			RestartSec="1s";

			User="laura";
			Group="users";

			CapabilityBoundingSet="";
			DeviceAllow="char-gpu";
			NoNewPrivileges="yes";
			PrivateDevices="yes";
			PrivateNetwork="yes";
			PrivateTmp="yes";
			ProtectSystem="strict";
			ProtectHome="tmpfs";
			ProtectKernelTunables="yes";
			ProtectKernelModules="yes";
			ProtectKernelLogs="yes";
			ProtectProc="invisible";
			RestrictAddressFamilies="AF_UNIX";
			RestrictNamespaces="yes";
			RestrictSUIDSGID="yes";
			SystemCallArchitectures="native";

			BindReadOnlyPaths="-/home/laura/.config/quodlibet/ -/home/laura/.local/share/applications/ -/home/laura/.icons/";
			BindPaths="/run/user/1000/ /home/laura/.cache/";
# 			TemporaryFileSystem="/home/laura:ro";
		};
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/quickshell/shell.qml";
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
		sunsetr
		brightnessctl
		swaybg

		polkit
		kdePackages.polkit-kde-agent-1
	];
}
