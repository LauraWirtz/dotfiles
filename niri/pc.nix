{ config, pkgs, lib, ... }:
{
services.qs-postcards = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/postcards/shell.qml";
	};
}
