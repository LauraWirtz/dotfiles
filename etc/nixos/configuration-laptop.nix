{ config, pkgs, ... }:
{
  networking.hostName = "laura-laptop";


  services.xserver = {
    layout = "de";
  };
  console.keyMap = "de";


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
