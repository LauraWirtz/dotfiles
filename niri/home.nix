{ config, lib, pkgs, ... }: {
	home.file = {
		".config/niri/".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/niri";
		".config/hypr/hypridle.conf".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/hypr/hypridle.conf";
		".config/waybar/config.jsonc".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/waybar/config.jsonc";
		".config/waybar/style.css".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/waybar/style.css";
		".config/waybar/better-control-widget.sh".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "/etc/nixos/niri/.config/waybar/better-control-widget.sh";
		".config/waybar/icons".source = with pkgs; config.lib.file.mkOutOfStoreSymlink "${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark/";
	};
}
