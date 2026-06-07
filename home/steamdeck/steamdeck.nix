{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/steamdeck.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/niri/steamdeck.kdl";
		".config/inputplumber/".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/steamdeck/inputplumber/";
	};
}
