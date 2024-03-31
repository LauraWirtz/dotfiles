{ config, lib, ... }: {
  imports = [
    ./home.nix
  ];

  home.file = {
    ".config/hypr/hyprland-specific.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland-pc.conf";
    ".config/wpaperd".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/wpaperd";
  };

  home.stateVersion = "23.11";
}
