{ config, pkgs, inputs, ... }: {

	programs.hyprland.enable = true;
# 	services.hypridle.enable = true;

	environment.systemPackages = with pkgs; [
		fuzzel
		swaylock
		hyprnome
		wpaperd

		kdePackages.qtwayland
		kdePackages.qtsvg

		kdePackages.frameworkintegration
		kdePackages.kauth
		kdePackages.kcoreaddons
		kdePackages.kded
		kdePackages.kfilemetadata
		kdePackages.kiconthemes
		kdePackages.kimageformats
		kdePackages.qtimageformats
		kdePackages.kio
		kdePackages.kio-admin
		kdePackages.kio-extras
		kdePackages.kio-fuse
		kdePackages.kpackage
		kdePackages.kservice
		kdePackages.kunifiedpush
		kdePackages.kwallet
		kdePackages.kwallet-pam
		kdePackages.kwalletmanager

		kdePackages.kdegraphics-thumbnailers
		kdePackages.polkit-kde-agent-1

		kdePackages.libplasma

		kdePackages.breeze
		kdePackages.breeze-icons
		kdePackages.breeze-gtk

		kdePackages.kdeplasma-addons

		kdePackages.kcmutils

		kdePackages.konsole
		kdePackages.ark
		kdePackages.kate
		kdePackages.dolphin
		kdePackages.dolphin-plugins
		kdePackages.ffmpegthumbs
	];

	services.upower.enable = true;

	qt.enable = true;

	programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
	programs.kde-pim.enable = true;
	programs.ssh.askPassword = with pkgs; "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";

	services.udisks2.enable = true;

	xdg.icons.enable = true;
	xdg.icons.fallbackCursorThemes = ["breeze_cursors"];

	xdg.portal.enable = true;
	xdg.portal.extraPortals = with pkgs; [
		kdePackages.kwallet
		kdePackages.xdg-desktop-portal-kde
		pkgs.xdg-desktop-portal-gtk
	];

	security.pam.services = with pkgs; {
		login.kwallet = {
			enable = true;
			package = kdePackages.kwallet-pam;
		};
		kde = {
			allowNullPassword = true;
			kwallet = {
			enable = true;
			package = kdePackages.kwallet-pam;
			};
		};
	};

	system.userActivationScripts.rebuildSycoca = ''rm -fv "$HOME/.cache/ksycoca"*'';
	systemd.user.services.nixos-rebuild-sycoca = {
		description = "Rebuild KDE system configuration cache";
		wantedBy = [ "graphical-session-pre.target" ];
		serviceConfig.Type = "oneshot";
		script = ''rm -fv "$HOME/.cache/ksycoca"*'';
	};
}
