{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/pc.kdl".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/home/.config/niri/pc.kdl";
	};
}
