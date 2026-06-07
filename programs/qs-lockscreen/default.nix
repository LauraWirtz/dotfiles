{ lib, pkgs, config, ...}:
with lib;
let
	cfg = config.programs.qs-lockscreen;
in {
	imports = [
		# Importing other modules
	];

	options.programs.qs-lockscreen = {
		enable = lib.mkEnableOption "Enable qs-lockscreen";
	};

	config = lib.mkIf cfg.enable {
		#config contents
		systemd.user.services.qs-lockscreen = {
			wantedBy = [ "graphical-session.target" ];
			path = [ pkgs.quickshell ];
			serviceConfig = {
				Restart="on-failure";
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
			script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/programs/qs-lockscreen/shell.qml";
		};
	};
}
