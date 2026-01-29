{ config, pkgs, lib, ... }:
{
services.qs-keyboard = {
		wantedBy = [ "graphical-session.target" ];
		path = [ pkgs.quickshell pkgs.ydotool ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.quickshell}/bin/quickshell --path /etc/nixos/niri/keyboard/shell.qml";
	};
}
