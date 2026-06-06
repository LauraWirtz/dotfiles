{ config, pkgs, lib, ... }:
{
systemd.user.services.qs-postcards = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell ];
		serviceConfig = {
			Restart="always";
			RestartSec="1s";

			Nice=19;
			CPUWeight=1;
			IOWeight=1;

			User="laura";
			Group="users";

			CapabilityBoundingSet="";
			DeviceAllow="";
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

			BindReadOnlyPaths="/home/laura/Pictures/";
			BindPaths="/run/user/1000/ /home/laura/.cache/";
# 			TemporaryFileSystem="/home/laura:ro";
		};
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/postcards/shell.qml";
	};
	systemd.user.services.swaybg = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.swaybg ];
		serviceConfig = {
			Restart="always";
			RestartSec="1s";

			User="laura";
			Group="users";

			CapabilityBoundingSet="";
			DeviceAllow="";
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

# 			BindReadOnlyPaths="/run/user/1000/";
			BindPaths="/run/user/1000/";
# 			TemporaryFileSystem="/run/user/1000/";
		};
		script = "${pkgs.swaybg}/bin/swaybg -m fill -i /etc/nixos/home/background.png";
	};
}
