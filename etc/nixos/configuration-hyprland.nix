{ config, pkgs, inputs, ... }: {

	programs.hyprland.enable = true;
# 	services.hypridle.enable = true;

	environment.systemPackages = with pkgs; [
		fuzzel
		swaylock
		hyprnome
		hyprshade
		wpaperd

		kdePackages.breeze
		kdePackages.breeze-icons
		kdePackages.breeze-gtk

		kdePackages.qtwayland
		kdePackages.qtsvg


		kdePackages.polkit-kde-agent-1
		kdePackages.kservice


		kdePackages.dolphin
		kdePackages.dolphin-plugins
		kdePackages.ffmpegthumbs
		kdePackages.kdegraphics-thumbnailers
		kdePackages.konsole

		kdePackages.kate
	];
}
