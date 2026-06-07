{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.services.swaybg;
in {
	imports = [
		# Importing other modules
	];

	options.services.swaybg = {
		enable = lib.mkEnableOption "Enable swaybg systemd-service";
		path = mkOption {
			type = types.str;
			default = "";
		};
	};

	config = lib.mkIf cfg.enable {
		#config contents
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
			script = "${pkgs.swaybg}/bin/swaybg -m fill -i ${escapeShellArg cfg.path}";
		};
	};
}
