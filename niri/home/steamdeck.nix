{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/steamdeck.kdl".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/home/.config/niri/steamdeck.kdl";
	};
}
