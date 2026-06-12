{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.programs.qs-postcards;
in {
	imports = [
		# Importing other modules
	];

	options.programs.qs-postcards = {
		enable = lib.mkEnableOption "Enable qs-postcards";
		path = mkOption {
			type = types.str;
			default = "";
		};
	};

	config = lib.mkIf cfg.enable {
		#config contents
		systemd.user.services.qs-postcards = {
			wantedBy = [ "graphical-session.target" ];
			path = [ pkgs.quickshell ];
			environment = { QS_SOURCE = "${escapeShellArg cfg.path}"; };
			serviceConfig = {
				Restart="always";
				RestartSec="1s";

				Nice=19;
				CPUWeight=1;
				IOWeight=1;

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

				BindReadOnlyPaths="${escapeShellArg cfg.path}";
				BindPaths="/run/user/1000/ /home/laura/.cache/";
	# 			TemporaryFileSystem="/home/laura:ro";
			};
			script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/programs/qs-postcards/shell.qml";
		};
	};
}
