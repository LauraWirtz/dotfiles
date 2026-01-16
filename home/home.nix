{ config, lib, pkgs, ... }:
let
	desktopHide = "[Desktop Entry]\nType=Application\nHidden=true";
in {
	home.username = "laura";
	home.homeDirectory = "/home/laura";

	home.file = {
		".config/kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdeglobals";
		".config/kdedefaults/kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdedefaults/kdeglobals";
		".config/kdedefaults/package".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdedefaults/package";
		".config/fcitx5".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/fcitx5";
		".config/wpaperd".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/wpaperd";
		".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/git/config";

		".local/share/applications/foot-server.desktop".text = desktopHide;
		".local/share/applications/footclient.desktop".text = desktopHide;
		".local/share/applications/io.github.quodlibet.ExFalso.desktop".text = desktopHide;
		".local/share/applications/kbd-layout-viewer5.desktop".text = desktopHide;
		".local/share/applications/kdesystemsettings.desktop".text = desktopHide;
		".local/share/applications/systemsettings.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.fcitx5-migrator.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.fcitx5-config-qt.desktop".text = desktopHide;
		".local/share/applications/fcitx5-configtool.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.Fcitx5.desktop".text = desktopHide;
		".local/share/applications/org.kde.ark.desktop".text = desktopHide;
		".local/share/applications/org.kde.kwrite.desktop".text = desktopHide;
	};

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.kdePackages.breeze;
		name = "Breeze_Light";
		size = 24;
	};
	gtk = {
		enable = true;
		colorScheme= "dark";
		theme.name = "Breeze-Dark";
		theme.package = pkgs.kdePackages.breeze-gtk;
		iconTheme.name = "breeze-dark";
		iconTheme.package = pkgs.kdePackages.breeze-icons;
	};

	home.stateVersion = "25.05";
}
