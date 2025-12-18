{ config, lib, pkgs, ... }: {
	home.username = "laura";
	home.homeDirectory = "/home/laura";

	home.file = {
		".config/kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdeglobals";
		".config/fcitx5".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/fcitx5";
		".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/git/config";
	};

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.rose-pine-cursor;
		name = "BreezeX-RosePineDawn-Linux";
		size = 24;
	};
	gtk = {
		enable = true;
		colorScheme= "dark";
		theme.name = "Breeze-Dark";
		theme.package = pkgs.kdePackages.breeze-gtk;
		iconTheme.name = "Adwaita";
		iconTheme.package = pkgs.adwaita-icon-theme;
	};
	qt = {
		enable = true;
		platformTheme.name = "kde";
		style.name = "Breeze-dark";
	};

	home.stateVersion = "25.05";
}
