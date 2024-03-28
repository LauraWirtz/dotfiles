{ config, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
#    unstable.hypridle
    unstable.hyprland
    unstable.hyprlock
    unstable.hyprshade
    unstable.wpaperd

    unstable.anki

    firefox
    git
    kitty
    neofetch
#    pyenv
#    python3
    wget
#    wofi
    fuzzel

    ranger
#    nnn
#    lf
  ];

#  services.flatpak.enable = true;
  # Flatseal
  # Quod Libet
}

