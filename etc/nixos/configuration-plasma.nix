{ config, pkgs, inputs, ... }: {
  services.displayManager.sddm = {
	enable = true;
	autoLogin.enable = true;
	autoLogin.user = "laura";
	wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    kate
    gwenview
    okular
    elisa
  ];
}
