{ config, pkgs, inputs, ... }: {
  services.displayManager.sddm = {
	enable = true;
	autoLogin.enable = false;
	autoLogin.user = "laura";
	wayland.enable = false;
  };
  services.xserver.enable = true;
  environment.systemPackages = [
    pkgs.hypr
  ];
}
