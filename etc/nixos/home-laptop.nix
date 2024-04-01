{ config, lib, ... }: {
  home.file = {
    ".config/hypr/hyprland-specific.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland-laptop.conf";
  };
}
