{ config, pkgs, inputs, ... }: {

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
#    hyprland
    hyprlock
    hyprnome
    hyprshade
    wpaperd

	kdePackages.breeze
	kdePackages.breeze-icons
	kdePackages.breeze-gtk

	kdePackages.qtwayland
	kdePackages.qtsvg
	
	kdePackages.dolphin
	kdePackages.dolphin-plugins
	kdePackages.ffmpegthumbs
	kdePackages.kdegraphics-thumbnailers
  ];
}
