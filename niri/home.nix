{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/niri";
		".config/hypr/hypridle.conf".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/hypr/hypridle.conf";
		".local/share/icons/Breeze-dark".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark/";
	};
}
