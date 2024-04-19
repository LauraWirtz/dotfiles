{ config, pkgs, ... }:
{
  networking.hostName = "laura-laptop";


  services.xserver.xkb.layout = "de";
  console.keyMap = "de";
  boot.kernelParams = [ "psmouse.synatics_intertouch=0" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
