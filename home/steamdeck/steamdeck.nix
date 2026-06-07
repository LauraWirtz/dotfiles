{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/steamdeck.kdl".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/niri/steamdeck.kdl";
		".config/inputplumber/".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/steamdeck/inputplumber/";
	};
}
