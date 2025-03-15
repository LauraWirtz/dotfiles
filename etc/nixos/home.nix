{ config, lib, pkgs, ... }: {
	home.username = "laura";
	home.homeDirectory = "/home/laura";

	home.file = {
		".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland.conf";
		".config/hypr/shaders".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/shaders";
		".config/hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprlock-pc.conf";
		".config/hypr/hyprshade.toml".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprshade.toml";
		".config/fcitx5".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/fcitx5";
		".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/git/config";
		".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/kitty";
		".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/nvim";
	};

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.rose-pine-cursor;
		name = "BreezeX-RosePineDawn-Linux";
		size = 24;
	};
	gtk.enable = true;
  
	home.stateVersion = "23.11";
}
