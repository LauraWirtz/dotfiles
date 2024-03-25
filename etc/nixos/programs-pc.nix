{ config, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    unstable.dolphin-emu-beta
    quodlibet
    steam
  ];

#  programs.steam.enable = true;
}

