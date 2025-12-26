{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/niri";
		".config/hypr/hypridle.conf".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/hypr/hypridle.conf";
		"/etc/nixos/quickshell/assets/breeze-icons".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark/";
	};
}
