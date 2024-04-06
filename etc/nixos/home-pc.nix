{ config, lib, ... }: {
  home.file = {
    ".config/hypr/hyprland-specific.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland-pc.conf";
    ".config/hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprlock-pc.conf";
    ".config/wpaperd".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/wpaperd/pc";
  };
}
