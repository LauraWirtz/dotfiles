{ config, lib, ... }: {
  home.username = "laura";
  home.homeDirectory = "/home/laura";

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName  = "LauraWirtz";
    userEmail = "lw.laura.wirtz@gmail.com";
    aliases = {
      cam = "commit -a -m";
    };
  };

  programs.kitty = {
    enable = true;
    font.name = "Nono Sans Mono";
    theme = "Catppuccin-Latte";
  };

  home.file = {
    ".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland.conf";
  };

  home.stateVersion = "23.11";
}
