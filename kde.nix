{ config, pkgs, ... }:
{
	xdg.mime.enable = true;
	xdg.icons.enable = true;

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
		breeze-gtk

		ark
		kate
		ktexteditor
		dolphin
		dolphin-plugins
		ffmpegthumbs

		gwenview

		kio # provides helper service + a bunch of other stuff
		kio-admin # managing files as admin
		kio-extras # stuff for MTP, AFC, etc
		kio-fuse # fuse interface for KIO
		kio-extras-kf5
	];
}
