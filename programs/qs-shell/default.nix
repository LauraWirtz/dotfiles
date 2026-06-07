{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.programs.qs-shell;
in {
	imports = [
		# Importing other modules
	];

	options.programs.qs-shell = {
		enable = lib.mkEnableOption "Enable qs-shell";
	};

	config = lib.mkIf cfg.enable {
		#config contents
		systemd.user.services.qs-shell = {
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
			script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/programs/qs-shell/shell.qml";
		};
	};
}
