{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.services.swayidle;
in {
	imports = [
		# Importing other modules
	];

	options.services.swayidle = {
		enable = lib.mkEnableOption "Enable swayidle systemd-service";
		config = mkOption {
			type = types.str;
			default = "";
		};
	};

	config = lib.mkIf cfg.enable {
		#config contents
		systemd.user.services.swayidle = {
			wantedBy = [ "graphical-session.target" ];
			path = [ pkgs.swayidle pkgs.systemd ];
			serviceConfig = {
				Restart="always";
				RestartSec="1s";

				User="laura";
				Group="users";
	# 			JoinsNamespaceOf="user@1000.service";

	# 			CapabilityBoundingSet="";
				DeviceAllow="char-gpu";
	# 			NoNewPrivileges="yes";
	# 			PrivateDevices="yes";
	# 			PrivateNetwork="yes";
	# 			PrivateTmp="yes";
	# 			ProtectSystem="strict";
	# 			ProtectHome="tmpfs";
	# 			ProtectKernelTunables="yes";
	# 			ProtectKernelModules="yes";
	# 			ProtectKernelLogs="yes";
	# 			ProtectProc="invisible";
	# 			RestrictAddressFamilies="AF_UNIX";
	# 			RestrictNamespaces="yes";
	# 			RestrictSUIDSGID="yes";
	# 			SystemCallArchitectures="native";
	#
	# 			BindReadOnlyPaths="-/home/laura/.config/quodlibet/ -/home/laura/.local/share/applications/ -/home/laura/.icons/";
	# 			BindPaths="/run/user/1000/ /home/laura/.cache/";
	# 			TemporaryFileSystem="/home/laura/.cache/";
			};
			script = "${pkgs.swayidle}/bin/swayidle ${escapeShellArg cfg.config}";
		};
	};
}
