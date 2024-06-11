{ config, pkgs, ... }:
{
  networking.hostName = "laura-laptop";


  services.xserver.xkb.layout = "de";
  console.keyMap = "de";
  boot.kernelParams = [ "psmouse.synatics_intertouch=0" ];

  services.logind.lidSwitch = "hibernate";
  environment.systemPackages = [
    pkgs.tlp
  ];
}
