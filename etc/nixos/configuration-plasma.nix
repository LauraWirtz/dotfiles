{ config, pkgs, inputs, ... }: {
  services.desktopManager.plasma6.enable = true;
#  services.displayManager.defaultSession = "plasma";
  services.xserver.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kate
    gwenview
    okular
    elisa
  ];
}
