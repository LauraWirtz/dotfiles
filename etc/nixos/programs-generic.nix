{ pkgs, ... }: {

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
    qimgv
    wget

    fuzzel

    ranger
#    nnn
#    lf
  ];
}

