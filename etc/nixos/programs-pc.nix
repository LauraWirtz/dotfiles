{ config, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    unstable.dolphin-emu-beta
    quodlibet
    steam
    yuzu-mainline

    qmk
  ];

#  programs.steam.enable = true;
}

