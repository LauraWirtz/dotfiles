{ config, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    unstable-small.hypridle
    unstable-small.hyprland
    unstable-small.hyprlock
    unstable-small.hyprshade
    unstable-small.wpaperd

    unstable.anki

    firefox
    git
    kitty
    neofetch
#    pyenv
#    python3
    wget
    wofi

    ranger
#    nnn
#    lf
  ];

#  services.flatpak.enable = true;
  # Flatseal
  # Quod Libet
}

