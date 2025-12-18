{ config, pkgs, ... }:
{
	xdg.mime.enable = true;
	xdg.icons.enable = true;

# 	xdg.portal.enable = true;
# 	xdg.portal.extraPortals = [
# 		pkgs.xdg-desktop-portal-gnome
# 		pkgs.xdg-desktop-portal-gtk
# 	];
# 	xdg.portal.wlr.enable = true;
# 	xdg.portal.configPackages = [ pkgs.gnome-session ];
# 	security.pam.services = {
# 		greetd.kwallet = {
# 			enable = true;
# 			forceRun = true;
# 			package = pkgs.kdePackages.kwallet-pam;
# 		};
# 	};

# 	services.gnome.gnome-keyring.enable = true;
# 	security.pam.services.greetd.enableGnomeKeyring = true;
# 	programs.seahorse.enable = true;


	environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
	system.userActivationScripts.rebuildSycoca = ''rm -fv "$HOME/.cache/ksycoca"*'';
	systemd.user.services.nixos-rebuild-sycoca = {
		description = "Rebuild KDE system configuration cache";
		wantedBy = [ "graphical-session-pre.target" ];
		serviceConfig.Type = "oneshot";
		script = ''rm -fv "$HOME/.cache/ksycoca"*'';
	};
	
	qt.enable = true;

	environment.systemPackages = with pkgs.kdePackages; [
		breeze
		breeze-icons

		ark
		kate
		dolphin
		dolphin-plugins
		ffmpegthumbs

		gwenview

# 		kauth
# 		kio
# 		kio-admin
# 		kwallet
# 		kwallet-pam
# 		kwalletmanager
# 		plasma-workspace
# 		polkit-kde-agent-1
# 		pkgs.libsecret
	];
}
