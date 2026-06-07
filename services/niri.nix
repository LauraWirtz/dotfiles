{ config, pkgs, lib, ... }:
{
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

# 	systemd.user.services.niri.serviceConfig = {
# 		User="laura";
# 		Group="users";
#
# #		CapabilityboundingSet="";
# # 		DeviceAllow="char-gpu";
# 		NoNewPrivileges="yes";
# # 		PrivateDevices="yes";
# # 		PrivateNetwork="yes";
# 		PrivateTmp="yes";
# #  		ProtectSystem="strict";
# #		ProtectHome="read-only";
# 		ProtectKernelTunables="yes";
# 		ProtectKernelModules="yes";
# 		ProtectKernelLogs="yes";
# 		ProtectProc="invisible";
# # 		RestrictAddressFamilies="AF_UNIX";
# # 		RestrictNamespaces="yes";
# 		RestrictSUIDSGID="yes";
# # 		SystemCallArchitectures="native";
#
# 		ReadWritePaths="/etc/nixos";
# 	};

	environment.systemPackages = with pkgs; [
		xwayland-satellite
	];
}
