{ config, pkgs, ... }:
{
	xdg.mime.enable = true;
	xdg.icons.enable = true;
	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
	xdg.portal.config = {
		preferred = {
			default = [ "kde" ];
			"org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
			"org.freedesktop.impl.portal.Screencast"= "none";
		};
	};
# 	xdg.portal.configPackages = [ pkgs.kdePackages.plasma-workspace ];

	environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
	system.userActivationScripts.rebuildSycoca = ''rm -fv "$HOME/.cache/ksycoca"*'';
	systemd.user.services.nixos-rebuild-sycoca = {
		description = "Rebuild KDE system configuration cache";
		wantedBy = [ "graphical-session-pre.target" ];
		serviceConfig.Type = "oneshot";
		script = ''rm -fv "$HOME/.cache/ksycoca"*'';
	};
	systemd.user.services.plasma-polkit-agent = {
		description = "KDE PolicyKit Authentication Agent";
		wantedBy = [ "graphical-session.target" ];
		serviceConfig = { Restart="always"; };
		script = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
	};

	environment.pathsToLink = [
		"/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
	];

	qt = {
		enable = true;
		platformTheme = "kde";
		style = "breeze";
	};

	environment.variables = {
		QT_STYLE_OVERRIDE = "breeze";
		QT_QPA_PLATFORMTHEME = "kde";
		XDG_CURRENT_DESKTOP = "KDE";
	};
	environment.sessionVariables.XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];

    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

	environment.systemPackages = with pkgs.kdePackages; [
		breeze
		breeze-icons
		breeze-gtk

		ark
		filelight
		gwenview
		kate
		ktexteditor
		partitionmanager

		ksystemstats
		plasma-systemmonitor

		dolphin
		dolphin-plugins
		ffmpegthumbs

 		kio # provides helper service + a bunch of other stuff
 		kio-admin # managing files as admin
 		kio-extras # stuff for MTP, AFC, etc
 		kio-fuse # fuse interface for KIO
 		kio-extras-kf5

# 		kirigami
# 		kirigami-addons
# 		qqc2-breeze-style
# 		qqc2-desktop-style
		kde-gtk-config
		libplasma
		plasma-integration

		pkgs.polkit
		polkit-kde-agent-1
	];
}
