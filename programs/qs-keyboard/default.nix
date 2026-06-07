{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.programs.qs-keyboard;
in {
	imports = [
		# Importing other modules
	];

	options.programs.qs-keyboard = {
		enable = lib.mkEnableOption "Enable qs-keyboard";
	};

	config = lib.mkIf cfg.enable {
		#config contents
		systemd.user.services.qs-keyboard = {
			wantedBy = [ "graphical-session.target" ];
			path = [ pkgs.quickshell pkgs.ydotool ];
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
			script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/programs/qs-keyboard/shell.qml";
		};

        environment.systemPackages = with pkgs; [ quickshell ];
	};
}
