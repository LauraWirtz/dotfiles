{ config, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    unstable.dolphin-emu-beta
    quodlibet
  ];

  programs.steam.enable = true;
}

