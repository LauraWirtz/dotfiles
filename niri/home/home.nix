{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/config.kdl".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/home/.config/niri/config.kdl";
	};
}
