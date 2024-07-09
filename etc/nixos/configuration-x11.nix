{ config, pkgs, inputs, ... }: {
  services.displayManager.sddm = {
	enable = true;
	autoLogin.enable = false;
	autoLogin.user = "laura";
	wayland.enable = true;
  };
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
}
