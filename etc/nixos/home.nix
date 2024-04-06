{ config, lib, ... }: {
  home.username = "laura";
  home.homeDirectory = "/home/laura";

  home.file = {
    ".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland.conf";
    ".config/hypr/shaders".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/shaders";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/kitty";
    ".config/fcitx5".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/fcitx5";
    ".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/git/config";
  };

  home.stateVersion = "23.11";
}
