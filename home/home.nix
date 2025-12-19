{ config, lib, pkgs, ... }:
let
	desktopHide = "[Desktop Entry]\nType=Application\nHidden=true";
in {
	home.username = "laura";
	home.homeDirectory = "/home/laura";

	home.file = {
		".config/kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdeglobals";
		".config/fcitx5".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/fcitx5";
		".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/git/config";

		".local/share/applications/foot-server.desktop".text = desktopHide;
		".local/share/applications/footclient.desktop".text = desktopHide;
		".local/share/applications/io.github.quodlibet.ExFalso.desktop".text = desktopHide;
		".local/share/applications/kbd-layout-viewer5.desktop".text = desktopHide;
		".local/share/applications/kdesystemsettings.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.fcitx5-migrator.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.Fcitx5.desktop".text = desktopHide;
		".local/share/applications/org.kde.kwrite.desktop".text = desktopHide;
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
