{ config, lib, ... }: {
  home.file = {
    ".config/hypr/hyprland-specific.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland-pc.conf";
#    ".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hypridle.conf";
    ".config/wpaperd".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/wpaperd/pc";
    ".local/state/wireplumber".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.local/state/wireplumber";
    ".config/pipewire".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/pipewire";
  };
}
