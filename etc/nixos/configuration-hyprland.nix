{ config, pkgs, inputs, ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = with pkgs; "${pkgs.hyprland}/bin/Hyprland";
        user = "laura";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    hyprland
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
