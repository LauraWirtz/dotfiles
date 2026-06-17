{ config, lib, pkgs, ... }:
let
	desktopHide = "[Desktop Entry]\nType=Application\nHidden=true";
in {
	home.username = "laura";
	home.homeDirectory = "/home/laura";

	home.file = {
		".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/niri/config.kdl";

		".config/kdeglobals".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdeglobals";
		".config/kdedefaults/".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/kdedefaults/";
		".config/gtk-3.0/".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/gtk-3.0/";
		".config/gtk-4.0/".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/gtk-4.0/";
		".config/xsettingsd/".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/xsettingsd/";
		".gtkrc-2.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.gtkrc-2.0";

		".local/share/applications/fcitx5-configtool.desktop".text = desktopHide;
		".local/share/applications/foot-server.desktop".text = desktopHide;
		".local/share/applications/footclient.desktop".text = desktopHide;
		".local/share/applications/io.github.quodlibet.ExFalso.desktop".text = desktopHide;
		".local/share/applications/kbd-layout-viewer5.desktop".text = desktopHide;
		".local/share/applications/kdesystemsettings.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.fcitx5-migrator.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.fcitx5-config-qt.desktop".text = desktopHide;
		".local/share/applications/org.fcitx.Fcitx5.desktop".text = desktopHide;
		".local/share/applications/org.kde.ark.desktop".text = desktopHide;
		".local/share/applications/org.kde.kwrite.desktop".text = desktopHide;
		".local/share/applications/systemsettings.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.google.android.contacts.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.documentsui.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.vending.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.google.android.apps.messaging.desktop".text = desktopHide;
		".local/share/applications/waydroid.org.lineageos.recorder.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.gallery3d.desktop".text = desktopHide;
		".local/share/applications/waydroid.org.lineageos.jelly.desktop".text = desktopHide;
		".local/share/applications/waydroid.org.lineageos.eleven.desktop".text = desktopHide;
		".local/share/applications/waydroid.org.lineageos.etar.desktop".text = desktopHide;
		".local/share/applications/waydroid.org.lineageos.aperture.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.settings.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.calculator2.desktop".text = desktopHide;
		".local/share/applications/waydroid.com.android.deskclock.desktop".text = desktopHide;
		".local/share/applications/Waydroid.desktop".text = desktopHide;
	};

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.kdePackages.breeze;
		name = "Breeze_Light";
		size = 24;
	};

	dconf.settings = {
		"org/gnome/desktop/interface" = {
			gtk-theme = "Breeze-Dark";
			icon-theme = "breeze-dark";
			color-scheme = "prefer-dark";
		};
	};

	home.stateVersion = "25.05";
}
